//
//  DataTable.m
//  AppOnline
//
//  Created by user on 2/27/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "DataTable.h"
#import <Crashlytics/Crashlytics.h>

@implementation DataTable
{
    /// @description this is similar to the schema
    NSManagedObjectModel *model;
    
    /// @description this is the actual refrence context to the table
    NSManagedObjectContext *context;
    
    /// @description this is the storage type
    NSString *storeType;
    
    /// @description this is the name of the table
    NSString *datatableName;
    
    /// @description this is the refrence to all the columns name in the datatable
    ///
    /// Note: columnNames[0] = self.columnSerialNumberName this is just the dafault serial number and will be present in all tables!
    NSMutableArray *columnNames;
}

- (NSString *)columnSerialNumberName
{
    return @"RowIndex";
}

- (id)init
{
    self = [super init];
    if (self)
    {
        model = [[NSManagedObjectModel alloc] init];
        storeType = NSInMemoryStoreType;
    }
    return self;
}

- (id)initWithStorageType:(NSString *)storageType
{
    self = [super init];
    if (self)
    {
        model = [[NSManagedObjectModel alloc] init];
        storeType = storageType;
    }
    return self;
}

/// @description initilize the context object relative to the schema
/// @returns returns YES if init is successfull
- (BOOL)InitContext
{
    BOOL contextInit = NO;
    if (model == nil){
        NSLog(@"");
        
    }
    if (context == nil)
    {
       
        context = [[NSManagedObjectContext alloc] init];
        //MARK:-Crash here while running inprocess game
        //model is nil
        context.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        [context.persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:nil options:nil error:&error];
        if (!error)
            contextInit = YES;
        context.undoManager = [[NSUndoManager alloc] init];
    }
    else
        contextInit = YES;
    
    return contextInit;
}

/// @description deinitialize the context object and related storage system
/// @returns returns YES if all deinitization is successfull
- (BOOL)DeinitContext:(BOOL)isPermanentRemoval
{
    BOOL deinitContext = NO;
    if (context != nil)
    {
        NSError *error = nil;
        
        [context reset];
        
        for (NSPersistentStore *store in [context.persistentStoreCoordinator persistentStores])
            [context.persistentStoreCoordinator removePersistentStore:store error:&error];
        
        context = nil;
        
        if (isPermanentRemoval)
        {
            model = nil;
        }
        else
        {
            NSArray *allTables = [model entities];
            model = nil;
            model = [[NSManagedObjectModel alloc] init];

            for (NSEntityDescription *table in allTables)
            {
                NSEntityDescription *tableEntity = [[NSEntityDescription alloc] init];
                [tableEntity setName:[table name]];
                
                NSMutableArray* entities = [[NSMutableArray alloc] initWithArray:[model entities]];
                [entities addObject:tableEntity];
                [model setEntities:entities];
                
                for (NSAttributeDescription *column in [table properties])
                {
                    NSAttributeDescription *col = [[NSAttributeDescription alloc] init];
                    [col setName:[column name]];
                    [col setAttributeType:[column attributeType]];
                    [col setOptional:NO];
                    [col setDefaultValue:@""];
                    
                    NSMutableArray *newColumns = [[NSMutableArray alloc] initWithArray:[[tableEntity propertiesByName] allValues]];
                    [newColumns addObject:col];
                    [tableEntity setProperties:newColumns];
                }
            }
        }
        deinitContext = YES;
    }
    else
        deinitContext = YES;
    
    return deinitContext;
}

- (BOOL)InitColumns
{
    BOOL columnsInit = NO;
    
    if (columnNames != nil)
    {
        [columnNames removeAllObjects];
        columnNames = nil;
    }
    
    if (columnNames == nil)
    {
        columnNames = [[NSMutableArray alloc] init];

        if (![self AddColumnToTable:self.columnSerialNumberName ColumnType:NSStringAttributeType AllowNilValues:NO ColumnDefaultValue:@""])
        {
            if (columnNames.count > 0)
                [columnNames removeAllObjects];
        }
        else
            columnsInit = YES;
    }
    
    return columnsInit;
}


- (BOOL)CreateNewTableWithName:(NSString *)tableName
{
    BOOL tableCreated = NO;
    
    if ([self DeinitContext:NO])
        if (![self DoesTableExists:tableName])
        {
            NSEntityDescription *tableEntity = [[NSEntityDescription alloc] init];
            [tableEntity setName:tableName];
            
            NSMutableArray* entities = [[NSMutableArray alloc] initWithArray:[model entities]];
            [entities addObject:tableEntity];
            [model setEntities:entities];
            
            datatableName = tableName;
            
            if ([self InitColumns])
                tableCreated = YES;
        }

    return tableCreated;
}

- (BOOL)RemoveTable:(BOOL)isPermanentRemove;
{
    BOOL tableRemoved = NO;
    
    if (isPermanentRemove)
    {
        [self DeinitContext:YES];
        datatableName = [NSString Empty];
        
        tableRemoved = YES;
    }
    else
    {
        if ([self DeinitContext:NO])
            if ([self DoesTableExists:datatableName])
            {
                
                NSMutableDictionary *entities = [[NSMutableDictionary alloc] initWithDictionary:[model entitiesByName]];
                [entities removeObjectForKey:datatableName];
                [model setEntities:[entities allValues]];
                
                datatableName = [NSString Empty];
                
                tableRemoved = YES;
            }
    }
    return tableRemoved;
}


- (BOOL)DoesTableExists:(NSString*)tableName
{
    BOOL tableExists = NO;
    
    if ([[model entitiesByName] objectForKey:tableName] != nil)
        tableExists = YES;
    
    return tableExists;
}

- (NSString *)GetTableName
{
    if (datatableName != nil && datatableName.isEmptyOrWhiteSpaces)
        return datatableName;
    
    return @"";
}

- (int)NumberOfRowsInTable
{
    NSArray *rows = [self FetchAllRowsFromTable];
    if (rows != nil)
        return (int)[rows count];
    // todo
    return 0;
}

- (int)NumberOfColsInTable
{
    if (columnNames != nil)
        return (int)columnNames.count;

    return 0;
}

- (BOOL)AddColumnToTable:(NSString *)columnName ColumnType:(NSAttributeType)columnType AllowNilValues:(BOOL)allowNilValue ColumnDefaultValue:(id)defaultValue
{
    BOOL columnAdded = NO;
    
    if (![columnNames containsObject:columnName])
    {
        if ([self DeinitContext:NO])
        {
            NSDictionary *tables = [model entitiesByName];
            NSEntityDescription *table = [tables objectForKey:datatableName];
            if (table)
            {
                NSDictionary *columns = [table propertiesByName];
                if ([columns objectForKey:columnName] == nil)
                {
                    NSAttributeDescription *col = [[NSAttributeDescription alloc] init];
                    [col setName:columnName];
                    [col setAttributeType:columnType];
                    [col setOptional:allowNilValue];
                    [col setDefaultValue:defaultValue];
                    
                    NSMutableArray *newColumns = [[NSMutableArray alloc] initWithArray:[columns allValues]];
                    [newColumns addObject:col];
                    [table setProperties:newColumns];
                    
                    [columnNames addObject:columnName];
                    
                    columnAdded = YES;
                }
            }
        }
    }
    return columnAdded;
}

- (BOOL)RemoveColumnFromTable:(NSString*)columnName
{
    BOOL columnRemoved = NO;

    if ([columnNames containsObject:columnName])
    {
        if ([self DeinitContext:NO])
        {
            NSDictionary *tables = [model entitiesByName];
            NSEntityDescription *table = [tables objectForKey:datatableName];
            if (table)
            {
                NSMutableDictionary *columns = (NSMutableDictionary*)[table propertiesByName];
                if ([columns objectForKey:columnName] != nil)
                {
                    [columns removeObjectForKey:columnName];
                    NSMutableArray *newColumns = (NSMutableArray*)[columns allValues];
                    [table setProperties:newColumns];
                    
                    if (columnNames != nil)
                        [columnNames removeObject:columnName];
                    
                    columnRemoved = YES;
                }
            }
        }
    }
    
    return columnRemoved;
}

- (BOOL)DoesColumnExists:(NSString*)columnName
{
    BOOL columnExist = NO;
    
    if (columnNames != nil)
        return [columnNames containsObject:columnName];
    
    return columnExist;
}

- (NSArray *)GetColumnsName
{
    if (columnNames != nil)
        return columnNames;
    
    return nil;
}


- (BOOL)AddRowToTable:(NSArray*)row
{
    BOOL rowAdded = NO;
    
    if (row.count == columnNames.count - 1)
    {
        if ([self InitContext])
        {
            NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
            if (table != nil)
            {
                
                    NSManagedObject *rowItem = [NSEntityDescription insertNewObjectForEntityForName:[table name] inManagedObjectContext:context];
                    
                    [rowItem setValue:[NSString stringWithFormat:@"%i", ([self NumberOfRowsInTable] - 1)] forKey:self.columnSerialNumberName];
                    
                    for (int i = 0; i < [row count]; i++)
                        [rowItem setValue:row[i] forKey:columnNames[i + 1]];
                    
                    NSError *error = nil;
                    [context save:&error];
                    if (!error)
                        rowAdded = YES;
            }            
        }
    }
    return rowAdded;
}

- (BOOL)RemoveAllRowFromTable
{
    BOOL allRowsRemoved = NO;
    
    if ([self InitContext])
    {
        NSArray *rows = [self FetchAllRowsFromTable];
        for (NSManagedObject *row in rows)
        {
            [context deleteObject:row];
        }
        NSError *error = nil;
        [context save:&error];
        if (!error)
            allRowsRemoved = YES;
    }

    return allRowsRemoved;
}

- (BOOL)RemoveRowAtIndexFromTable:(int)rowIndex
{
    BOOL rowRemoved = NO;
    
    if ([self InitContext])
    {
        NSArray *rows = [self FetchAllRowsFromTable];
        if (rowIndex >= 0 && rowIndex < [rows count])
        {
            NSString *index = [NSString stringWithFormat:@"%i", rowIndex];
            for (NSManagedObject *row in rows)
            {
                if ([[row valueForKey:self.columnSerialNumberName] isEqualToString:index])
                {
                    [context deleteObject:row];
                    break;
                }
            }
        }
        NSError *error = nil;
        [context save:&error];
        if (!error)
            rowRemoved = YES;
    }
    
    return rowRemoved;
}

- (NSArray *)FetchAllRowsFromTable
{
    if ([self InitContext])
    {
        NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
        if (table != nil)
        {
            NSError *error = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:datatableName];
            NSArray *rows = [context executeFetchRequest:request error:&error];
            if (!error)
            {
//                if (rows.count == 1)
//                {
//                    NSManagedObject *row = rows[0];
//                    if ([[row valueForKey:columnNames[0]] isEqualToString:@""])
//                        return 0;
//                }
                return rows;
            }
        }
    }
    return nil;
}

- (NSArray *)FetchRowsAgainstQuery:(NSFetchRequest *)query
{
    if ([self InitContext])
    {
        NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
        [query setEntity:table];
        if (table != nil)
        {
            NSError *error = nil;
            NSArray *rows = [context executeFetchRequest:query error:&error];
            if (!error)
                return rows;
        }
    }
    
    return nil;
}

- (NSManagedObject*)FetchRowAtIndexFromTable:(int)rowIndex
{
    if ([self InitContext])
    {
        NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
        if (table != nil)
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:datatableName];
            NSString *query = [NSString stringWithFormat:@"%@ LIKE \'%@\'", self.columnSerialNumberName, @(rowIndex)];
            [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", query]]];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.columnSerialNumberName ascending:YES];
            [request setSortDescriptors:@[sort]];
            NSArray *rows = [self FetchRowsAgainstQuery:request];
            if (rows.count > 0)
                return rows[0];
        }
    }
    
    return nil;
}

//MARK:- Some times crash here
- (NSString*)FetchColumnValueOfRowAtIndexFromTable:(int)rowIndex ColumnName:(NSString*)columnName
{
    if ([self InitContext])
    {
        NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
        if (table != nil)
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:datatableName];
            NSString *query = [NSString stringWithFormat:@"%@ LIKE \'%@\'", self.columnSerialNumberName, @(rowIndex)];
            [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", query]]];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.columnSerialNumberName ascending:YES];
            [request setSortDescriptors:@[sort]];
            NSArray *rows = [self FetchRowsAgainstQuery:request];
            if (rows.count > 0){
                //CLS_LOG(@"columnName ==>> %@ -> %@", (NSString*)[(rows[0]) valueForKey:columnName],columnName);
               // NSDictionary *dictionary = [rows indexKeyedDictionary];
                
                NSArray *keys = [[[rows[0] entity] attributesByName] allKeys];
                NSDictionary *dict = [rows[0] dictionaryWithValuesForKeys:keys];
                NSArray *keys1 = [dict allKeys];
                NSString* kKeyToCheck = columnName;
                if (dict[kKeyToCheck]){
                    NSString *str = (NSString*)[(rows[0]) valueForKey:columnName];
                    return  str ? str : @"";
                }
                else{
                    NSLog(@"Key pair do not exits for key: %@");
                }
                
                
               
            }
        }
    }
    
    return [NSString Empty];
}

- (BOOL)UpdateColumnValueForRowAtIndexInTable:(int)rowIndex ColumnName:(NSString*)columnName NewValue:(NSString*)value
{
    BOOL columnValueUpdated = NO;
    
    if ([self InitContext])
    {
        NSEntityDescription *table = [NSEntityDescription entityForName:datatableName inManagedObjectContext:context];
        if (table != nil)
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:datatableName];
            NSString *query = [NSString stringWithFormat:@"%@ LIKE \'%@\'", self.columnSerialNumberName, @(rowIndex)];
            [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@", query]]];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.columnSerialNumberName ascending:YES];
            [request setSortDescriptors:@[sort]];
            NSArray *rows = [self FetchRowsAgainstQuery:request];
            if (rows.count > 0)
            {
                NSManagedObject *row = rows[0];
                [row setValue:value forKey:columnName];
                NSError *error = nil;
                [context save:&error];
                if (!error)
                    columnValueUpdated = YES;
            }
        }
    }
    
    return columnValueUpdated;
}

@end

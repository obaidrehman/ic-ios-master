//
//  DataTable.h
//  AppOnline
//
//  Created by user on 2/27/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonTasks.h"


/// @description this class represents datatable, use this for a single datatable instance only, not safe for multiple tables i.e DataSets
@interface DataTable : NSObject

@property (strong, readonly) NSString* columnSerialNumberName;

/// @description init with storage type
/// @param storageType this is the storage type
/// @returns the instance
- (id)initWithStorageType:(NSString*)storageType;



/// @description this creates a table with the name provided
/// @param tableName the name of the table to create
/// @returns returns YES if table is created successfully
- (BOOL)CreateNewTableWithName:(NSString*)tableName;

/// @description this removes the table
/// @param isPermanentRemove this if YES removes the table permanently and deinit model and context in this case just nil the datatable reference after the call to this method
/// @returns returns YES if table has been removed successfully
- (BOOL)RemoveTable:(BOOL)isPermanentRemove;

/// @description checks if a table exists
/// @param the name of the table to check
/// @returns returns YES if the table exists
- (BOOL)DoesTableExists:(NSString*)tableName;

/// @description gets the table name which has been created
/// @returns the table name as string
@property (readonly) NSString* GetTableName;

/// @description this gives the number of rows in a table
/// @returns returns the rows count
@property (readonly) int NumberOfRowsInTable;

/// @description this gives the number of columns in a table
/// @returns returns the columns count
@property (readonly) int NumberOfColsInTable;



/// @description adds a new column to a table
///
/// IMPORTANT: this will recreate the table schema hence all data rows will be deleted!
///
/// @param columnName the name of the column
/// @param columnType the column's storage type, (i prefer NSStringAttributeType for this)
/// @param allowNilValue allow nil values for this column, (i prefer NO for this)
/// @param defaultValue the default value for this column, (i prefer @"" for this)
/// @returns returns YES if the column is added successfully
- (BOOL)AddColumnToTable:(NSString*)columnName ColumnType:(NSAttributeType)columnType AllowNilValues:(BOOL)allowNilValue ColumnDefaultValue:(id)defaultValue;

/// @description removes a column from the table
///
/// IMPORTANT: this will recreate the table schema hence all data rows will be deleted!
///
/// @param columnName the name of the column to remove
/// @returns returns YES if the column has been removed successfully
- (BOOL)RemoveColumnFromTable:(NSString*)columnName;

/// @description checks if a coulm exists in a table
/// @param columnName the name of the column to check for
/// @returns returns YES if the column exists
- (BOOL)DoesColumnExists:(NSString*)columnName;

/// @description get all columns name
- (NSArray*)GetColumnsName;


/// @description adds a new row to the table
/// @param row this is an array that contains columns values to insert
/// @returns returns YES if row is added successfully
- (BOOL)AddRowToTable:(NSArray*)row;

/// @description removes all rows from the table
/// @returns returns YES if all rows are removed successfully
- (BOOL)RemoveAllRowFromTable;

/// @description removes a row from the table at index
/// @param rowIndex the row's index
/// @returns returns YES if the row is removed successfully
- (BOOL)RemoveRowAtIndexFromTable:(int)rowIndex;

/// @description fetch all the rows from a table
/// @returns an array of rows as (NSManagedObject)
- (NSArray*)FetchAllRowsFromTable;

/// @description fetch a row from index number from a table
/// @param rowIndex the row's index
/// @returns returns the row
- (NSManagedObject*)FetchRowAtIndexFromTable:(int)rowIndex;

/// @description fetch the column value for a row at index in a table
/// @param rowIndex the row's index
/// @param columnName the column's name
- (NSString*)FetchColumnValueOfRowAtIndexFromTable:(int)rowIndex ColumnName:(NSString*)columnName;

/// @description execute a query and returns row
/// @param query the query to be executed against the table
/// @returns an array of NSManagedObject rows or nil if query failed
- (NSArray*)FetchRowsAgainstQuery:(NSFetchRequest*)query;

/// @description update the value for a row at a column in a table
/// @param rowIndex the row's index
/// @param columnName the column name
/// @param value the new value to update
/// @returns returns YES if the update was successfull
- (BOOL)UpdateColumnValueForRowAtIndexInTable:(int)rowIndex ColumnName:(NSString*)columnName NewValue:(NSString*)value;


@end

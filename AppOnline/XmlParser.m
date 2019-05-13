//
//  DataTable.m
//  AppOnline
//
//  Created by user on 1/2/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "XmlParser.h"
#import "XMLReader.h"


@implementation XmlParser
{
    NSData *_xmlData;
    NSString *_xmlString;
    
    NSXMLParser *xmlParser;

    enum PktXmlNodesNames parsingCase;
    NSNumber *key;
    NSMutableString *value;
    NSString *currentXmlElement;
    
    NSMutableDictionary *_dataPktKV;
    NSMutableDictionary *_dataPktPD;
    NSMutableDictionary *_dataPktNewDataSet;
    NSMutableDictionary *_dataPktNewDataSetValues;
    NSNumber *_dataPktNewDataSetIndexer;
    NSString *dataSetRootXmlElement;
    NSString *dataSetTableXmlElement;
    
    NSDictionary *_pktXmlNode;
}

- (NSDictionary *)pktXmlNode
{
    if (_pktXmlNode == nil && [_pktXmlNode count] == 0)
    {
        _pktXmlNode = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"DocumentElement", [[NSNumber alloc] initWithInt:nodeDocumentElement],
                       @"P", [[NSNumber alloc] initWithInt:nodeP],
                       @"D", [[NSNumber alloc] initWithInt:nodeD],
                       @"Kv", [[NSNumber alloc] initWithInt:nodeKV],
                       @"k", [[NSNumber alloc] initWithInt:nodeK],
                       @"v", [[NSNumber alloc] initWithInt:nodeV],
                       @"NewDataSet", [[NSNumber alloc] initWithInt:nodeNewDataSet],
                       @"User", [[NSNumber alloc] initWithInt:nodeUser],
                       @"Room", [[NSNumber alloc] initWithInt:nodeRoom],
                       @"AppData", [[NSNumber alloc] initWithInt:nodeAppData],
                       // add more node names and enum keys here, copy the line above and make changes
                       nil];
    }
 //   NSLog(@"_pktXmlNode\n%@",_pktXmlNode);
    return _pktXmlNode;
}


- (id)initWithXmlString:(NSString *)xmlStringData
{
    self = [super init];
    if (self)
    {
        _xmlString = xmlStringData;
        _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (id)initWithXmlData:(NSData *)xmlDataBytes
{
    self = [super init];
    if (self)
    {
        _xmlData   = xmlDataBytes;
        _xmlString = [[NSString alloc] initWithData:_xmlData encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (BOOL)isValidXml:(enum PktXmlNodesNames)rootElement
{
    return [self isValidXmlWithNodeName:[[self pktXmlNode] objectForKey:[[NSNumber alloc] initWithInt:rootElement]]];
}

- (BOOL)isValidXmlWithNodeName:(NSString *)rootElement
{
    NSString *rootElementBeginTag = [NSString Empty];
    NSString *rootElementEndTag = [NSString Empty];
    
    if (rootElement != nil)
    {
        rootElementBeginTag = [[NSString alloc] initWithFormat:@"<%@>",rootElement];
        rootElementEndTag = [[NSString alloc] initWithFormat:@"</%@>",rootElement];
    }
    else
    {
        rootElementBeginTag = @"<DocumentElement>";
        rootElementEndTag = @"</DocumentElement>";
    }
    
    if ([_xmlString rangeOfString:rootElementBeginTag].location != NSNotFound &&
        [_xmlString rangeOfString:rootElementEndTag].location != NSNotFound)
        return YES;

    return NO;
}

- (BOOL)load:(NSData*)optionalXmlDataBytesToLoad
{
    [self initParser:optionalXmlDataBytesToLoad];
    [self clearParsingHelpers];
    return [xmlParser parse];
}

- (void)removeXmlNodeElement:(NSString *)elementName
{
    NSString *elementNameBeginTag = [[NSString alloc] initWithFormat:@"<%@>",elementName];
    NSString *elementNameEndTag = [[NSString alloc] initWithFormat:@"</%@>",elementName];

    if ([_xmlString rangeOfString:elementNameBeginTag].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:elementNameBeginTag withString:[NSString Empty]];
    if ([_xmlString rangeOfString:elementNameEndTag].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:elementNameEndTag withString:[NSString Empty]];
    
    _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)replaceXmlNodeElement:(NSString *)elementName WithNewNodeElement:(NSString *)newElementName
{
    NSString * elementNameBeginTag = [[NSString alloc] initWithFormat:@"<%@>",elementName];
    NSString *elementNameEndTag = [[NSString alloc] initWithFormat:@"</%@>",elementName];
    
    if ([_xmlString rangeOfString:elementNameBeginTag].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:elementNameBeginTag
                                                          withString:[NSString stringWithFormat:@"<%@>", newElementName]];
    if ([_xmlString rangeOfString:elementNameEndTag].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:elementNameEndTag
                                                          withString:[NSString stringWithFormat:@"</%@>", newElementName]];
    
    _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)addXmlNodeElementAsRootNode:(NSString *)elementName
{
    _xmlString = [NSString stringWithFormat:@"<%@> %@ </%@>", elementName, _xmlString, elementName];
    _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)addXmlNodeElement:(NSString *)elementName BeforeNodeElement:(NSString *)beforeNodeElement
{
    if ([_xmlString rangeOfString:[NSString stringWithFormat:@"<%@>", beforeNodeElement]].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", beforeNodeElement]
                                                          withString:[NSString stringWithFormat:@"<%@> <%@>", elementName, beforeNodeElement]];
    if ([_xmlString rangeOfString:[NSString stringWithFormat:@"</%@>", beforeNodeElement]].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", beforeNodeElement]
                                                          withString:[NSString stringWithFormat:@"</%@> </%@>", beforeNodeElement, elementName]];
    _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)addXmlNodeElement:(NSString *)elementName AfterNodeElement:(NSString *)afterNodeElement
{
    if ([_xmlString rangeOfString:[NSString stringWithFormat:@"<%@>", afterNodeElement]].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", afterNodeElement]
                                                          withString:[NSString stringWithFormat:@"<%@> <%@>", afterNodeElement, elementName]];
    if ([_xmlString rangeOfString:[NSString stringWithFormat:@"</%@>", afterNodeElement]].location != NSNotFound)
        _xmlString =[_xmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", afterNodeElement]
                                                          withString:[NSString stringWithFormat:@"</%@> </%@>", elementName, afterNodeElement]];
    _xmlData   = [_xmlString dataUsingEncoding:NSUTF8StringEncoding];

}

- (void)initParser:(NSData*)optionalXmlDataBytes
{
    if (optionalXmlDataBytes != nil)
    {
        _xmlData   = optionalXmlDataBytes;
        _xmlString = [[NSString alloc] initWithData:_xmlData encoding:NSUTF8StringEncoding];
    }
    
    xmlParser  = [[NSXMLParser alloc] initWithData:_xmlData];
    xmlParser.delegate = self;
    
    if (_dataPktKV != nil)
        _dataPktKV = nil;
    if (_dataPktPD != nil)
        _dataPktPD = nil;
    if (_dataPktNewDataSet != nil)
    {
        _dataPktNewDataSet = nil;
        _dataPktNewDataSetValues = nil;
        _dataPktNewDataSetIndexer = nil;
    }
}

- (void)clearParsingHelpers
{
    switch (parsingCase)
    {
        case nodeAppData:
        case nodeNewDataSet:
            
            if (_dataPktNewDataSet != nil && _dataPktNewDataSet.count > 0)
            {
                self.dataPktNewDataSetTable = [[NSMutableDictionary alloc] init];
                for (NSString *tableName in _dataPktNewDataSet)
                {
                    DataTable *newTable = [[DataTable alloc] init];
                    [newTable CreateNewTableWithName:tableName];
                    
                    NSArray *columns = [_dataPktNewDataSet valueForKey:tableName];
                    for (NSString *column in columns)
                        [newTable AddColumnToTable:column ColumnType:NSStringAttributeType AllowNilValues:NO ColumnDefaultValue:@""];
                    
                    if (_dataPktNewDataSetValues != nil && _dataPktNewDataSetValues.count > 0)
                    {
                        NSArray *rows = [_dataPktNewDataSetValues valueForKey:tableName];
                        for (NSDictionary *row in rows)
                        {
                            NSMutableArray *rowItems = [[NSMutableArray alloc] init];
                            for (NSString *column in columns)
                            {
                                if ([row objectForKey:column] != nil)
                                    [rowItems addObject:[row objectForKey:column]];
                                else
                                    [rowItems addObject:@""];
                            }
                            [newTable AddRowToTable:rowItems];
                        }
                    }
                    [self.dataPktNewDataSetTable setValue:newTable forKey:tableName];
                }
            }
            
            break;
            
        default:
            break;
    }
    

    
    if (![currentXmlElement isEqualToString:@"k"] && ![currentXmlElement isEqualToString:@"v"])
    {
        key = 0;
        value = [NSMutableString stringWithString:@""];
        parsingCase = nodeEmpty;
    }
    
    currentXmlElement = @"";
    dataSetRootXmlElement = @"";
    dataSetTableXmlElement = @"";
}

- (void)parseNewDataSet:(NSString*)text
{
    if (_dataPktNewDataSet == nil)
    {
        dataSetRootXmlElement = currentXmlElement;
        _dataPktNewDataSet = [[NSMutableDictionary alloc] init];
        _dataPktNewDataSetValues = [[NSMutableDictionary alloc] init];
        
        
        return;
    }

    if (!currentXmlElement.isEmptyOrWhiteSpaces)
    {
        if (dataSetTableXmlElement.isEmptyOrWhiteSpaces)
        {
            dataSetTableXmlElement = currentXmlElement;
            
            if (![_dataPktNewDataSet.allKeys containsObject:dataSetTableXmlElement])
            {
                NSMutableArray *columns = [[NSMutableArray alloc] init];
                [_dataPktNewDataSet setObject:columns forKey:dataSetTableXmlElement];
                
                NSMutableArray *rows = [[NSMutableArray alloc] init];
                [_dataPktNewDataSetValues setObject:rows forKey:dataSetTableXmlElement];
                
                _dataPktNewDataSetIndexer = [[NSNumber alloc] initWithInt:0];
            }
            else
            {
                _dataPktNewDataSetIndexer = @(_dataPktNewDataSetIndexer.intValue + 1);
            }
            
            
            return;
        }
        
        if (![currentXmlElement isEqualToString:dataSetTableXmlElement]) //(![currentXmlElement isEqualToString:_dataPktNewDataSet.allKeys[0]])
        {
            NSMutableArray *columns = [_dataPktNewDataSet valueForKey:dataSetTableXmlElement];
            if (![columns containsObject:currentXmlElement])
                [columns addObject:currentXmlElement];
            
            NSMutableArray *rows = [_dataPktNewDataSetValues objectForKey:dataSetTableXmlElement];
            if (rows.count > _dataPktNewDataSetIndexer.intValue)
            {
                NSMutableDictionary *row = [rows objectAtIndex:_dataPktNewDataSetIndexer.intValue];
                [row setObject:text forKey:currentXmlElement];
            }
            else
            {
                NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
                [rows addObject:row];
                [row setObject:text forKey:currentXmlElement];
            }
        }
    }
}

- (void)parseKV:(NSString*)text
{
    if (_dataPktKV == nil)
        _dataPktKV = [[NSMutableDictionary alloc] init];
    
    if ([currentXmlElement isEqualToString:@"k"])
        key = [[NSNumber alloc] initWithInt:[text intValue]];
    if ([currentXmlElement isEqualToString:@"v"])
    {
        if (value.isEmptyOrWhiteSpaces)
            value = [[NSMutableString alloc] initWithString:text];
        else [value appendString:text];
        
        [_dataPktKV setObject:value forKey:key];
    }
}

- (void)parsePD:(NSString*)text
{
    if (_dataPktPD == nil)
        _dataPktPD = [[NSMutableDictionary alloc] init];
    
    if ([currentXmlElement isEqualToString:@"D"])
    {
        key = [[NSNumber alloc] initWithInt:1];
        value = [[NSMutableString alloc] initWithString:text];
        [_dataPktPD setObject:value forKey:key];
    }
}

- (void)parseSwitcher:(NSString*)elementName startParser:(BOOL)start
{
    currentXmlElement = elementName;
    if (start)
    {
        if (parsingCase == nodeEmpty)
        {
            if ([currentXmlElement isEqualToString:@"Kv"])
                parsingCase = nodeKV;
            else if ([currentXmlElement isEqualToString:@"P"])
                parsingCase = nodeP;
            else if ([currentXmlElement isEqualToString:@"D"])
                parsingCase = nodeD;
            else if ([currentXmlElement isEqualToString:@"k"])
                parsingCase = nodeK;
            else if ([currentXmlElement isEqualToString:@"v"])
                parsingCase = nodeV;
            else if ([currentXmlElement isEqualToString:@"NewDataSet"])
                parsingCase = nodeNewDataSet;
            else if ([currentXmlElement isEqualToString:@"AppData"])
                parsingCase = nodeAppData;
        }
    }
    else
    {
        if ([currentXmlElement isEqualToString:@"Kv"] ||
            ([currentXmlElement isEqualToString:@"P"] && parsingCase != nodeNewDataSet) ||
            [currentXmlElement isEqualToString:@"D"] ||
            [currentXmlElement isEqualToString:@"k"] ||
            [currentXmlElement isEqualToString:@"v"] ||
            [currentXmlElement isEqualToString:@"NewDataSet"] ||
            [currentXmlElement isEqualToString:@"AppData"])
                [self clearParsingHelpers];
        else
        {
            if ([dataSetTableXmlElement isEqualToString:currentXmlElement])
                dataSetTableXmlElement = @"";
            currentXmlElement = @"";
        }
    }
}




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //[CommonTasks LogMessage:[NSString stringWithFormat:@"starting tag = [%@]\n", elementName] MessageFlagType:logMessageFlagTypeInfo];
    [self parseSwitcher:elementName startParser:YES];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //[CommonTasks LogMessage:[NSString stringWithFormat:@"ending tag = [%@]\n", elementName] MessageFlagType:logMessageFlagTypeInfo];
    [self parseSwitcher:elementName startParser:NO];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //[CommonTasks LogMessage:[NSString stringWithFormat:@"inner text = [%@]\n",string] MessageFlagType:logMessageFlagTypeInfo];
    
    if (!string.isEmptyOrWhiteSpaces)
        switch (parsingCase)
        {
            case nodeAppData:
            case nodeNewDataSet:
                [self parseNewDataSet:string];
                break;
                
            case nodeK:
            case nodeV:
                [self parseKV:string];
                break;
                
            case nodeD:
                [self parsePD:string];
                break;
                
            case nodeDocumentElement:
            case nodeEmpty:
            default:
                [self clearParsingHelpers];
                break;
        }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [CommonTasks LogMessage:[NSString stringWithFormat:@"s=%@\n", parseError.description] MessageFlagType:logMessageFlagTypeError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    [CommonTasks LogMessage:[NSString stringWithFormat:@"s=%@\n",validationError.description] MessageFlagType:logMessageFlagTypeError];
}

//- ( *)dictionary1
//{
//    if(!dictionary1){
//        dictionary1 = [[NSMutableDictionary alloc] init];
//
//        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
//        parser.delegate = self;
//        [parser parse];
//
//    }
//    return dictionary1;
//}

-(NSDictionary*)xmlToDict {
    NSDictionary *dict = [XMLReader dictionaryForXMLString:self.xmlString error:nil];
    return dict;
}


@end

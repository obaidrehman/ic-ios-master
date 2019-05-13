//
//  DataTable.h
//  AppOnline
//
//  Created by user on 1/2/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonTasks.h"
#import "DataTable.h"

/// @description all the possible nodes names that may exists, add new nodes names here

enum PktXmlNodesNames
{
    /// @description this is just an imaginary node it never existed in real xD
    nodeEmpty,
    /// @description the very first root node in every xml we recieved through the socket packets
    nodeDocumentElement, // <DocumentElement></DocumentElement>
    /// @description the P node from P-D xml, before sending packet it is once again xml'd... what a shit architecture xP
    nodeP, // <P></P>
    /// @description the D node from P-D xml, before sending packet it is once again xml'd... what a shit architecture xP
    nodeD, // <D></D>
    /// @description the key-value pair xml node, this is the default packet format (refer .net IC code)
    nodeKV, // <Kv></Kv>
    /// @description the key-value pair k (key) xml node, this is the default packet format (refer .net IC code)
    nodeK, // <k></k>
    /// @description the key-value pair v (value) xml node, this is the default packet format (refer .net IC code)
    nodeV, // <v></v>
    /// @description the <NewDataSet></NewDataSet> this node may contain more xml data (i.e. dataset or datatable) as send by the server
    nodeNewDataSet, // <NewDataSet></NewDataSet> or <NewDataSet/>
    /// @description this is the user table node found in login response packet, it contains all info related to the current user
    nodeUser, // <User></User>
    /// @description this is the room table node found in get all rooms packet, it contains all rooms names and IDs
    nodeRoom, // <Room></Room>
    /// @description this refer to the app data dataset
    nodeAppData, // <AppData></AppData>
};

enum PktXmlKeyConstantsPD
{
    keyP = 0,
    keyD = 1,
};

enum PktXmlKeyConstantsKV
{
    keyEmpty,
};



@interface XmlParser : NSObject <NSXMLParserDelegate>

/// @description this is the xml data we recieved from the socket stream
@property (strong) NSData *xmlData;
/// @description this is the xml data as string
@property (strong) NSString *xmlString;

/// @description this represents all the xml nodes valid names that may be in any xml recieved
@property (readonly, weak) NSDictionary *pktXmlNode;


/// @description when xml data has been parsed this will represent the packet KV data
@property (readonly, strong) NSMutableDictionary *dataPktKV;
/// @description when xml data has been parsed this will represent the packet PD data
@property (readonly, strong) NSMutableDictionary *dataPktPD;
/// @description when xml data has been parsed this will represent the packet NewDataSet data
@property (readonly, strong) NSMutableDictionary *dataPktNewDataSet;
@property (strong) NSMutableDictionary *dataPktNewDataSetTable;


/// @description init an instance of datatable with xml string
/// @param xmlStringData the xml string data
/// @returns an instance of the datatable object
- (id)initWithXmlString:(NSString*)xmlStringData;

/// @description init an instance of datatable with xml string
/// @param xmlStringData the xml string data
/// @returns an instance of the datatable object
- (id)initWithXmlData:(NSData*)xmlDataBytes;

/// @description checks if the xml used for init a datatable object is valid, this basically checks if the root elements exists
/// @param rootElement can be any node element from the PktXmlNodesNames, however if nodeEmpty is provided then it searches for 'DocumentElement' node
/// @returns a BOOL value indicating that the xml is valid or not
- (BOOL)isValidXml:(enum PktXmlNodesNames)rootElement;

/// @description checks if the xml used for init a datatable object is valid, this basically checks if the root elements exists
/// @param rootElement can be any node element, however if nil is provided then it searches for 'DocumentElement' node
/// @returns a BOOL value indicating that the xml is valid or not
- (BOOL)isValidXmlWithNodeName:(NSString*)rootElement;

/// @description load and parse the xml data that was used when calling the constructor
/// @param optionalXmlDataBytesToLoad in case you want to change the init xml with some new xml, else use nil
/// @returns a BOOL value if all the xml was parsed successfully, in this case the properties starting with name 'dataPkt' can be accessed for the relevant data
- (BOOL)load:(NSData*)optionalXmlDataBytesToLoad;

/// @description removes a xml node from the xml used to init
/// @param elementName is the node name to be removed
- (void)removeXmlNodeElement:(NSString*)elementName;

/// @description replaces a xml node from the xml used to init
/// @param elementName is the node name to be replaced
/// @param newElementName the new node to replace with
- (void)replaceXmlNodeElement:(NSString*)elementName WithNewNodeElement:(NSString*)newElementName;

/// @description adds a xml node as root node to the xml used to init
/// @param elementName is the node name to be added
- (void)addXmlNodeElementAsRootNode:(NSString*)elementName;

/// @description adds a xml node to the xml used to init after the node specified
/// @param elementName is the node name to be added
/// @param afterNodeElement the node name after which the node is to be added
- (void)addXmlNodeElement:(NSString*)elementName AfterNodeElement:(NSString*)afterNodeElement;

/// @description adds a xml node to the xml used to init before the node specified
/// @param elementName is the node name to be added
/// @param beforeNodeElement the node name before which the node is to be added
- (void)addXmlNodeElement:(NSString*)elementName BeforeNodeElement:(NSString*)beforeNodeElement;

- (NSMutableDictionary*)xmlToDict;

@end

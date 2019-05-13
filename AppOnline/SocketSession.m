//
//  SocketSession.m
//  AppOnline
//
//  Created by user on 12/29/14.
//  Copyright (c) 2014 nabeeg. All rights reserved.
//

#import "SocketSession.h"
#import "AppZipper.h"
#import "XmlParser.h"
#import "CommonTasks.h"
#import "Packet.h"

@implementation SocketSession
{
    /// do not change these variable during runtime!
    NSDictionary *_Hosts;
    
    
    /// these streams are casted into NSStream objects, use those if needed (referenced as properties)
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    /// this variable refer to the host ip/port index in the collection
    int hostIdentifierIndex;
    /// this will point to the class implementing the NSStreamDelegates protocol
    id delegateClassReference;
    
    /// what a lousy thing is this... who come up with this architecture... surely a noob xP
    BOOL handShakeDone;
    NSData *handShakeCode;
    NSData *eod;
    
    
    /// these are fro the input stream
//    NSMutableData *reader;//                  
//    uint8_t buffer[1024];
//    NSInteger bytesRead = 0;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)Hosts
{
    if (_Hosts == nil && [_Hosts count] == 0)
    {
        _Hosts = [NSDictionary dictionaryWithObjectsAndKeys:
                 
                  [NSNumber numberWithInt:7002], @"151.253.185.105",
              // [NSNumber numberWithInt:7002], @"98.129.67.175",   // qa server
              //  [NSNumber numberWithInt:5003], @"192.168.1.142",//@"192.168.1.142",//@"98.129.67.169", // main server 98.129.67.175
                  //[NSNumber numb, @"192.168.1.135",
                  // add more ports and IPs here, copy the line above and make changes
                  nil];
        hostIdentifierIndex = 0;
    }
    return _Hosts;
}


- (BOOL)isConnected
{
    // i so like this style, short and precise! works like a charm xD
    if (self.inputStream != nil && self.outputStream != nil)
        if ([self.inputStream streamStatus] == NSStreamStatusOpen)
            if ([self.outputStream streamStatus] == NSStreamStatusOpen)
//                if (handShakeDone)
                    return YES;
    return NO;
}

- (BOOL)CanSendDataOverSocket:(int)numberOfTimesToCheck
{
    do
    {
        if (!self.outputStream.hasSpaceAvailable)
            [CommonTasks LogMessage:[NSString stringWithFormat:@"outputStream doesn't has space available %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeError];
        else break;
        
    } while (--numberOfTimesToCheck > 0);
 
    [CommonTasks LogMessage:[NSString stringWithFormat:@"outputStream has sapce available %@", [CommonTasks Good]] MessageFlagType:logMessageFlagTypeSystem];
    return YES;
}

- (NSString *)getLocalEndPoint
{
    return [CommonTasks GetIPAddress:YES];
}

- (NSString *)getRemoteEndPoint
{
    return self.Hosts.allKeys[hostIdentifierIndex];
}



- (id)init
{
    self = [super init];
    if (self)
    {
        [self ResetParameters];
        
        Byte handShakeBytes[] = { 198, 202, 247, 173, 155, 219, 169, 138 };
        handShakeCode = [NSData dataWithBytes:handShakeBytes length:sizeof(handShakeBytes)];
        Byte eodByte = 0;
        eod = [NSData dataWithBytes:&eodByte length:1];
    }
    return self;
}

- (void)ResetParameters
{
    hostIdentifierIndex = 0;
    handShakeDone = NO;
}

- (BOOL)Setup
{
    return [self Setup:nil];
}

- (BOOL)Setup:(id)DelegateClassReference
{
    self.pauseInputStream = NO;
    self.pauseOutputStream = NO;
    
    delegateClassReference = DelegateClassReference;
    BOOL connected = NO;

    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef)self.Hosts.allKeys[hostIdentifierIndex],
                                       [self.Hosts.allValues[hostIdentifierIndex] intValue],
                                       &readStream, &writeStream);

    connected = CFWriteStreamOpen(writeStream) & CFReadStreamOpen(readStream);
    
    if (connected)
    {
        self.inputStream = (__bridge_transfer NSInputStream *)readStream;
        self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
        
        if (DelegateClassReference == nil)
        {
            [self.inputStream setDelegate:self];
            [self.outputStream setDelegate:self];
        }
        else
        {
            [self.inputStream setDelegate:delegateClassReference];
            [self.outputStream setDelegate:delegateClassReference];
        }
        
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.inputStream open];
        [self.outputStream open];
    }
    else if (++hostIdentifierIndex < self.Hosts.count)
    {
        connected = [self Setup:delegateClassReference];
    }
    return connected;
}

- (void)TearDown:(BOOL)hasta_la_vista_baby
{
    if (hasta_la_vista_baby)
        hostIdentifierIndex = (int)[self.Hosts count];
    
    handShakeDone = NO;
    self.pauseInputStream = NO;
    self.pauseOutputStream = NO;
    
    if (self.inputStream != nil && self.outputStream != nil)
    {
        [self.inputStream close];
        [self.outputStream close];
        
        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.inputStream setDelegate:nil];
        [self.outputStream setDelegate:nil];
        
        self.inputStream = nil;
        self.outputStream = nil;
    }
    
    if (++hostIdentifierIndex < [self.Hosts count])
    {
        [self Setup:delegateClassReference];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventEndEncountered:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"end %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeSystem];
            break;

        case NSStreamEventErrorOccurred:
            [self TearDown:NO];
            [CommonTasks LogMessage:[NSString stringWithFormat:@"error %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeError];
            break;
        
        /*
         * use this event to handle incomining data from Server
         * use inputstream to read data
         */
        case NSStreamEventHasBytesAvailable:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"has bytes %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeSystem];
            [self ReadData];
            break;
            
        /*
         * use this event to handle outgoing data to Server
         * use outputstream to send data
         */
        case NSStreamEventHasSpaceAvailable:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"has space %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case NSStreamEventNone:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"none %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case NSStreamEventOpenCompleted:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"open %@", aStream == self.inputStream ? @"inputstream": @"outputstream"] MessageFlagType:logMessageFlagTypeSystem];
            break;
    }
}

- (void)SendData:(NSData *)theData needToCompress:(BOOL)compressPlz
{
    if (self.pauseOutputStream)
    {
        [CommonTasks LogMessage:@"cannot send data, outputStream is paused!" MessageFlagType:logMessageFlagTypeSystem];
        return;
    }
    
    if ([self.outputStream hasSpaceAvailable])
    {
        if (theData != nil && [theData length] > 0)
        {
            NSData *data = [NSData dataWithData:theData];
            if (compressPlz)
            {
                data = [AppZipper ZipCompress:data tempFileName:nil];
                NSMutableString *pktData = [[NSMutableString alloc] init];
                [pktData appendString:@"<DocumentElement><P><D>"];
                [pktData appendString:[data base64EncodedStringWithOptions:0]];
                [pktData appendString:@"</D></P></DocumentElement>"];
                data = [pktData dataUsingEncoding:NSUTF8StringEncoding];
                [CommonTasks LogMessage:[NSString stringWithFormat:@"sending packet = [%@]", pktData] MessageFlagType:logMessageFlagTypeSystem];
            }
            
            NSMutableData *sendingData = [NSMutableData dataWithData:data];
            [sendingData appendData:eod];
            [self.outputStream write:[sendingData bytes] maxLength:[sendingData length]];
            [CommonTasks LogMessage:[NSString stringWithFormat:@"sending bytes over socket, bytes buffer length is = [%i]", (int)sendingData.length] MessageFlagType:logMessageFlagTypeSystem];
        }
    }
    else
        [CommonTasks LogMessage:@"OutputStream doesn't have space availbale" MessageFlagType:logMessageFlagTypeError];
}

- (void)SendString:(NSString *)theString needToCompress:(BOOL)compressPlz
{
    if (theString != nil && !theString.isEmptyOrWhiteSpaces)
    {
        NSData *data = [theString dataUsingEncoding:NSUTF8StringEncoding];
        [self SendData:data needToCompress:compressPlz];
    }
}

- (void)SendHandShakeRequest
{
    if (!handShakeDone)
    {
        [self SendData:handShakeCode needToCompress:NO];
        handShakeDone = YES;
    }
}

- (void)CompleteHandShake:(NSData*)data;
{
    if (!handShakeDone)
    {
        if ([data isEqualToData:handShakeCode])
            handShakeDone = YES;
        else
            [self TearDown:YES];
    }
}


- (NSData*)ReadData
{
    if ([self.inputStream hasBytesAvailable])
    {
        NSMutableData *data = [[NSMutableData alloc] initWithLength:0];
        uint8_t buffer[1024];
        NSInteger bytesRead = 0;
        NSRange pktCheck;
        
        while ((bytesRead = [self.inputStream read:buffer maxLength:1024]) > 0)
        {
            [data appendBytes:(const void*)buffer length:bytesRead];
            
            pktCheck = [data rangeOfData:eod options:0 range:NSMakeRange(0, [data length])];
            
            if (pktCheck.length == 1)
            {
                NSData *processingData = [data subdataWithRange:NSMakeRange(0, pktCheck.location)];
                [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                    [self ProcessData:processingData];
                }];
                
                return processingData;
            }
            else if (pktCheck.length >= 5)
            {
                BOOL breakConnection = YES;
                for (int i = 0; i < pktCheck.length; i++)
                {
                    if (((Byte*)[data bytes])[pktCheck.location + i] != 0)
                    {
                        breakConnection = NO;
                        break;
                    }
                }
                
                if (breakConnection)
                {
                    [self TearDown:YES];
                }
                
                return nil;
            }
        }
    }
    return nil;
}

/// @descrition this method process a valid data, checks the innner structure and redirects the data where needed
/// @param data this is the data that need to be processed
- (void)ProcessData:(NSData*)data
{
    if (!handShakeDone)
        [self CompleteHandShake:data];
    else
    {
        // unzip data
        // fire event for processing data
        
        
        // 1st comes PD xml
        XmlParser *parser = [[XmlParser alloc] initWithXmlData:data];
        if ([parser isValidXml:nodeDocumentElement]
             && [parser isValidXml:nodeP]
             && [parser isValidXml:nodeD])
        {
            if ([parser load:nil])
            {
                
                if (parser.dataPktPD != nil && [parser.dataPktPD count] > 0)
                {
                    NSString *stringData = [parser.dataPktPD objectForKey:[[NSNumber alloc] initWithInt:keyD]];
                    if (!stringData.isEmptyOrWhiteSpaces)
                    {
                        NSData *decodedData = [self DecodePacketData:stringData tempFileName:@"decode"];
                        
                        // just logging... unnecessary step.....
                        stringData = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                        [CommonTasks LogMessage:stringData MessageFlagType:logMessageFlagTypeInfo];
                        
                        // 2nd comes KV xml
                        if (decodedData != nil && [decodedData length] > 0)
                        {
                            parser = [[XmlParser alloc] initWithXmlData:decodedData];
                            if ([parser isValidXml:nodeDocumentElement]
                                && [parser isValidXml:nodeK]
                               && [parser isValidXml:nodeV])
                            {
                                if ([parser load:nil])
                                {
                                   
                                    if (parser.dataPktKV != nil && [parser.dataPktKV count] > 0)
                                    {
                                        // now check dataPktKV dictionary and fire the relative event
                                        // please subscribe to the events and then proceed there with further processing... got it?
                                        NSLog(@"\nPACKET COUNT =====================================%lu",[parser.dataPktKV count]);
                                    
                                        [self SwitchPacketTypeAndFireEvent:[[NSDictionary alloc] initWithDictionary:parser.dataPktKV copyItems:YES]];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


/// @description this gonna decode the packet data recieved in a packet xml, use this providing data to datatable class!
/// @param stringData the string data from xml node
/// @param fileName temp file used to help in decoding the data
/// @returns decode data
- (NSData*)DecodePacketData:(NSString*)stringData tempFileName:(NSString*)fileName
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:stringData options:0];
    NSString *decodedDatafileName = fileName;
    [CommonTasks FileCreateWithData:decodedData fileName:decodedDatafileName];
    decodedData = [AppZipper ZipDecompress:decodedDatafileName];
    return decodedData;
}


/// @description this checks what type of packet has been recieved and the fire the related event, please subscribe to the events and then proceed there with further processing... got it?
/// @param dataPktKV this is the packet dictionary with all the keys and values
- (void)SwitchPacketTypeAndFireEvent:(NSDictionary*)dataPktKV
{
    int packetID = [[NSString stringWithString:[dataPktKV objectForKey:[[NSNumber alloc] initWithInt:icPacketSysParamPacketID]]] intValue];
    NSLog(@"JDHAKSHDKJASHDKJASHDKJHADJKHASKJDHKJSAD ==== %i",packetID);
    switch (packetID)
    {
        // todo
        // all packets type come here
        // add a delegate protocol that can be subscribed to outside the AppOnline by any other module
        // visibility of this should be at AppOnline.h level!.. maybe...
        
            case 450:
            NSLog(@"%@",dataPktKV);
            break;
            
        case icPacketCreateGameChalengeResponseNotMatch:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketCreateGameChalengeResponseNoMatch" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Packet Create GameChalenge response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketCreateGameChalengeResponseMatch:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketCreateGameChalengeResponseMatch" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Packet Create GameChalenge response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketSendCurrentMoveToServerResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketSendCurrentMoveToServerResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Current Move Response " MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case  icPacketCurrentMoveRecieved:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketCurrentMoveRecieved" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Current Move Recieved to Other Player" MessageFlagType:logMessageFlagTypeSystem];
            break;
           
        case icPacketPacketIDLoginUser :
            NSLog(@"LOGIN CAUGHT-----------");
            break;
            
        case icPacketPacketIDLoginUserResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketLoginUserResponse" object:self userInfo:dataPktKV];
            NSLog(@"LOGIN RESPONSE CAUGHT-----------");
            [CommonTasks LogMessage:@"login packet response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
        case icPacketPacketIDSignUpUserResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketSignUpUserResponse" object:self userInfo:dataPktKV];
            NSLog(@"SignUp RESPONSE CAUGHT-----------");
            [CommonTasks LogMessage:@"login packet response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDUpdateUserStatusResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketUpdateUserStatusResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"update user status response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketCheckAppVersion:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketCheckAppVersionResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"update user status response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketMessageToOtherPlayerResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketMessageResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Message Recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
        case icPacketGameAbbortResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGameAbbortResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Abbort Message Recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
        case icPacketAppResignGameResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketResignAppResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"Resign App response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
         
        case icPacketPacketIDValidateVersionResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketValidateVersionResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"version validation failed response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetUserInfoByUserIDResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetUserInfoByUserIDResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get user info response packet recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetAllKeyValuesResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetAllKeyValuesResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get all key values response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetAllRoomsResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetAllRoomsResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get all rooms response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDChangeRoomResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketChangeRoomResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"change room respones recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetDataByRoomIDResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetDataByRoomIdResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get data by room ID response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetGameDataByGameIDResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetGameDataByGameIdResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get data by game ID response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDUpdateUserRowResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketUpdateUserRowResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"some user enter room packet recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDRemoveUserRowResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketRemoveUserRowResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"some user left room packet recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDGetGamesByRoomIDResponse:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketGetGamesByRoomIDRespones" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"get games by room id response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDUpdateGame:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketUpdateGameReceived" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"update game recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDChatMessage:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isPacketChatMessageReceived" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"server send a chat message packet" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDPingClient:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketServerPingClientResponse" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"server send a ping packet" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        case icPacketPacketIDPingServer:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"icPacketClientPingServerRespones" object:self userInfo:dataPktKV];
            [CommonTasks LogMessage:@"client ping server response recieved" MessageFlagType:logMessageFlagTypeSystem];
            break;
            
        default:
            [CommonTasks LogMessage:[NSString stringWithFormat:@"packet recieved, packet ID is [%i]", packetID] MessageFlagType:logMessageFlagTypeSystem];
            break;
    }
}

@end

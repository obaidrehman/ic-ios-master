//
//  SocketSession.h
//  AppOnline
//
//  Created by user on 12/29/14.
//  Copyright (c) 2014 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>




/// @description This class hold the main Socket creation code and input output streams handling
@interface SocketSession : NSObject <NSStreamDelegate>

/// @description Holds all the server IPs and related ports
/// KEY is the server ip and VALUE is the server port number
/// KEY is a NSString and VALUE is a NSNumber
/// @returns This is a readonly property and returns IP/Port pairs
@property (readonly, weak) NSDictionary *Hosts;

/// @description Reference to the socket's InputStream
@property (strong) NSInputStream *inputStream;
/// @description pause the stream so that no data may be read
@property BOOL pauseInputStream;

/// @description Reference to the socket's OutputStream
@property (strong) NSOutputStream *outputStream;
/// @description pause the stream so that no data can be written
@property BOOL pauseOutputStream;

/// @description returns true if both inputStream and outputStream are open
@property (readonly) BOOL isConnected;

/// @description returns the IP address of the user as a string
@property (weak, readonly) NSString *getLocalEndPoint;
/// @description returns the Server IP address as a string
@property (weak, readonly) NSString *getRemoteEndPoint;

+ (instancetype)sharedInstance;

/// @description this resets a socket variable so that setup can be reinitiated
- (void)ResetParameters;


/// @description Setup a socket connection to the first available Infinity Chess .Net server
/// @returns If connected returns true
- (BOOL)Setup;

/// @description Setup a socket connection to the first available Infinity Chess .Net server
/// @param DelegateClassReference a class reference implementing the NSStreamDelegate protocol
/// @returns If connected returns true
- (BOOL)Setup:(id)DelegateClassReference;

/// @description Close the input and output streams and the related socket connection, disposes all of the sockets related objects
/// @param hasta_la_vista_baby it means yes go bye bye and dont return ;P
- (void)TearDown:(BOOL)hasta_la_vista_baby;

/// @description sends byte data over the connected socket stream
/// @param theData is the data to be send
/// @param compressPlz if need to compress, this should be kept true unless someone changes code at .net server, this also appends the PD-xml syntax
- (void)SendData:(NSData*)theData needToCompress:(BOOL)compressPlz;
/// @description sends byte data over the connected socket stream
/// @param theData is the data to be send
/// @param compressPlz if need to compress, this should be kept true unless someone changes code at .net server, this also appends the PD-xml syntax
- (void)SendString:(NSString*)theString needToCompress:(BOOL)compressPlz;

/// @description do i need to tell u... this is the lousy knock' knock' whose there? and u reply "nobody... just me.. hi..." ...WTF
- (void)SendHandShakeRequest;
/// @description checks and validate handshake
- (void)CompleteHandShake:(NSData*)data;

/// @description returns true only when outputStream has space so that data can be send to the server, otherwise this will keep returning a no
///
/// CAUTION: there is a loop in this so use wisely and dont get stuck!
/// @param numberOfTimesToCheck number of times the loop should run, 0 is for infinite loop unless YES is return
/// @returns returns YES only when outputStream has space
- (BOOL)CanSendDataOverSocket:(int)numberOfTimesToCheck;


/// @description this reads the incoming stuff on the socket stream... bring it on! this may also tear down a connection, depends what-u-throw-is-what-u-catch
/// @returns returns data where valid data is recieved, these is data decodeing happening in this method so don't call and decoding techniques after this... be carefull may your brain be with you! xD
- (NSData*)ReadData;

@end

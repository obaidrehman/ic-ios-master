//
//  AppOnline.h
//  AppOnline
//
//  Created by user on 12/29/14.
//  Copyright (c) 2014 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSession.h"
#import "SocketSession.h"
#import "Packet.h"



/// @description use these if passing userinfo with notifications form apponline
enum AppOnlineNotifications
{
    appOnlineNotificationType = 0,         // this just reference to back here see how im using this in code to learn!
    appOnlineNotificationTitle = 1,        // the title for the posted notification if any
    appOnlineNotificationMessage = 2,      // the message to send
    
    appOnlineUserCredentialsFailed,     // if user authentication has failed
    appOnlineBanishedUser,              // those who should not be named
    appOnlineAppNeedsToUpdate,          // app need to update
    appOnlineAppUpdateAvailable,         // app update is available
};




@interface AppOnline : NSObject {
   
}


@property BOOL theFlag;
@property NSMutableArray *arrFenList;
// _______________________________________________________________________________
// main stuff use this below to connect online
-(void)checkMasla;
/// @description this returns a staic instance of apponline, use this for all online communication tasks
+ (volatile AppOnline*)instance;
/// @description this resets a few properties of apponline to their initial state
- (void)ResetParameters;
/// @description this sets the user name and the password that is used to login the server
- (void)SetLoginUserName:(NSString*)username andPassword:(NSString*)password;
/// @description this search for any aviable server from the server pool and try to connect a socket connection to it
- (void)FindAndConnectToServer;
/// @description this is use to disconnect any alive socket connection to the server
- (void)Disconnect;
/// @description this search for any aviable server from the server pool and try to connect a socket connection to it, once connected this method will notify any apponline subscriber that it has connected
- (void)FindAndConnectToServerWithNotification;
/// @description this is use to disconnect any alive socket connection to the server, once disconnected this will notify
- (void)DisconnectWithNotification;
/// @description this checks if the socket is connected to the server and thus sends a ping packet
- (void)Ping;
/// @description this checks the socket connection to the server, if connected it sends a ping packet else it search and reconnect to the first available server in the server pool
- (void)PingOrReconnectToServer;
/// @description this is use to check if the socket connection is alive
@property (readonly, nonatomic) BOOL isConnected;
/// @description this is the poll time for which a socket must poll before sending a packet
@property (nonatomic) int socketPollTime;
/// @description this is all the user online related stuff, its remembered by this one reference type variable declared below, yes believe me ;D
@property (strong) volatile UserSession *User;

/// @description this is the reference to the Socket class object
@property (strong) volatile SocketSession *socketSession;

/// @description this is the reference to the timer thread object
@property (strong) NSThread *timerThread;

/// @description initialize an instance of AppOnline with SocketSession
- (id)initWithSocket:(id)socketStreamDelegateClassReference;

/// @description deinitlize all objects consumed by apponline
/// @param caller this is the class calling this method
- (id)DeinitAppOnline:(id)caller;
- (void)sendCreateGameData:(NSDictionary*)dict;

/// @description this lets apponline to subscribe to the notifactions events
- (void)SubscribeToInternalNotifications;

/// @description this lets a class calling apponline to subscribe to the notifactions events, plz make sure that the required methods are implemented by the subscriber!
- (void)SubscribeToNotifications:(id)subscriber;

/// @description this unscubcribe to the notifications events triggered by apponline
- (void)UnsubscribeToNotifications:(id)unsubscriber;

-(void)addFenListToArray:(NSString*)fen;
/// @description this checks if a connection has been established with the server,
///
/// use this for all Send* type methods!
///
/// usage:
///
/// if ([self CheckServerConnectionState] == NO) return;
/// @returns YES if socket is connected else NO
- (BOOL)CheckServerConnectionState;

/// @description this checks if a connection has been established with the server, and the outputstream is ready to send data, there is a loop inside so this will just loop unless connections are all set
///
/// usage:
///
/// if ([self CheckServerConnectionState]) // now proceed!
/// @returns YES if socket is connected else NO
- (BOOL)CheckServerConnectionStateForDataFlow:(int)numberOfTimesToCheck;

/// @description this is launched when successful login response is recieved by the server
///
/// used for: all updates such as server time filed etc
///
/// this isn't being declare private, but it is recommended not to call this seperately from outside, just implement this is userlogin response selector
- (void)InitAndRunTimerThread;
/// @description this should be called when loggin out the server
///
/// this isn't being declare private, but it is recommended not to call this seperately from outside, just implement this where it is right
- (void)DeinitAndStopTimerThread;



// user send packets types _______________________________________________________

/// @description send a login packet to the server
/// @param userName the user name used for login
/// @param password the user pass used for login
/// @param machineCode keep this nil or empty = @"", self computed value is used from CommonTasks.h
/// @param sysInfo keep this nil or empty = @"", self computed value is used from CommonTasks.h
- (void)SendLoginUser:(NSString*)userName Password:(NSString*)password;
- (void)SendSocialLoginUser:(NSDictionary *)dict;
/// @description send a logoff packet to the server
- (void)SendLogOffUser;
-(void)checkForAppVersion;
/// @description send this when user successfully recieve login packet response
- (void)SendUpdateUserStatus;

/// @description send this to get user info, ususally this is send automatically during the login process and the data is stored in userSession
- (void)SendGetUserInfo;

/// @description get all server's key-values
- (void)SendGetAllKeyValues;

/// @description send this to get all rooms
///
/// Note: send this after all login process has been successfully completed!
- (void)SendGetAllRooms;

/// @description this is a reply packet by client to server, the server sends ping packet to client which is just bounce back by the client to the server
///
/// Note: no need to call this seperately!
- (void)SendServerPingClient:(Packet*)packet;

/// @description the client app needs to ping server, this can be called on a thread in a background, time before server kick you is 15 seconds approx, so move fast!
- (void)SendClientPingServer;

/// @description send request to get a room related data
- (void)SendGetDataByRoomID;

/// @description send request to get a game related data
- (void)SendGetGameDataByGameID;

/// @description send request to change current user room
- (void)SendChangeRoom;

/// @description send request to get room games listing
- (void)sendRematchGameData:(NSNumber *)oppId;
- (void)SendGetGamesByRoomID;
- (void)sendCurrentMoveToServer:(NSDictionary*)dict;
- (void)sendConfirmationOfCurrentMoveRecieved:(NSNumber*)userId;
-(void)appTerminatedCloseOnlineGame:(NSNumber*)userId;
-(void)cancelOnlineGameChalenge;
-(void)signUpUser:(NSDictionary*)dict;
-(void)updateUserProfile:(NSMutableDictionary *)dict;
-(void)resignOnlineGameChalenge:(NSNumber *)opponentId;
- (void)sendMessageToOtherPlayer:(NSNumber*)oppId:(NSString *)message;
- (void)sendGameAbortToServer:(NSNumber*)oppID;
- (void)SendCheckMateUserGameFinishedToServer:(NSNumber *)oppId;
/// @description send chat message packet to server
/// @param message the message to send/braodcast
/// @param chatID this is the chat type filter i.e. room or player or all players etc.. @"0" for global server chat i think... xD
/// @param receivingUserName if directed to any particular user then the user's name goes here, else keep this empty @""
/// @param recevingGameID if directed to an inprogress game then game id comes here else keep this @"0"
/// @param chatType
- (void)SendChatMessage:(NSString*)message ChatMessageID:(NSString*)chatID ToUser:(NSString*)receivingUserName WithGameID:(NSString*)recevingGameID ChatType:(int)chatType MessageType:(int)messageType AudienceType:(int)audienceType;

-(void)destruct;

@end

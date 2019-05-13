//
//  AppOnline.m
//  AppOnline
//
//  Created by user on 12/29/14.
//  Copyright (c) 2014 nabeeg. All rights reserved.
//

#include "AppOnline.h"
#import "XmlParser.h"
#import "CommonTasks.h"
#import "AppZipper.h"
#import "SocketSession.h"
#import "Packet.h"
#import "DataTable.h"
#import "UserSession.h"
#import "MyManager.h"
//#import "UIView+Toast.h"

@implementation AppOnline
{
    // _______________________________________________________________________________
    
    volatile int packetNextSequenceNo;
    volatile int pingTimeCounter;
    int reset;
    int resetLimit;
     
}


static volatile AppOnline* appOnline = nil;
 
+ (volatile AppOnline *)instance
{
    if (!appOnline)
        appOnline = [[AppOnline alloc] init];
    
    
    return appOnline;
}


- (void)ResetParameters
{
    reset = 0;
    resetLimit = 3;
    
    packetNextSequenceNo = 0;
    
    if (self.socketPollTime == 0)
        self.socketPollTime = 10;
}

- (void)SetLoginUserName:(NSString *)username andPassword:(NSString *)password
{
    if (!self.User)
        self.User = [[UserSession alloc] initWithUserName:username andPassword:password];
    else
    {
        if (![self.User.UserName isEqualToString:username])
            [self.User DeinitUserSession];
        
        [self.User SetUsername:username andPassword:password];
    }
}

//save fen to check packet
-(void)addFenListToArray:(NSString*)fen{
    if (_arrFenList == nil) {
        _arrFenList = [[NSMutableArray alloc] init];
    }
    [_arrFenList addObject:fen];
    NSLog(@"added fen list",self.arrFenList);
}


- (void)FindAndConnectToServer
{
    NSLog(@"");
    if (!self.socketSession){
        self.socketSession = [[SocketSession alloc] init];//[SocketSession sharedInstance]; //; µ∆
        NSLog(@"");
    }
    
    [self Disconnect];
    if ([self.socketSession Setup])
    {
        [self SubscribeToInternalNotifications];
        // connected
        if ([self CheckServerConnectionStateForDataFlow:100000])
        {
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
            {
                [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                    [self.socketSession SendHandShakeRequest];
                }];
                return;
            }
        }
    }
    
    // not connected...
    [self Disconnect];
    // fire some notifiction or return false?
}

- (void)Disconnect
{
    if (self.socketSession)
    {
        [self.socketSession TearDown:YES];
        [self.socketSession ResetParameters];
    }
    [self UnsubscribeToNotifications:self];
}

- (void)FindAndConnectToServerWithNotification
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineIsConnectingNotification" object:nil];
        
        [self FindAndConnectToServer];
        if (self.isConnected)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SocketConnectedNotification" object:nil];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SocketDisconnectedNotification" object:nil];
        
    }];
}


- (void)DisconnectWithNotification
{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (self.isConnected)
        {
            [self Disconnect];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SocketDisconnectedNotification" object:nil];
        }
    }];
}

- (BOOL)isConnected
{
    return [self CheckServerConnectionStateForDataFlow:0];
}

- (void)Ping
{
    if (self.isConnected)
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self SendClientPingServer];
        }];
}

- (void)PingOrReconnectToServer
{
    if (self.isConnected)
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self SendClientPingServer];
        }];
    else
    {
        [self FindAndConnectToServerWithNotification];
    }
}






// _____________________________________________________________________________________________________________________

- (id)init
{
    self = [super init];
    if (self)
    {
        // todo?
        self.theFlag = false;
        [self ResetParameters];
    }
    
    return self;
}

- (id)initWithSocket:(id)socketStreamDelegateClassReference
{
    self = [super init];
    if (self)
    {
        [self ResetParameters];
        
        self.socketSession = [[SocketSession alloc] init];//[SocketSession sharedInstance]; // µ∆
        BOOL connectedToServer = [self.socketSession Setup];
        if (connectedToServer)
        {
            [CommonTasks LogMessage: [NSString stringWithFormat: @"connecting... %@", [CommonTasks Good]]
                    MessageFlagType: logMessageFlagTypeInfo];
            
            // subscribe to internal notifications
            [self SubscribeToInternalNotifications];
            
        }
        else
            [CommonTasks LogMessage: [NSString stringWithFormat: @"unable to connect %@", [CommonTasks Ugly]]
                    MessageFlagType: logMessageFlagTypeError];
    }
    return self;
}

- (id)DeinitAppOnline:(id)caller
{
    if (caller)
        [self UnsubscribeToNotifications:caller];
    [self UnsubscribeToNotifications: self];
    
    if (self.timerThread)
    {
        [self DeinitAndStopTimerThread];
        self.timerThread = nil;
    }
    if (self.socketSession)
    {
        [self.socketSession TearDown: YES];
        self.socketSession = nil;
    }
    if (self.User)
    {
        [self.User DeinitUserSession];
        self.User = nil;
    }
    
    [self ResetParameters];
    
    return nil;
}


- (void)SubscribeToInternalNotifications
{
    // all internal notifications implentation _____________________________________________________________________________
    //Create Game Chalenge Notification
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createGameChalengeNotMatchedNotification:)
                                                 name: @"icPacketCreateGameChalengeResponseNoMatch"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createGameChalengeMatchedNotification:)
                                                 name: @"icPacketCreateGameChalengeResponseMatch"
                                               object: nil];
    
    //MARK:- Current move chalenge
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(getCurrentGameResponseUpdate:)
                                                 name: @"icPacketSendCurrentMoveToServerResponse"
                                               object: nil];
    
    /*
     these are related to socket connections
     */
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(SocketConnectedNotification:)
                                                 name: @"SocketConnectedNotification"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(SocketDisconnectedNotification:)
                                                 name: @"SocketDisconnectedNotification"
                                               object: nil];
    
    /*
     these are related to user status as given by the server
     */
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerLoginUserResponse:)
                                                 name: @"icPacketLoginUserResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerUpdateUserStatusResponse:)
                                                 name: @"icPacketUpdateUserStatusResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(ServerValidateVersionResponse:)
                                                 name: @"icPacketValidateVersionResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerGetUserInfoResponse:)
                                                 name: @"icPacketGetUserInfoByUserIDResponse"
                                               object: nil];
    
    

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(ServerGetAllKeyValuesResponse:)
                                                 name: @"icPacketGetAllKeyValuesResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerUpdateUserRow:)
                                                 name: @"icPacketUpdateUserRowResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerRemoveUserRowReceived:)
                                                 name: @"icPacketRemoveUserRowResponse"
                                               object: nil];
    
    /*
     these are related to room and their data
     */
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(ServerGetAllRoomsResponse:)
//                                                 name: @"icPacketGetAllRoomsResponse"
//                                               object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(ServerGetDataByRoomIdRespones:)
//                                                 name: @"icPacketGetDataByRoomIdResponse"
//                                               object: nil];
   // [[NSNotificationCenter defaultCenter] addObserver: self
                             //                selector: @selector(ServerChangeRoomResponse:)
                              //                   name: @"icPacketChangeRoomResponse"
                              //                 object: nil];
    
    /*
     these are related to games
     */
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerGetGameDataByGameIDResponse:)
                                                 name: @"icPacketGetGameDataByGameIdResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerUpdateGameReceived:)
                                                 name: @"icPacketUpdateGameReceived"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerGetGamesByRoomIDRespones:)
                                                 name: @"icPacketGetGamesByRoomIDRespones"
                                               object: nil];
    
    /*
     these are related to chats
     */
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerChatMessageReceived:)
                                                 name: @"isPacketChatMessageReceived"
                                               object: nil];
    
    /*
     these are related to ping
     */
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ServerPingClientResponse:)
                                                 name: @"icPacketServerPingClientResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(ClientPingServerResponse:)
                                                 name: @"icPacketClientPingServerRespones"
                                               object: nil];
}



- (void)SubscribeToNotifications:(id)subscriber
{
    /*
     these notification are for the UIViewController in use, the can be use to show or hide online connnectivity dialogues
     */
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(cretaeGameChalengeResponseWaitMatched:)
                                                 name: @"cretaeGameChalengeResponseWaitMatched"
                                               object: nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver: subscriber
    //                                         selector: @selector(getCurrentGameResponseUpdate:)
    //                                             name: @"getCurrentGameResponseUpdate"
      //                                         object: nil];
    //
    // this is called when apponline tries auto-reconnect and may require to show a loading screen on UI view
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineIsConnectingNotification:)
                                                 name: @"AppOnlineIsConnectingNotification"
                                               object: nil];
    // this is called when apponline tries disconnecting and may require to show a loading screen on UI view
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineHasDisconnectedNotification:)
                                                 name: @"AppOnlineHasDisconnectingNotification"
                                               object: nil];
    
    
    
    
    /*
     the login type notifications are used to show login status dialogues
     */
    // this is called when a user is successfully authenticated by the server
    NSLog(@"%@ >><><><<<><><><><><><><>><><><><><><>", subscriber);
//    [[NSNotificationCenter defaultCenter] addObserver: subscriber
//                                             selector: @selector(AppOnlineLoginSuccessNotification:)
//                                                 name: @"AppOnlineLoginSuccessNotification"
//                                               object: nil];
    
    // this is called when a user is stopped by the server from entering, possible reason could be authentication failed or banned
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineLoginFailureNotification:)
                                                 name: @"AppOnlineLoginFailureNotification"
                                               object: nil];
    
    /*
     any errot in apponline communication is notified bu this event to the view controllers
     */
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineErrorNotification:)
                                                 name: @"AppOnlineErrorNotification"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineServerTimeNotification:)
                                                 name: @"AppOnlineServerTimeNotification"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineUserIsBanOrBlockedInRoom:)
                                                 name: @"AppOnlineUserIsBanOrBlockedInRoom"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(AppOnlineLaunchKibitzGame:)
                                                 name:@"AppOnlineLaunchKibitzGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(AppOnlineUpdateKibitzGame:)
                                                 name:@"AppOnlineUpdateKibitzGame"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineUpdateGame:)
                                                 name: @"AppOnlineUpdateGame"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineUpdateUserRow:)
                                                 name: @"AppOnlineUpdateUserRow"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineUpdateGamesList:)
                                                 name: @"AppOnlineUpdateGamesList"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: subscriber
                                             selector: @selector(AppOnlineReset:)
                                                 name: @"AppOnlineReset"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(AppOnlineChatNotification:)
                                                 name:@"AppOnlineChatNotification"
                                               object:nil];
}

- (void)UnsubscribeToNotifications:(id)unsubscriber
{
    [[NSNotificationCenter defaultCenter] removeObserver:unsubscriber];
}

- (void)SocketConnectedNotification:(NSNotification*)notificationSender
{
    if (self.isConnected)
        [self SendLoginUser:self.User.UserName Password:self.User.UserPassword];
}

- (void)SocketDisconnectedNotification:(NSNotification*)notificationSender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineHasDisconnectedNotificaiton" object:nil];
    [self DeinitAppOnline:self];
}

- (void)AppOnlineIsConnectingNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineHasDisconnectingNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineReset:(NSNotification*)notificationSender { } //•

- (void)AppOnlineLoginSuccessNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineLoginFailureNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineErrorNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineServerTimeNotification:(NSNotification*)notificationSender { }

- (void)AppOnlineUserIsBanOrBlockedInRoom:(NSNotification*)notificationSender { }

- (void)AppOnlineLaunchKibitzGame:(NSNotification*)notificationSender { }

- (void)AppOnlineUpdateKibitzGame:(NSNotification*)notificationSender { }

- (void)AppOnlineUpdateGame:(NSNotification*)notificationSender { }

- (void)AppOnlineUpdateUserRow:(NSNotification*)notificationSender { }

- (void)AppOnlineUpdateGamesList:(NSNotification*)notificationSender { }

- (void)AppOnlineChatNotification:(NSNotification*)notificationSender { }



- (BOOL)CheckServerConnectionState
{
    if (self.socketSession != nil && self.socketSession.isConnected)
    {
        [CommonTasks LogMessage:[NSString stringWithFormat:@"server connection is ok %@", [CommonTasks Good]] MessageFlagType:logMessageFlagTypeInfo];
        return YES;
    }
    
    [CommonTasks LogMessage:[NSString stringWithFormat:@"server socket connection is not ok %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeWarning];
    
    return NO;
}

- (BOOL)CheckServerConnectionStateForDataFlow:(int)numberOfTimesToCheck
{
    BOOL socketStatus = NO;
    do
    {
        if ([self CheckServerConnectionState])
        {
            socketStatus = YES;
            break;
        }
    } while (--numberOfTimesToCheck > 0);

    
    if (socketStatus)
    {
        if ([self.socketSession CanSendDataOverSocket:0])
        {
            reset = 0;
            return YES;
        }
    }
    // todo?
    // instead of calling disconnect, call reset and reconnect on socket object here
    reset++;
    if (reset >= resetLimit)
    {
        reset = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineReset" object:self userInfo:nil];
    }
    
    [CommonTasks LogMessage:[NSString stringWithFormat:@"server connection is not ok %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeWarning];
    return NO;
}

/// @description this is used to get next packet sequence to be send within the packet
/// @returns packetNextSequenceNo incremented by 1
- (int)GetNextPacketSequenceNumber
{
    return ++packetNextSequenceNo;
}





- (void)InitAndRunTimerThread
{
    if (self.timerThread == nil)
    {
        self.timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(DoTimerThreadWork) object:nil];
        self.timerThread.name = @"timer thread";
        
        pingTimeCounter = 0;
    }
    if (!self.timerThread.isExecuting)
        [self.timerThread start];
}

- (void)SleepTimerThread
{
    [NSThread sleepForTimeInterval:1.0];
}

/// @description the actual work that is done by the thread
- (void)DoTimerThreadWork
{
    while (YES)
    {
        [self performSelector:@selector(SleepTimerThread) onThread:self.timerThread withObject:nil waitUntilDone:YES];
        if (self.timerThread.isCancelled)
            [NSThread exit];
        
        @synchronized(self.User.ServerDateTime)
        {
            if (self.User.ServerDateTime != nil)
                self.User.ServerDateTime = [self.User.ServerDateTime dateByAddingTimeInterval:1.0];
            //[CommonTasks LogMessage:[NSString stringWithFormat:@"TimerThread: server time is [%@]", [self.User.ServerDateTime descriptionWithLocale:[NSLocale systemLocale]]] MessageFlagType:logMessageFlagTypeInfo];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *timeString = [formatter stringFromDate:self.User.ServerDateTime];
            NSDictionary *timeDict = [NSDictionary dictionaryWithObjectsAndKeys:timeString, @"time", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateServerTime" object:self userInfo:timeDict];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLoggedInNotification" object:self userInfo:nil];
        }
        
        // client ping server
        pingTimeCounter++;
        if (pingTimeCounter == 10)
        {
            pingTimeCounter = 0;
            @synchronized(self)
            {
                if ([self CheckServerConnectionStateForDataFlow:0])
                    [self SendClientPingServer];
            }
        }
        
    }
}



- (void)DeinitAndStopTimerThread
{
    if (self.timerThread != nil)
    {
        [self.timerThread cancel];
    }
}


-(void)appTerminatedCloseOnlineGame:(NSNumber*)userId{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketAppTerminateCloseGame]];
        [packet PacketAddOrSetForKey:101 Value:userId]; // default is 0 unless user has logged in successfully
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

-(void)cancelOnlineGameChalenge{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketCancelOnlineGameChalenge]];
        [packet PacketAddOrSetForKey:101 Value:self.User.UserID]; // default is 0 unless user has logged in successfully
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

-(void)resignOnlineGameChalenge:(NSNumber *)opponentId{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketAppResignGame]];
        [packet PacketAddOrSetForKey:101 Value:opponentId]; // default is 0 unless user has logged in successfully
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Resign Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}


- (void)sendConfirmationOfCurrentMoveRecieved:(NSNumber*)userId
{
    // init user object here!
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketCurrentMoveRecieved]];
        [packet PacketAddOrSetForKey:101 Value:userId]; // default is 0 unless user has logged in successfully
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)sendCurrentMoveToServer:(NSDictionary*)dict
{
    // init user object here!
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketSendCurrentMoveToServer]];
        [packet PacketAddOrSetForKey:101 Value:[dict valueForKey:@"ChalengeID"]]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:102 Value:[dict valueForKey:@"CurrentUser"]];
        [packet PacketAddOrSetForKey:103 Value:[dict valueForKey:@"from"]];
        [packet PacketAddOrSetForKey:104 Value:[dict valueForKey:@"to"]];
        [packet PacketAddOrSetForKey:105 Value:[dict valueForKey:@"Opponent"]];
        [packet PacketAddOrSetForKey:106 Value:[dict valueForKey:@"fen"]];
        [packet PacketAddOrSetForKey:108 Value:[dict valueForKey:@"PGN"]];
        [packet PacketAddOrSetForKey:109 Value:[dict valueForKey:@"WT"]];
        [packet PacketAddOrSetForKey:110 Value:[dict valueForKey:@"BT"]];
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)sendGameAbortToServer:(NSNumber*)oppID
{
    // init user object here!
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketGameAbbort]];
        [packet PacketAddOrSetForKey:101 Value:oppID]; // default is 0 unless user has logged in successfully
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Abort Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}


-(void)sendMessageToOtherPlayer:(NSNumber*)oppId:(NSString *)message
{
    // init user object here!
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketMessageToOtherPlayer]];
        [packet PacketAddOrSetForKey:101 Value:oppId]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:102 Value:message];
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)sendCreateGameData:(NSDictionary*)dict
{
    // init user object here!
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketCreateGame]];
        [packet PacketAddOrSetForKey:101 Value:self.User.UserID];//[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:102 Value:@"Standard"];
        [packet PacketAddOrSetForKey:103 Value:[dict valueForKey:@"time"]];
        [packet PacketAddOrSetForKey:104 Value:[[NSNumber alloc] initWithInt:1]];
        [packet PacketAddOrSetForKey:105 Value:@"Random"];
        
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Create Game packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)sendRematchGameData:(NSNumber *)oppId
{
    // init user object here!
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketCreateGameChalengeReMatch]];
        [packet PacketAddOrSetForKey:101 Value:self.User.UserID];//[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:102 Value:oppId];
        [packet PacketAddOrSetForKey:103 Value:[[NSNumber alloc] initWithInt:0]];
        [packet PacketAddOrSetForKey:104 Value:@""];
        [packet PacketAddOrSetForKey:105 Value:@"Random"];
         [packet PacketAddOrSetForKey:106 Value:@"Random"];
        
        NSLog(@"%@",packet);
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Rematch packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

-(void)signUpUser:(NSDictionary *)dict{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDSignUpUser]];
        [packet PacketAddOrSetForKey:201 Value:[dict valueForKey:@"UserName"]]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:202 Value:[dict valueForKey:@"Password"]];
        [packet PacketAddOrSetForKey:203 Value:[dict valueForKey:@"Email"]];
        [packet PacketAddOrSetForKey:204 Value:[dict valueForKey:@"FirstName"]];
        [packet PacketAddOrSetForKey:205 Value:[dict valueForKey:@"LastName"]];
        [packet PacketAddOrSetForKey:206 Value:[dict valueForKey:@"CountryCode"]];
        //[packet PacketAddOrSetForKey:203 Value:[dict valueForKey:@"C"]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"login user packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
    }];
     }

-(void)checkMasla{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:449]];
       
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"checkMasla packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
    }];
}


- (void)SendSocialLoginUser:(NSDictionary *)dict
{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (!self.User)
            self.User = [[UserSession alloc] initWithUserName:[dict valueForKey:@"userName"] andPassword:nil];
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:@"0"]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDLoginUser]];
        [packet PacketAddOrSetForKey:icPacketLoginUserUserName Value:self.User.UserName];
        [packet PacketAddOrSetForKey:icPacketLoginUserPassword Value:self.User.UserPasswordEncrypted];
        [packet PacketAddOrSetForKey:icPacketLoginUserMachineCode Value:[CommonTasks MachineCode]];
        [packet PacketAddOrSetForKey:icPacketLoginUserIp Value:[CommonTasks GetIPAddress:YES]];
        [packet PacketAddOrSetForKey:icPacketLoginUserSysInfo Value:[CommonTasks SystemInfo]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        [packet PacketAddOrSetForKey:106 Value:@"1"];
        [packet PacketAddOrSetForKey:107 Value:[dict valueForKey:@"email"]];
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"login user packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}


-(void)checkForAppVersion{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
         // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:428]];
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Version Check Packet Send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
    
}

-(void)updateUserProfile:(NSMutableDictionary *)dict{
    NSLog(@"ddd");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
       // NSString *image = [dict valueForKey:@"ProfileImage"];
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketUpdateUserProfile]];
        [packet PacketAddOrSetForKey:201 Value:self.User.UserID]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:202 Value:[dict valueForKey:@"FirstName"]];
        [packet PacketAddOrSetForKey:203 Value:[dict valueForKey:@"LastName"]];
        [packet PacketAddOrSetForKey:204 Value:[dict valueForKey:@"CountryCode"]];
//        if (image != nil)
//        [packet PacketAddOrSetForKey:205 Value:[dict valueForKey:@"ProfileImage"]];
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"Update Profile Packet Send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
    
}

- (void)SendLoginUser:(NSString *)userName Password:(NSString *)password
{
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{

        if (!self.User)
            self.User = [[UserSession alloc] initWithUserName:userName andPassword:password];
        
        // so now we pack the packet as happening in .Net client!
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:@"0"]; // default is 0 unless user has logged in successfully
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDLoginUser]];
        [packet PacketAddOrSetForKey:icPacketLoginUserUserName Value:self.User.UserName];
        [packet PacketAddOrSetForKey:icPacketLoginUserPassword Value:self.User.UserPasswordEncrypted];
        [packet PacketAddOrSetForKey:icPacketLoginUserMachineCode Value:[CommonTasks MachineCode]];
        [packet PacketAddOrSetForKey:icPacketLoginUserIp Value:[CommonTasks GetIPAddress:YES]];
        [packet PacketAddOrSetForKey:icPacketLoginUserSysInfo Value:[CommonTasks SystemInfo]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"login user packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ServerLoginUserResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        
        self.User.LoginStatus = [packet PacketGetIntegerForKey:icPacketLoginUserResponseLoginStatusID];
        if (    self.User.LoginStatus == loginStatusUnknown
            ||  self.User.LoginStatus == loginStatusWrongUserNamePassowrd)
        {
            [CommonTasks LogMessage:@"login response: user restricted due to LoginStatus, closing socket connections"
                    MessageFlagType:logMessageFlagTypeInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName: @"AppOnlineLoginFailureNotification"
                                                                object: self
                                                              userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [NSNumber numberWithInt:appOnlineUserCredentialsFailed], [NSNumber numberWithInt:appOnlineNotificationType],
                                                                         @"Login Failed", [NSNumber numberWithInt:appOnlineNotificationTitle],
                                                                         @"User authentication failed please retry", [NSNumber numberWithInt:appOnlineNotificationMessage],
                                                                         nil]];
            
            return;
        }
        
        self.User.ServerDateTime = [CommonTasks FormatServerDateTime:[packet PacketGetStringForKey:icPacketLoginUserResponseServerDateTime]];
        self.User.BanStartDateTime = [CommonTasks FormatUserBanDateTime:[packet PacketGetStringForKey:icPacketLoginUserResponseBanStartDateTime]];
        self.User.BanEndDateTime = [CommonTasks FormatUserBanDateTime:[packet PacketGetStringForKey:icPacketLoginUserResponseBanEndDateTime]];
        
        if (([self.User.ServerDateTime compare:self.User.BanStartDateTime] == NSOrderedDescending)
            || ([self.User.ServerDateTime compare:self.User.BanEndDateTime] == NSOrderedAscending))
        {
            [CommonTasks LogMessage:@"login response: user restricted due to BanStartDateTime OR BanEndDateTime, closing socket connections"
                    MessageFlagType:logMessageFlagTypeInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName: @"AppOnlineLoginFailureNotification"
                                                                object: self
                                                              userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [NSNumber numberWithInt:appOnlineBanishedUser], [NSNumber numberWithInt:appOnlineNotificationType],
                                                                         @"Banned User", [NSNumber numberWithInt:appOnlineNotificationTitle],
                                                                         [NSString stringWithFormat:@"You are banned till %@", self.User.BanEndDateTime.description], [NSNumber numberWithInt:appOnlineNotificationMessage],
                                                                         nil]];
            
            return;
        }
        
        
        self.User.EngineName = [CommonTasks GetEngineName];
        [self InitAndRunTimerThread];
        
        BOOL isLogin = NO;
        
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketLoginUserResponseUserData]];
        if ([xml isValidXml:nodeNewDataSet] && [xml isValidXml:nodeUser])
            if ([xml load:nil])
                if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                {
                    self.User.UserData = [xml.dataPktNewDataSetTable valueForKey:@"User"];
                    self.User.UserInfoData = [xml.dataPktNewDataSetTable valueForKey:@"User"];
                    isLogin = YES;
                    self.User.RoomID = [CommonTasks Zero];
                }
        
        
        
        [CommonTasks LogMessage:@"login user response notification fired!" MessageFlagType:logMessageFlagTypeInfo];
        
        if (isLogin)
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
                [self SendUpdateUserStatus];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLoginSuccessNotification" object:self userInfo:nil];
            
        });
        
    }];
}

- (void)SendLogOffUser
{
    /*
     
     IcPacket pkt = new IcPacket();
     Set(IcPacket.Version, Config.Version);
     Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     
     pkt.Set(IcPacket.ID, IcPacket.LogoffUser);
     pkt.Set(IcPacket.CurrentUserID, userID);
     pkt.Set(Rqp.LogoffUser.UserID, userID);
     
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
//    self.txtFieldPassword.text =
//    self.txtFieldUserName.text =
    
    if (!self.User)
        self.User = [[UserSession alloc] initWithUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"Password"]];
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{

        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[NSNumber numberWithInt:icPacketPacketIDLogoffUser]];
        [packet PacketAddOrSetForKey:icPacketLogoffUserUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[NSNumber numberWithInt:[self GetNextPacketSequenceNumber]]];
      //  self.User = nil;
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"log off user packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
    }];
}




- (void)SendUpdateUserStatus
{
    /*
     
     IcPacket pkt = new IcPacket() // note plz! every packet in .Net is adding SysParam on init! version in iOS should correspond to something iOS..
     {
         protected override void AddSysParams()
         {
             Set(IcPacket.Version, Config.Version);
             Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
         }
     };
     
     pkt.Set(IcPacket.ID, IcPacket.UpdateUserStatus);
     pkt.Set(IcPacket.CurrentUserID, userID);
     pkt.Set(Rqp.UpdateUserStatus.UserStatusID, (int)userStatus);
     pkt.Set(Rqp.UpdateUserStatus.MachineCode, machineCode);
     pkt.Set(Rqp.UpdateUserStatus.RoomID, currentUser.RoomID);
     pkt.Set(Rqp.UpdateUserStatus.IsLogIn, isLogin);
     pkt.Set(Rqp.UpdateUserStatus.EngineName, engineName);
     pkt.Set(Rqp.UpdateUserStatus.ChessTypeID, (int) chessType);
     pkt.Set(Rqp.UpdateUserStatus.IsIdle, isIdle);       // 4-Oct-2011 (Arsalan Tamiz)
     pkt.Set(Rqp.UpdateUserStatus.IsPause, isPause);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        if (self.User.UserData != nil)
        {
            Packet *packet = [[Packet alloc] init];
            [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
            [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
            [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDUpdateUserStatus]];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusUserStatusID Value:@"1"];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusMachineCode Value:[CommonTasks MachineCode]];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusRoomID Value:@"256"];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusIsLogIn Value:[CommonTasks TrueLies]];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusEngineName Value:[CommonTasks GetEngineName]];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusChessTypeID Value:@"1"];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusIsIdle Value:[CommonTasks Falsehood]];
            [packet PacketAddOrSetForKey:icPacketUpdateUserStatusIsPause Value:[CommonTasks Falsehood]];
            [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
            
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
            {
                [self.socketSession SendString:[packet description] needToCompress:YES];
                [CommonTasks LogMessage:@"update user status packet send" MessageFlagType:logMessageFlagTypeSystem];
            }
        }
    
    }];
}


- (void)ServerUpdateUserStatusResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        
        BOOL login = [[[packet PacketGetStringForKey:icPacketUpdateUserStatusResponseIsLogIn] lowercaseString] isEqualToString:[[CommonTasks TrueLies] lowercaseString]] ? YES : NO;
        if (login)
        {
            NSString *versionAvailable = [packet PacketGetStringForKey:icPacketUpdateUserStatusResponseVersionAvailable];
            if ([versionAvailable isEqualToString:[CommonTasks Version]] == NO)
            {
                [CommonTasks LogMessage: [NSString stringWithFormat: @"lol, go update now get lost [%@]", [CommonTasks Ugly]]
                        MessageFlagType: logMessageFlagTypeError];
                
                // todo?
                // login failed notification
            }
            else
            {
                // chat message
                [CommonTasks LogMessage: [NSString stringWithFormat: @"congratz you are in [%@]", [CommonTasks Good]]
                        MessageFlagType: logMessageFlagTypeInfo];
            }
        }
        
        [CommonTasks LogMessage: @"update user status response notification fired!"
                MessageFlagType: logMessageFlagTypeInfo];
        
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
            [self SendGetAllKeyValues];
    }];
}

- (void)ServerValidateVersionResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{

        // todo
        // close socket, and ask user to update app through store
        // show alert that user needs to update
        // return back to main screen
        [[NSNotificationCenter defaultCenter] postNotificationName: @"AppOnlineLoginFailureNotification"
                                                            object: self
                                                          userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [NSNumber numberWithInt:appOnlineAppNeedsToUpdate], [NSNumber numberWithInt:appOnlineNotificationType],
                                                                     @"Update App", [NSNumber numberWithInt:appOnlineNotificationTitle],
                                                                     @"Your app needs to update", [NSNumber numberWithInt:appOnlineNotificationMessage],
                                                                     nil]];
        
        [CommonTasks LogMessage:@"the app needs to update first" MessageFlagType:logMessageFlagTypeError];

    }];
}




- (void)SendGetAllKeyValues
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDGetAllKeyValues]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"update user status packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ServerGetAllKeyValuesResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        self.User.isLogin = NO;
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetAllKeyValuesResponseDatatable]];
        if ([xml isValidXml:nodeNewDataSet])
            if ([xml load:nil])
                if (xml.dataPktNewDataSet && xml.dataPktNewDataSet.count > 0)
                {
                    self.User.ServerKeyValues = [xml.dataPktNewDataSetTable objectForKey:@"Table1"];
                    self.User.isLogin = YES;
                }
        
        if (self.User.isLogin)
        {
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
                [self SendGetUserInfo];
        }
        else
        {
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
                [self SendLogOffUser];
        }
    }];
    
}



- (void)SendGetUserInfo
{
    /*
     
     IcPacket pkt = new IcPacket();
     pkt.Set(IcPacket.ID, IcPacket.GetUserInfoByUserID);
     pkt.Set(Rqp.GetUserInfoByUserID.UserID, userID);
     
     */
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDGetUserInfoByUserID]];
        [packet PacketAddOrSetForKey:icPacketGetUserInfoUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"get user info packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
    }];
}

- (void)ServerGetUserInfoResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        self.User.isLogin = NO;
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetUserInfoResponseDatatable]];
        if ([xml isValidXml:nodeNewDataSet])
            if ([xml load:nil])
                if (xml.dataPktNewDataSet && xml.dataPktNewDataSet.count > 0)
                {
                    self.User.UserInfo = [xml.dataPktNewDataSetTable objectForKey:@"Table"];
                    self.User.isLogin = YES;
                    
                    if ([[self.User.UserInfo GetColumnsName] containsObject:@"UserImage"])
                    {
                        NSData *imageXmlData = [[NSData alloc] initWithBase64EncodedString:[self.User.UserInfo FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"UserImage"] options:0];
                        NSString *imageXmlString = [[NSString alloc] initWithData:imageXmlData encoding:NSUTF8StringEncoding];
                        if (imageXmlString)
                        {
                            xml = [[XmlParser alloc] initWithXmlString:imageXmlString];
                            [xml replaceXmlNodeElement:@"DocumentElement" WithNewNodeElement:@"NewDataSet"];
                            if ([xml isValidXml:nodeNewDataSet])
                                if ([xml load:nil])
                                {
                                    if (xml.dataPktNewDataSet && xml.dataPktNewDataSetTable.count > 0)
                                    {
                                        NSString *imageBytesString = [[xml.dataPktNewDataSetTable objectForKey:@"UserImageTable"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"ImageBytes"];
                                        //NSData *imageBytesData = [imageBytesString dataUsingEncoding:NSUTF8StringEncoding];
                                        NSData *imageBytesData = [[NSData alloc] initWithBase64EncodedString:imageBytesString options:0];
                                        self.User.UserImage = [UIImage imageWithData:imageBytesData];
                                    }
                                }
                        }
                    }
                }
        
        if (self.User.isLogin)
        {
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime]){
                
            }
               // [self SendGetAllRooms];
        }
        else
        {
            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
            {
                
            }
//                [self SendLogOffUser];
        }
    
    }];
}



//- (void)SendGetAllRooms
//{
//    /*
//
//     IcPacket pkt = new IcPacket();
//     {
//         Set(IcPacket.Version, Config.Version);
//         Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
//     }
//
//     pkt.Set(IcPacket.ID, IcPacket.GetAllRooms);
//     pkt.Set(Rqp.GetAllRooms.isRefresh, isRefresh);          // no need to use this in ios
//     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
//
//     */
//    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
//
//        Packet *packet = [[Packet alloc] init];
//        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
//        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
//        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDGetAllRooms]];
//        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
//
//        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
//        {
//            [self.socketSession SendString:[packet description] needToCompress:YES];
//            [CommonTasks LogMessage:@"get all rooms packet send" MessageFlagType:logMessageFlagTypeSystem];
//        }
//
//    }];
//}

//- (void)ServerGetAllRoomsResponse:(NSNotification*)notificationSender
//{
//    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
//
//        self.User.isLogin = NO;
//
//        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
//
//        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetAllRoomsResponseDataTable]];
//        if ([xml isValidXml:nodeNewDataSet] && [xml isValidXml:nodeRoom])
//            if ([xml load:nil])
//                if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
//                {
//                    self.User.Rooms = [xml.dataPktNewDataSetTable valueForKey:@"Room"];
//
//                    self.User.isLogin = YES;
//                    [CommonTasks LogMessage:[NSString stringWithFormat:@"%@", [self.User.Rooms FetchAllRowsFromTable]]
//                            MessageFlagType:logMessageFlagTypeInfo];
//                }
//
//        [CommonTasks LogMessage:@"room data recieved" MessageFlagType:logMessageFlagTypeInfo];
//
//
//        // set user status as logged in and notify the UI about it!
//        if (self.User.isLogin) {
//            NSLog(@"AppOnlineLoginSuccessNotification∆∆∆∆∆");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLoginSuccessNotification" object:self userInfo:nil];
//        }
//        else
//        {
//            if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
//                [self SendLogOffUser];
//        }
//    }];
//}



- (void)SendChangeRoom
{
    /*
     
     IcPacket kv = new IcPacket();
     Set(IcPacket.Version, Config.Version);
     Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     
     kv.Set(IcPacket.ID, IcPacket.ChangeRoom);
     kv.Set(Rqp.ChangeRoom.RoomID, roomID);
     kv.Set(Rqp.ChangeRoom.UserStatus, userStatusID);
     kv.Set(Rqp.ChangeRoom.EngineID, engineID);
     kv.Set(Rqp.ChangeRoom.IsGuest, isGuest);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDChangeRoom]];
        [packet PacketAddOrSetForKey:icPacketChangeRoomRoomID Value:self.User.RoomID];
        [packet PacketAddOrSetForKey:icPacketChangeRoomUserStatus Value:[self.User.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"StatusID"]];
        [packet PacketAddOrSetForKey:icPacketChangeRoomEngineID Value:@"1"];
        [packet PacketAddOrSetForKey:icPacketChangeRoomIsGuest Value:[CommonTasks Falsehood]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"change room send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

//- (void)ServerChangeRoomResponse:(NSNotification*)notificationSender
//{
//    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
//
//        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
//
//        // remove previous room data and game data if any
//        if (self.User.Game)
//        {
//            for (int i = 0; i < [self.User.Game allKeys].count; i++)
//                [(DataTable*)[self.User.Game objectForKey:[self.User.Game allKeys][i]] RemoveTable:YES];
//            self.User.Game = nil;
//        }
//        if (self.User.RoomInfoAppData)
//        {
//            for (int i = 0; i < [self.User.RoomInfoAppData allKeys].count; i++){
//                [(DataTable*)[self.User.RoomInfoAppData objectForKey:[self.User.RoomInfoAppData allKeys][i]] RemoveTable:YES];
//                NSLog(@"iiiiiiiiiiiiiiii%d",i);
//            }
//            self.User.RoomInfoAppData = nil;
//        }
//
//        NSString *isBlocked = [packet PacketGetStringForKey:icPacketChangeRoomResponseIsBlocked];
//        NSString *isBan = [packet PacketGetStringForKey:icPacketChangeRoomResponseISBanUserForTournament];
//
//        if (isBan || isBlocked || [isBan isEqualToString:[CommonTasks TrueLies]] || [isBlocked isEqualToString:[CommonTasks TrueLies]])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUserIsBanOrBlockedInRoom" object:self];
//            return;
//        }
//
//
//        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketChangeRoomResponseRoomData]];
//        if ([xml isValidXml:nodeAppData])
//            if ([xml load:nil])
//                if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
//                {
//                    self.User.RoomInfoAppData = xml.dataPktNewDataSetTable;
//
//                    [CommonTasks LogMessage:@"got AppData/RoomInfo" MessageFlagType:logMessageFlagTypeInfo];
//                }
//
//        // set user status as logged in and notify the UI about it!
//        if (!self.User.isLogin)
//            self.User.isLogin = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineloginSuccessNotification" object:self userInfo:nil];
//
//
//        // optional and not necessary! just send a dummy mesage
////        if ([self CheckServerConnectionStateForDataFlow:10])
////            [self SendChatMessage:@"hello room!"
////                    ChatMessageID:self.User.RoomID
////                           ToUser:[NSString Empty]
////                       WithGameID:@"0"
////                         ChatType:chatTypeAllWindows
////                      MessageType:chatMessageTypeAdminMessage
////                     AudienceType:chatAudienceTypeRoom];
//    }];
//}



- (void)SendGetDataByRoomID
{
    /*
     
     IcPacket kv = new IcPacket();
     
     kv.Set(IcPacket.ID, IcPacket.GetDataByRoomID);
     {
         Set(IcPacket.Version, Config.Version);
         Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     }
     kv.Set(Rqp.GetDataByRoomID.RoomID, selectedRoomId);
     kv.Set(Rqp.GetDataByRoomID.RefreshCache, refreshCache);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDGetDataByRoomID]];
        [packet PacketAddOrSetForKey:icPacketGetDataByRoomIDRoomID Value:self.User.RoomID];
        [packet PacketAddOrSetForKey:icPacketGetDataByRoomIDRefreshCache Value:[CommonTasks TrueLies]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"get data by room ID send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ServerGetDataByRoomIdRespones:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        
        
        // remove previous room data and game data if any
        if (self.User.Game)
        {
            for (int i = 0; i < [self.User.Game allKeys].count; i++)
                [(DataTable*)[self.User.Game objectForKey:[self.User.Game allKeys][i]] RemoveTable:YES];
            self.User.Game = nil;
        }
        
        NSLog(@"%dccccccccccc",[self.User.Game allKeys].count);
        if (self.User.RoomInfoAppData)
        {
            for (int i = 0; i < [self.User.RoomInfoAppData allKeys].count; i++)
                [(DataTable*)[self.User.RoomInfoAppData objectForKey:[self.User.RoomInfoAppData allKeys][i]] RemoveTable:YES];
            self.User.RoomInfoAppData = nil;
        }
        
        
        
        
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetDataByRoomIDResponseApData]];
        if ([xml isValidXml:nodeAppData])
            if ([xml load:nil])
                if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                {
                    self.User.RoomInfoAppData = xml.dataPktNewDataSetTable;
                    NSLog(@"ServerGetDataByRoomIdResponesCOUNT%d",self.User.RoomInfoAppData.count);
                    NSLog(@"ServerGetDataByRoomIdResponesCOUNT%d",[self.User.RoomInfoAppData allKeys].count);
                    [CommonTasks LogMessage:@"got AppData/RoomInfo" MessageFlagType:logMessageFlagTypeInfo];
                }
        
        // set user status as logged in and notify the UI about it!
        if (!self.User.isLogin)
            self.User.isLogin = YES;
        // SIGN UP CHECKING
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLoginSuccessNotification" object:self userInfo:nil];
        
        // optional and not necessary! just send a dummy mesage
//        if ([self CheckServerConnectionStateForDataFlow:10])
//            [self SendChatMessage:@"hello room!"
//                    ChatMessageID:self.User.RoomID
//                           ToUser:[NSString Empty]
//                       WithGameID:@"0"
//                         ChatType:chatTypeAllWindows
//                      MessageType:chatMessageTypeText
//                     AudienceType:chatAudienceTypeRoom];
        
    }];
}




- (void)SendGetGameDataByGameID
{
    // todo
    // sign out of current game if any!
    
    /*
     IcPacket kv = new IcPacket();
     Set(IcPacket.Version, Config.Version);
     Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     pkt.Set(IcPacket.ID, IcPacket.GetGameDataByGameID);
     pkt.Set(IcPacket.GameID, gameID);
     pkt.Set(Rqp.GetGameDataByGameID.GetGameRequestE, (int)getGameRequestE); // GetGameRequestE.Watch
     pkt.Set(Rqp.GetGameDataByGameID.IsPaused, isPaused); // false
     pkt.Set(Rqp.GetGameDataByGameID.UserID, Ap.CurrentUserID);
     pkt.Set(Rqp.GetGameDataByGameID.GamePlayerID, gamePlayerID); // 0
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
    */
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[NSNumber numberWithInt:icPacketPacketIDGetGameDataByGameID]];
        [packet PacketAddOrSetForKey:icPacketGetGameDataByGameIDGamePlayerID Value:@(0)]; // in watch games this should be kept 0
        [packet PacketAddOrSetForKey:icPacketGetGameDataByGameIDGetGameRequestE Value:[NSNumber numberWithInt:getGameRequestWatch]];
        [packet PacketAddOrSetForKey:icPacketGetGameDataByGameIDIsPaused Value:[CommonTasks Falsehood]];
        [packet PacketAddOrSetForKey:icPacketGetGameDataByGameIDUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamGameID Value:self.User.GameID];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[NSNumber numberWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"get game data by game ID send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ServerGetGameDataByGameIDResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        [CommonTasks LogMessage:[packet description] MessageFlagType:logMessageFlagTypeInfo];
       // self.User.Game = nil;
        // get current game id if any
        NSString *previousGameID = [NSString Empty];
        int previousGameResult = 0;
        int *GameResult = [[[self.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameResultID"] intValue];
        NSLog(@"RRRRRRRRRRRRRRR%d",GameResult);
        int previousGameMovesCount = 0;
        // remove previous game data if any
    if (self.User.Game && (self.User.Game.count == 2) && [self.User.Game objectForKey:@"Game"])
        {
            previousGameID = [[self.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameID"];
            previousGameResult = [[[self.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameResultID"] intValue];
            
            previousGameMovesCount = [[self.User.Game objectForKey:@"Moves"] NumberOfRowsInTable];
            
            for (int i = 0; i < [self.User.Game allKeys].count; i++)
            [(DataTable*)[self.User.Game objectForKey:[self.User.Game allKeys][i]] RemoveTable:YES];
            self.User.Game = nil;
        }
        
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetGameDataByGameIDResponseGameData]];
        if ([xml isValidXml:nodeNewDataSet])
            if ([xml load:nil])
                if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                {
                    self.User.Game = xml.dataPktNewDataSetTable;
                    DataTable *game = [self.User.Game objectForKey:@"Game"];
                    if (game)
                    {
                        NSData *gameXmlData = [[NSData alloc] initWithBase64EncodedString:[game FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameXML"] options:0];
                        NSString *gameXml = [[NSString alloc] initWithData:gameXmlData encoding:NSUTF8StringEncoding];
                        if (gameXml)
                        {
                            [game UpdateColumnValueForRowAtIndexInTable:0 ColumnName:@"GameXML" NewValue:gameXml];
                            
                            xml = [[XmlParser alloc] initWithXmlString:gameXml];
                            if ([xml isValidXml:nodeNewDataSet])
                                if ([xml load:nil])
                                    if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                                    {
                                        NSMutableDictionary *tempGameDataSet = [NSMutableDictionary dictionaryWithDictionary:self.User.Game];
                                        [tempGameDataSet setObject:[xml.dataPktNewDataSetTable objectForKey:@"M"] forKey:@"Moves"];
                                        self.User.Game = tempGameDataSet;
                                        
                                        @try
                                        {
                                            if (([previousGameID isEqualToString:[[tempGameDataSet objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameID"]])
                                                &&
                                                (previousGameResult == [[[tempGameDataSet objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameResultID"] intValue])
                                                &&
                                                (previousGameMovesCount == [[tempGameDataSet objectForKey:@"Moves"] NumberOfRowsInTable]))
                                            {
                                                //self.User.Game = nil;
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLaunchKibitzGame" object:self userInfo:nil];
                                                NSLog(@"RETURN");
                                                return;
                                            }
                                        }
                                        @catch (NSException *e)
                                        {
                                      
                                            NSLog(e.description);
                                            return;
                                        }
                                        
                                        
                                        [CommonTasks LogMessage:@"got game data" MessageFlagType:logMessageFlagTypeInfo];
                                        
                                         //post event to calling controller!
                                        if ([previousGameID isEqualToString:self.User.GameID])
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateKibitzGame" object:self userInfo:nil];
                                        else
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineLaunchKibitzGame" object:self userInfo:nil];
                                    }
                        }
                    }
                }
    }];
}

- (void) ServerUpdateGameReceived:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (self.User.Game)
        {
            Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
            NSString *gameXmlMobile = [packet PacketGetStringForKey:icPacketSysParamGameXmlMobile];
            NSData *gameXmlData = [[NSData alloc] initWithBase64EncodedString:gameXmlMobile options:0];
            NSString *gameXml = [[NSString alloc] initWithData:gameXmlData encoding:NSUTF8StringEncoding];
            [packet PacketRemoveForKey:icPacketSysParamGameXmlMobile];
            [packet PacketAddOrSetForKey:icPacketSysParamGameXml Value:gameXml];
            XmlParser *xml = [[XmlParser alloc] initWithXmlString:gameXml];
            if ([xml isValidXml:nodeDocumentElement])
            {
                [xml replaceXmlNodeElement:@"DocumentElement" WithNewNodeElement:@"NewDataSet"];
                if ([xml isValidXml:nodeNewDataSet])
                    if ([xml load:nil])
                    {
                        if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                        {
                            [packet PacketRemoveForKey:icPacketSysParamGameXmlMobile];
                            [packet PacketAddOrSetForKey:icPacketSysParamGameXml Value:[xml.dataPktNewDataSetTable objectForKey:@"M"]];
                            
                            NSDictionary *gameData = [packet PacketGetPacketCopy];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateGame" object:self userInfo:gameData];//[packet PacketGetPacketCopy]];
                        }
                        else
                            NSLog(@"");
                    }
            }
        }
    }];
}



- (void)ServerUpdateUserRow:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (self.User.RoomInfoAppData)
        {
            Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
            
            XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketSysParamUserRow]];
            if ([xml isValidXml:nodeNewDataSet])
                if ([xml load:nil])
                    if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                    {
                        DataTable *newUser = [xml.dataPktNewDataSetTable objectForKey:@"Users"];
                        if (![newUser FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"UserID"].isEmptyOrWhiteSpaces)
                        {
                            NSString *query = [NSString stringWithFormat:@"UserID='%@'", [newUser FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"UserID"]];
                            NSFetchRequest *request = [NSFetchRequest new];
                            [request setPredicate:[NSPredicate predicateWithFormat:query]];
                            [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:((DataTable*)[self.User.RoomInfoAppData objectForKey:@"Users"]).columnSerialNumberName ascending:YES]]];
                            NSArray *result = [[self.User.RoomInfoAppData objectForKey:@"Users"] FetchRowsAgainstQuery:request];
                            if (result && result.count == 0)
                            {
                                NSArray *columnsName = [[self.User.RoomInfoAppData objectForKey:@"Users"] GetColumnsName];
                                NSMutableArray *newUserRow = [[NSMutableArray alloc] init];
                                for (int i = 1; i < columnsName.count; i++)
                                    [newUserRow addObject: ([newUser DoesColumnExists:columnsName[i]]) ?
                                     [newUser FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:columnsName[i]] : [NSString Empty]];
                                [[self.User.RoomInfoAppData objectForKey:@"Users"] AddRowToTable:newUserRow];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateUserRow" object:self userInfo:nil];
                            }
                        }
                    }
        }
        
    }];
}

- (void)ServerRemoveUserRowReceived:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (self.User.RoomInfoAppData)
        {
            Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
            NSString *removeUserID = [packet PacketGetStringForKey:icPacketSysParamUserID];
            if (!removeUserID.isEmptyOrWhiteSpaces)
            {
                NSString *query = [NSString stringWithFormat:@"UserID='%@'", removeUserID];
                NSFetchRequest *request = [NSFetchRequest new];
                [request setPredicate:[NSPredicate predicateWithFormat:query]];
                [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:((DataTable*)[self.User.RoomInfoAppData objectForKey:@"Users"]).columnSerialNumberName ascending:YES]]];
                NSArray *result = [[self.User.RoomInfoAppData objectForKey:@"Users"] FetchRowsAgainstQuery:request];
                if (result && result.count > 0)
                {
                    int index = [(NSString*)[(NSManagedObject*)result[0] valueForKey:((DataTable*)[self.User.RoomInfoAppData objectForKey:@"Users"]).columnSerialNumberName]intValue];
                    [[self.User.RoomInfoAppData objectForKey:@"Users"] RemoveRowAtIndexFromTable:index];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateUserRow" object:self userInfo:nil];
                }
            }
        }
        
    }];
}

- (void)SendGetGamesByRoomID
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[NSNumber numberWithInt:icPacketPacketIDGetGamesByRoomID]];
        [packet PacketAddOrSetForKey:icPacketGetGamesByRoomID Value:self.User.RoomID];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[NSNumber numberWithInt:[self GetNextPacketSequenceNumber]]];
        NSLog(@"%@Packet",packet);
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"get games by room ID send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)SendCheckMateUserGameFinishedToServer:(NSNumber *)oppId
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[NSNumber numberWithInt:icPacketCheckMateResultToServer]];
        [packet PacketAddOrSetForKey:101 Value:self.User.UserID];
        [packet PacketAddOrSetForKey:102 Value:oppId];

        NSLog(@"%@Packet",packet);
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"CheckMate send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ServerGetGamesByRoomIDRespones:(NSNotification*)notificationSender
{

    NSLog(@"ServerGetGamesByRoomIDRespones");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        if (self.User.RoomInfoAppData)
        {
            Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
            XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketGetGamesByRoomIDResponseUserData]];
            if ([xml isValidXml:nodeNewDataSet])
                if ([xml load:nil])
                    if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
                    {
                        [(DataTable*)[self.User.RoomInfoAppData objectForKey:@"Games"] RemoveTable:YES];
                        [self.User.RoomInfoAppData setValue:[xml.dataPktNewDataSetTable objectForKey:@"Games"] forKey:@"Games"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateGamesList" object:self userInfo:nil];
                    }
        }
    }];
}


- (void)SendChatMessage:(NSString *)message ChatMessageID:(NSString*)chatID ToUser:(NSString *)receivingUserName WithGameID:(NSString *)recevingGameID ChatType:(int)chatType MessageType:(int)messageType AudienceType:(int)audienceType
{
    /*
        IcPacket pkt = new IcPacket();
        {
            Set(IcPacket.Version, Config.Version);
            Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
        }
        pkt.Set(IcPacket.ID, IcPacket.ChatMessage);
        pkt.Set(Rqp.ChatMessage.AudienceType, (int)audienceType);
        pkt.Set(Rqp.ChatMessage.MessageType, (int)messageType);
        pkt.Set(Rqp.ChatMessage.ChatType, (int)chatType);
        pkt.Set(Rqp.ChatMessage.ID, id); // ID could be RoomID, GameID or UserID or 0=To Braodcast to everyone server
        pkt.Set(Rqp.ChatMessage.Message, message);
        pkt.Set(Rqp.ChatMessage.GameID, gameID); // Specfic game to send a chat message to. Used if you want to send a particular user in a specfic game
        pkt.Set(Rqp.ChatMessage.ServerDateTime, DateTime.Now);
        pkt.Set(Rqp.ChatMessage.ToUserName, toUserName);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     
     " (To all) : "
     " (To selected room) : "
     " (To Admins) : "
     " (To " + username + ") : "
     */
    
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        
        NSString *messageToSend = [NSString Empty];
        
        switch (audienceType)
        {
            case chatAudienceTypeAdmins:
                messageToSend = [NSString stringWithFormat:@"%@ (To Admins) : %@", self.User.UserName, message];
                break;
                
            case chatAudienceTypeAll:
                messageToSend = [NSString stringWithFormat:@"%@ (To all) : %@", self.User.UserName, message];
                break;
                
            case chatAudienceTypeRoom:
                messageToSend = [NSString stringWithFormat:@"%@ (To selected room) : %@", self.User.UserName, message];
                break;
                
            case chatAudienceTypeIndividual:
                messageToSend = [NSString stringWithFormat:@"%@ (To %@) : %@", self.User.UserName, receivingUserName, message];
                break;
                
            default:
                messageToSend = [NSString stringWithFormat:@"%@ (To selected room) : %@", self.User.UserName, message];
                break;
        }
        
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDChatMessage]];
        [packet PacketAddOrSetForKey:icPacketChatMessageAudienceType Value:[[NSNumber alloc] initWithInt:audienceType]];
        [packet PacketAddOrSetForKey:icPacketChatMessageMessageType Value:[[NSNumber alloc] initWithInt:messageType]];
        [packet PacketAddOrSetForKey:icPacketChatMessageChatType Value:[[NSNumber alloc] initWithInt:chatType]];
        [packet PacketAddOrSetForKey:icPacketChatMessageID Value:chatID];
        [packet PacketAddOrSetForKey:icPacketChatMessageMessage Value:messageToSend];
        [packet PacketAddOrSetForKey:icPacketChatMessageGameID Value:recevingGameID];
        [packet PacketAddOrSetForKey:icPacketChatMessageServerDateTime Value:[CommonTasks FormatDateToStringForSending:self.User.ServerDateTime]]; // todo
        [packet PacketAddOrSetForKey:icPacketChatMessageToUserName Value:receivingUserName];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"chat message send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
    
//    // add to chats
//    if (!self.User.Chats)
//        self.User.Chats = [[NSMutableArray alloc] init];
//    if (self.User.Chats.count == self.User.ChatsLimit)
//        [self.User.Chats removeObject:self.User.Chats.firstObject];
//
//    [self.User.Chats addObject:message];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineChatNotification" object:self userInfo:nil];
}

- (void)ServerChatMessageReceived:(NSNotification*)notitficationSender;
{
    [CommonTasks DoAsyncTaskOnGlobalQueue:^{
        Packet *packet = [Packet initFromDictionary:[notitficationSender userInfo]];
        //[CommonTasks LogMessage:[packet PacketGetStringForKey:icPacketChatMessageMessage] MessageFlagType:logMessageFlagTypeInfo];
        
        NSString *message = [packet PacketGetStringForKey:icPacketChatMessageMessage];
        [CommonTasks LogMessage:message MessageFlagType:logMessageFlagTypeInfo];
        
        // add to chats
        if (!self.User.Chats)
            self.User.Chats = [[NSMutableArray alloc] init];
        if (self.User.Chats.count == self.User.ChatsLimit)
            [self.User.Chats removeObject:self.User.Chats.firstObject];
        
        [self.User.Chats addObject:message];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineChatNotification" object:self userInfo:nil];
    }];
}




- (void)SendServerPingClient:(Packet*)packet
{
    /*
     
     IcPacket pkt = new IcPacket();
     {
     Set(IcPacket.Version, Config.Version);
     Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     }
     
     pkt.Set(IcPacket.ID, IcPacket.PingClient);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
    
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        Packet *packetToSend = packet;
        // since server send the same packet so we dont need to recreate the packet, just send back what was recieved
        [packetToSend PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packetToSend description] needToCompress:YES];
            [CommonTasks LogMessage:@"server ping client reply send" MessageFlagType:logMessageFlagTypeSystem];
        }
    }];
}

- (void)ServerPingClientResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
            [self SendServerPingClient:packet];
    }];
}

- (void)SendClientPingServer
{
    /*
     
     IcPacket pkt = new IcPacket();
     {
     Set(IcPacket.Version, Config.Version);
     Set(IcPacket.CurrentUserID, Ap.CurrentUserID);
     }
     pkt.Set(IcPacket.ID, IcPacket.PingServer);
     pkt.Set(Rqp.PingServer.RequestTime, DateTime.Now);
     pkt.Set(Rqp.PingServer.ShowMessage, showMessage);
     pkt.Set(IcPacket.ConsumerID, consumerID);
     pkt.Set(IcPacket.SequenceNo, GetNextSequenceNo());
     
     */
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
    
        Packet *packet = [[Packet alloc] init];
        [packet PacketAddOrSetForKey:icPacketSysParamVersion Value:[CommonTasks iOS]];
        [packet PacketAddOrSetForKey:icPacketSysParamCurrentUserID Value:self.User.UserID];
        [packet PacketAddOrSetForKey:icPacketSysParamPacketID Value:[[NSNumber alloc] initWithInt:icPacketPacketIDPingServer]];
        [packet PacketAddOrSetForKey:icPacketPingServerRequestTime Value:[CommonTasks FormatDateToStringForSending:[NSDate date]]];
        [packet PacketAddOrSetForKey:icPacketPingServerShowMessage Value:[CommonTasks Falsehood]];
        [packet PacketAddOrSetForKey:icPacketSysParamConsumerID Value:[[NSNumber alloc] initWithInt:0]];
        [packet PacketAddOrSetForKey:icPacketSysParamSequenceNo Value:[[NSNumber alloc] initWithInt:[self GetNextPacketSequenceNumber]]];
        
        if ([self CheckServerConnectionStateForDataFlow:self.socketPollTime])
        {
            [self.socketSession SendString:[packet description] needToCompress:YES];
            [CommonTasks LogMessage:@"client ping server packet send" MessageFlagType:logMessageFlagTypeSystem];
        }
        
    }];
}

- (void)ClientPingServerResponse:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        self.User.ServerDateTime = [CommonTasks FormatServerDateTime:[packet PacketGetStringForKey:icPacketPingServerResponseServerTime]];
    }];
}
-(void)createGameChalengeNotMatchedNotification:(NSNotification*)notificationSender{
    
    NSLog(@"Craet Game nOTIFICATIONP");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
            Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        
            XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:icPacketCreateGameChalengeResponseNotMatch]];
        NSString *packetValue = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:201]];
        NSDictionary *createChalengeDict = @{ @"key"     : packetValue
                                              };
         [[NSNotificationCenter defaultCenter] postNotificationName:@"createGameChalengeWaitNotMatched" object:self userInfo:createChalengeDict];
        NSLog(@"Packet = %@  XML = %@",packetValue,xml);
        
         NSLog(@"dayaset  = %@",xml.xmlString);
        
//            if ([xml isValidXml:nodeNewDataSet])
//                if ([xml load:nil])
//                    if (xml.dataPktNewDataSet != nil && xml.dataPktNewDataSet.count > 0)
//                    {
//                    NSLog(@"dayaset  = %@",xml.dataPktNewDataSet);
                        //int value2;
                       // [value2 setValue:[xml.dataPktNewDataSetTable objectForKey:@"Games"] forKey:@"Games"];
        
                     //   [(DataTable*)[self.User.RoomInfoAppData objectForKey:@"Games"] RemoveTable:YES];
                      //  [self.User.RoomInfoAppData setValue:[xml.dataPktNewDataSetTable objectForKey:@"Games"] forKey:@"Games"];
        
                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOnlineUpdateGamesList" object:self userInfo:nil];
                 //   }
    }];
}

-(void)createGameChalengeMatchedNotification:(NSNotification*)notificationSender{
    
    NSLog(@"Craet Game nOTIFICATIONP");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        XmlParser *xml = [[XmlParser alloc] initWithXmlString:[packet PacketGetStringForKey:107]];
        NSMutableDictionary *datamy = [xml xmlToDict];
        NSLog(@"%@",datamy);
        NSLog(@"");
        
        NSString *fen =   [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"Fen"]objectForKey:@"text"]];
        NSString *chalengeId = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"ChallengeID"]objectForKey:@"text"]];
        NSString *currentUserId = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"CurrentUser"]objectForKey:@"text"]];
        NSString *opponentId = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"Opponent"]objectForKey:@"text"]];
        NSString *isPlayerWhite = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"isPlayerWhite"]objectForKey:@"text"]];
        NSString *whitePlayerName = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"Wname"]objectForKey:@"text"]];
        NSString *blackPlayerName = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"Bname"]objectForKey:@"text"]];
        //int isPlayerWhiteInt = [self simplifyStringForUse:[[[[datamy objectForKey:@"DocumentElement"] objectForKey:@"Game"]objectForKey:@"FirstTurnWhite"]objectForKey:@"text"]];
        //[[MyManager sharedManager]setIsPlayerWhite:isPlayerWhiteInt];
        NSDictionary *playerOnlineChalengeData = @{ @"Fen" : fen,
                                                    @"ChalengeID":chalengeId,
                                                    @"CurrentUser":currentUserId,
                                                    @"Opponent":opponentId,
                                                    @"isPlayerWhite":isPlayerWhite,
                                                    @"whiteName":whitePlayerName,
                                                    @"blackName":blackPlayerName
                                                    };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createGameChalengeWaitMatched" object:self userInfo:playerOnlineChalengeData];
        //NSLog(@"%@", fen2);
        NSLog(@"");
        
    }];
}

-(void)getCurrentGameResponseUpdate:(NSNotification*)notificationSender{
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        NSLog(@"%@",packet);
        NSNumber *currentUser = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:2]];
        NSNumber *user = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:201]];
       // if (currentUser == ) {
         //   return ;
       // }
       // NSString *packetValue = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:201]];
        NSDictionary *currenMoveDataUpdate = @{ @"from" : [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:202]],
                                                    @"to":[packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:203]],
                                                @"fen":[packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:204]],
                                                @"userId":user,
                                                @"PGN":[packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:205]],
                                                @"WT":[packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:207]],
                                                @"BT":[packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:208]]
                                                    };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCurrentGameResponseUpdate" object:self userInfo:currenMoveDataUpdate];
     }];
    
    
}


-(NSString*)simplifyStringForUse:(NSString*)string{
    NSString *stringWithoutNewLine = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *simplifyString = [stringWithoutNewLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return  simplifyString;
}

-(void)destruct {
    [self.socketSession TearDown: YES];
    self.socketSession = nil;
    
    [self.User DeinitUserSession];
    self.User = nil;
}

@end

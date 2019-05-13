//
//  UserSession.h
//  AppOnline
//
//  Created by user on 2/18/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataTable.h"

enum UserStatusE
{
    userStatusUnknown = 0,
    userStatusBlank = 1,
    userStatusPlaying = 2,
    userStatusCentaur = 3,
    userStatusGone = 4,
    userStatusKibitzer = 5,
    userStatusEngine = 6,
    userStatusBan = 7,
};

enum LoginStatusE
{
    loginStatusUnknown = 0,
    loginStatusActive = 1,
    loginStatusDisabled = 2,
    loginStatusInactive = 3,
    loginStatusDeleted = 4,
    loginStatusWrongUserNamePassowrd = 5,
    loginStatusNoRoles = 6,
    loginStatusNoGuestForMachineCode = 7,
    loginStatusBannedForever = 8,
    loginStatusBannedForTimePeriod = 9,
};

enum GetGameRequestE
{
    getGameRequestNone = 0,
    getGameRequestReconnect = 1,
    getGameRequestWatch = 2,
    getGameRequestEndExamineMode = 3,
};

enum GameResultE
{
    gameResultNone = 0,
    gameResultInProgress = 1,
    gameResultWhiteWin = 2,
    gameResultWhiteLose = 3,
    gameResultDraw = 4,
    gameResultAbsent = 5,
    gameResultNoResult = 6,
    gameResultWhiteBye = 7,
    gameResultBlackBye = 8,
    gameResultForcedWhiteWin = 9,
    gameResultForcedWhiteLose = 10,
    gameResultForcedDraw = 11,
    gameResultByeForfeit = 12,
};

enum UserRankID
{
    userRankNone = 0,
    userRankPawn = 1,
    userRankKnight = 2,
    userRankBishop = 3,
    userRankRook = 4,
    userRankQueen = 5,
    userRankKing = 6,
    userRankGuest = 7,
};


// @description this class will hold information related to user online presence, dont confuse this with .Net UserSession.cs class!
@interface UserSession : NSObject

/// @description this will retrieves the UserID from UserData datatable
@property (strong, readonly) NSNumber *UserID;
/// @description this corresponds to the user name used for loggin process
@property (strong) NSString *UserName;
/// @description this corresponds to the unencrypted user password used for login process
@property (strong) NSString *UserPassword;
/// @description this corresponds to the encrypted user password used for login process
@property (strong) NSString *UserPasswordEncrypted;
/// @description this corresponds to the user RoomID in the UserData
@property (strong) NSString *RoomID;


/// @description a check, which is set when the user has been successfully logged in and have the complete rooms datatable
@property BOOL isLogin;

/// @description this will contains the current user image if any else is null
@property (strong) UIImage *UserImage;
/// @description this will contains the curren user info
/// included columns are: <UserID> <UserName> <Password> <Email> <FirstName> <LastName> <RoomID> <UserStatusID> <HumanRankID> <EngineRankID> <CentaurRankID> <CorrespondenceRankID> <CountryID> <NearestCityID> <DateLastLogin> <GenderID> <DateOfBirth> <EngineID> <PersonalNotes> <PasswordHint> <Url> <FideTitleID> <IccfTitleID> <SocialID> <StatusID> <CreatedBy> <DateCreated> <ModifiedBy> <DateModified> <Internet> <Applause> <Rank> <Country> <NearestCity> <FIDETitle /> <ICCFTitle /> <UserImage>
@property (strong) DataTable *UserInfo;
/// @description this will contain the current user datatable, when a user logins
@property (strong) DataTable *UserData;
/// @description this will contain all the rooms available on server
@property (strong) DataTable *Rooms;
@property (strong) DataTable *country;

/// @description this is the server side key values table
@property (strong) DataTable *ServerKeyValues;


/// @description this will contain the following tables
///
/// "Users"
/// "Games"
/// "LoggedinUsers"
/// "Description"
@property (strong) NSDictionary *RoomInfoAppData;
@property (strong) NSDictionary *UserInfoData;
/// @description this will contain the game that has been called
///
/// NOTE: make sure this is disposed at the time of closing the game
///
/// "Game"
/// "Moves"
@property (strong) NSDictionary *Game;
/// @description this will contain the current game ID if any, else this should be set to nil
@property (strong) NSString *GameID;

/// @description this contains the chat messages
@property (strong) NSMutableArray *Chats;
/// @description the number of messages that chats list can hold
@property (readonly) int ChatsLimit;

/// @description engine name
@property (strong) NSString *EngineName;

/// @description the server datetime
@property (strong) NSDate *ServerDateTime;
/// @description the ban start datetime
@property (strong) NSDate *BanStartDateTime;
/// @description the ban end datetime
@property (strong) NSDate *BanEndDateTime;

/// @description this is the UserStatus as in UserData datatable
@property enum UserStatusE UserStatus;
/// @description this is the LoginStatus as in the UserData datatable
@property enum LoginStatusE LoginStatus;

/// @description this returns the user device ip address
@property (weak, readonly) NSString *UserIP;
/// @description this returns the app unique identifier for the user device
@property (weak, readonly) NSString *UserMachineCode;
/// @description this returns the user device info
@property (weak, readonly) NSString *UserSystemInfo;

/// @description this sets the username and the password
/// @param username the user login name
/// @param password the user login password
- (void)SetUsername:(NSString*)username andPassword:(NSString*)password;

/// @description this initialize a user session for online activity
/// @param userName the user login name
/// @param password the user login password
- (id)initWithUserName:(NSString*)userName andPassword:(NSString*)password;
/// @description this deinitialize the user session
- (BOOL)DeinitUserSession;

@end

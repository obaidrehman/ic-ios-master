//
//  Packet.h
//  AppOnline
//
//  Created by user on 2/16/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>

/// @description this contains the packets numbers for SysParam, this is w.r.t. IcPacket.SysParam.cs file from .Net client/server. yo be careful where you are adding whatever, keep all cross-platform code sync!
enum IcPacketsSysParam
{
    icPacketSysParamNoSysParam = 0,
    icPacketSysParamVersion = 1,
    icPacketSysParamCurrentUserID = 2,
    icPacketSysParamPacketID = 3,
    icPacketSysParamSequenceNo = 4,
    icPacketSysParamGameID = 5,
    icPacketSysParamGameXml = 6,
    icPacketSysParamGameResult = 7,
    icPacketSysParamConsumerID = 12,
    icPacketSysParamUserRow = 13,
    icPacketSysParamUserID = 14,
    icPacketSysParamServerUTC = 18,
    icPacketSysParamGameXmlMobile = 27,
};

/// @description this contains the packets numbers for PacketsID, this is w.r.t. IcPacket.PacketID.cs file from .Net client/server. yo be careful where you are adding whatever, keep all cross-platform code sync!
enum IcPacketsPacketID
{
    icPacketPacketIDNoPacketID = 0,
    icPacketPacketIDGetUserInfoByUserID = 8,
    icPacketPacketIDLoginUser = 16,
     icPacketPacketIDSignUpUser = 425,
    icPacketPacketIDLogoffUser = 17,
    icPacketPacketIDGetAllRooms = 19,
    icPacketPacketIDUpdateUserStatusResponse = 21,
    icPacketPacketIDGetDataByRoomID = 23,
    icPacketPacketIDGetGameDataByGameIDResponse = 25,
    icPacketPacketIDGetGameDataByGameID = 29,
    icPacketPacketIDUpdateGame = 31,
    icPacketPacketIDChangeRoom = 32,
    icPacketPacketIDPingServer = 50,
    icPacketPacketIDChatMessage = 55,
    icPacketPacketIDUpdateUserStatus = 62,
    icPacketPacketIDPingClient = 83,
    icPacketPacketIDLoginUserResponse = 158,
     icPacketPacketIDSignUpUserResponse = 426,
    icPacketPacketIDPingServerResponse = 167,
    icPacketPacketIDGetUserInfoByUserIDResponse = 184,
    icPacketPacketIDValidateVersionResponse = 197,
    icPacketPacketIDGetDataByRoomIDResponse = 221,
    icPacketPacketIDGetAllRoomsResponse = 222,
    icPacketPacketIDChangeRoomResponse = 219,
    icPacketPacketIDUpdateUserRowResponse = 284,
    icPacketPacketIDRemoveUserRowResponse = 285,
    icPacketPacketIDGetAllKeyValues = 343,
    icPacketPacketIDGetAllKeyValuesResponse = 344,
    icPacketPacketIDGetGamesByRoomID = 395,
    icPacketPacketIDGetGamesByRoomIDResponse = 396,
};


/// @description this contains the numbers for user login packet
enum LoginUser
{
    icPacketLoginUserUserName = 101,
    icPacketLoginUserPassword = 102,
    icPacketLoginUserMachineCode = 103,
    icPacketLoginUserIp = 104,
    icPacketLoginUserSysInfo = 105,
    icPacketCheckAppVersion = 429
};

/// @description this contains the numbers for user log off
enum LogoffUser
{
    icPacketLogoffUserUserID = 101,
};

/// @description this contains the numbers for user login response packet
enum LoginUserResponse
{
    icPacketLoginUserResponseLoginStatusID = 201,
    icPacketLoginUserResponseBanStartDateTime = 202,
    icPacketLoginUserResponseBanEndDateTime = 203,
    icPacketLoginUserResponseUserData = 204,
    icPacketLoginUserResponseRolesData = 205,
    icPacketLoginUserResponsePunishUser = 206,
    icPacketLoginUserResponseKeyValuesData = 207,
    icPacketLoginUserResponseUserFormulaData = 208,
    icPacketLoginUserResponseUserBlockedListData = 209,
    icPacketLoginUserResponseServerDateTime = 210,
};

enum playOnlineGamePlayerToPlayer{
     icPacketSendCurrentMoveToServer = 416,
    icPacketSendCurrentMoveToServerResponse = 417,
    icPacketCurrentMoveRecieved = 418,
    icPacketCancelOnlineGameChalenge = 419,
    icPacketAppTerminateCloseGame = 420,
    icPacketAppResignGame = 431,
    icPacketAppResignGameResponse = 432,
    icPacketMessageToOtherPlayer = 437,
    icPacketMessageToOtherPlayerResponse = 438,
    icPacketGameAbbort = 442,
    icPacketGameAbbortResponse = 443,
    icPacketCheckMateResultToServer = 448,
};

enum CreateGamePacketStatus{
    icPacketCreateGame = 414,
    icPacketCreateGameChalengeResponseNotMatch = 415,
    icPacketCreateGameChalengeResponseMatch = 28,
    icPacketCreateGameChalengeReMatch = 447
};
/// @description this contains the numbers for update user status packet
enum UpdateUserStatus
{
    icPacketUpdateUserStatusUserStatusID = 101,
    icPacketUpdateUserStatusMachineCode = 102,
    icPacketUpdateUserStatusRoomID = 103,
    icPacketUpdateUserStatusIsLogIn = 104,
    icPacketUpdateUserStatusEngineName = 105,
    icPacketUpdateUserStatusChessTypeID = 106,
    icPacketUpdateUserStatusIsIdle = 107,
    icPacketUpdateUserStatusIsPause = 108,
    icPacketUpdateUserProfile = 430,
};

/// @description this contains the numbers for update user status response packet
enum UpdateUserStatusResponse
{
    icPacketUpdateUserStatusResponseIsLogIn = 201,
    icPacketUpdateUserStatusResponseVersionAvailable = 202,
};

/// @description this contains the numbers for validate version response packect
enum ValidateVersionResponse
{
    icPacketValidateVersionResponseIsVersionBlocked = 201,
    icPacketValidateVersionResponseVersionAvailable = 202,
    icPacketValidateVersionResponseMinVersion = 203,
};

/// @description this contains the numbers for user info
enum GetUserInfo
{
    icPacketGetUserInfoUserID = 101,
};

/// @description this contains the numbers for the user info datatable
enum GetUserInfoResponse
{
    icPacketGetUserInfoResponseDatatable = 201,
};

/// @description this contain the numbers for get all key values response packet
enum GetAllKeyValuesResponse
{
    icPacketGetAllKeyValuesResponseDatatable = 201,
};

/// @description this contains the numbers for get all rooms response packet
enum GetAllRoomsResponse
{
    icPacketGetAllRoomsResponseDataTable = 201,
    icPacketGetAllRoomsResponseIsRefresh = 202,
};

enum GetDataByRoomID
{
    icPacketGetDataByRoomIDRoomID = 101,
    icPacketGetDataByRoomIDRefreshCache = 102,
};

enum GetDataByRoomIDResponse
{
    icPacketGetDataByRoomIDResponseApData = 201,
};

enum GetGameDataByGameID
{
    icPacketGetGameDataByGameIDGetGameRequestE = 101,
    icPacketGetGameDataByGameIDIsPaused = 102,
    icPacketGetGameDataByGameIDUserID = 103,
    icPacketGetGameDataByGameIDGamePlayerID = 104,
};

enum GetGameDataByGameIDResponse
{
    icPacketGetGameDataByGameIDResponseGetGameRequestE = 201,
    icPacketGetGameDataByGameIDResponseIsPaused = 202,
    icPacketGetGameDataByGameIDResponseGameData = 203,
    icPacketGetGameDataByGameIDResponseIsCorrespondenceLastMoveBack = 204,
    
};

enum GetGamesByRoomID
{
    icPacketGetGamesByRoomID = 101,
};
enum GetGamesByRoomIDResponse
{
    icPacketGetGamesByRoomIDResponseUserData = 201,
};

enum ChangeRoom
{
    icPacketChangeRoomRoomID = 101,
    icPacketChangeRoomUserStatus = 102,
    icPacketChangeRoomEngineID = 103,
    icPacketChangeRoomIsGuest = 104,
};

enum ChangeRoomResponse
{
    icPacketChangeRoomResponseRoomData = 201,
    icPacketChangeRoomResponseIsBlocked = 202,
    icPacketChangeRoomResponseISBanUserForTournament = 203,
};

enum PingServer
{
    icPacketPingServerRequestTime = 101,
    icPacketPingServerShowMessage = 102,
};

enum PingServerResponse
{
    icPacketPingServerResponseServerTime = 201,
    icPacketPingServerResponseRequestTime = 202,
    icPacketPingServerResponseShowMessage = 203,
    icPacketPingServerResponseConsumerID = 204,
};

/*
 chat related enums below
 _________________________________________________________
 */

enum ChatMessage
{
    icPacketChatMessageAudienceType = 101,
    icPacketChatMessageMessageType = 102,
    icPacketChatMessageChatType = 103,
    icPacketChatMessageID = 104,
    icPacketChatMessageMessage = 105,
    icPacketChatMessageGameID = 106,
    icPacketChatMessageServerDateTime = 107,
    icPacketChatMessageToUserName = 108,
};


enum SignUpEnum
{
    icPacketSignUpAlreadyWithTheAccount = 101
};

/// @description the type of chat happening!
enum ChatType
{
    chatTypeOnlineClient,
    chatTypeGameWindow,
    chatTypeAllWindows,
};

/// @description the type of messages going around!
enum ChatMessageType
{
    chatMessageTypeText,
    chatMessageTypeInfo,
    chatMessageTypeWarning,
    chatMessageTypeError,
    chatMessageTypeSuccess,
    chatMessageTypeFailed,
    chatMessageTypeInprogress,
    chatMessageTypePrivate,
    chatMessageTypeEnteredRoom,
    chatMessageTypeLeftRoom,
    chatMessageTypeTournametInvitation,
    chatMessageTypeAdminMessage,
    chatMessageTypeTournamentResult,
    chatMessageTypeTournamentMatchResult,
    chatMessageTypeConnect,
    chatMessageTypeDisconnect,
    chatMessageTypeSystemInfo,
    chatMessageTypeInternetLag,
    chatMessageTypeEngineMatchResult,
};

/// @description the type of audience you are expecting!
enum ChatAudienceType
{
    chatAudienceTypeIndividual,
    chatAudienceTypeRoom,
    chatAudienceTypeAll,
    chatAudienceTypeAdmins,
    chatAudienceTypeKibitzer,
    chatAudienceTypeKibitzerPlayer,
};







/// @description this is the equivalent to .Net client/server packet class, it acts like a dictionary, and can convert packet xml etc, use this while sending data to server!
@interface Packet : NSObject

/// @description returns an instance of packet initilize with the contents of another dictionary
/// @param dataPktkV this should be a dictionary in packet fromat i.e. KV (key - value) format as in .Net server/client
/// @returns an instance of packet... wow...
+ (Packet*)initFromDictionary:(NSDictionary*)dataPktKV;

/// @description load the content of a dictionary to the packet, make sure the dictionary used is in KV (key - value) format as in .Net server/client
/// @param dataPktPV the dictionary whose contents are to be used load the packet
- (void)LoadFromDictionary:(NSDictionary*)dataPktKV;

/// @description adds or sets a key-value pair for the packet
/// @param key this is the key for which insertion or modification is called
/// @param value this is the value for the key
- (void)PacketAddOrSetForKey:(int)key Value:(NSObject*)value;

/// @description removes a key value pair from the packet
/// @param the key which needs to be removed
- (void)PacketRemoveForKey:(int)key;

/// @description gets the value as an object for the key within the packet
/// @param key the key whose value is required
/// @returns the value as a NSObject, this can also return nil if the key was not found!
- (NSObject*)PacketGetObjectForKey:(int)key;

/// @description gets the value as a string for the key within the packet
/// @param key the key whose value is required
/// @returns the value as a NSString, this can also return nil if the key was not found!
- (NSString*)PacketGetStringForKey:(int)key;

/// @description gets the value as an integer for the key within the packet
/// @param key the key whose value is required
/// @returns the value as an Integer, this can also return nil if the key was not found!
- (int)PacketGetIntegerForKey:(int)key;

/// @description gets the value as a number for the key within the packet
/// @param key the key whose value is required
/// @returns the value as a NSNumber, this can also return nil if the key was not found!
- (NSNumber*)PacketGetNumberForKey:(int)key;


/// @description clean the packet's soul ;P
- (void)PacketClearAllContents;

/// @description this returns a copy of packet
/// @returns the contents are returned as NSDictionary, if xml is needed then call the [self description] (the override for description method returns xml string)
- (NSDictionary*)PacketGetPacketCopy;



@end

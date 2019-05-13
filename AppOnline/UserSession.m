//
//  UserSession.m
//  AppOnline
//
//  Created by user on 2/18/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "UserSession.h"
#import "CommonTasks.h"

@implementation UserSession

- (NSString *)UserIP
{
    return [CommonTasks GetIPAddress:YES];
}

- (NSString *)UserMachineCode
{
    return [CommonTasks MachineCode];
}

- (NSString *)UserSystemInfo
{
    return [CommonTasks SystemInfo];
}

- (int)ChatsLimit
{
    // max 30 chats to display
    return 30;
}

- (NSNumber *)UserID
{
    if (self.UserData)
        return [NSNumber numberWithInt:[[self.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"UserID"] intValue]];
    return @(0);
}

- (NSString *)RoomID
{
    if (self.UserData)
        return [self.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"RoomID"];
    return @"0";
}

- (void)setRoomID:(NSString *)RoomID
{
    if (self.UserData)
        [self.UserData UpdateColumnValueForRowAtIndexInTable:0 ColumnName:@"RoomID" NewValue:RoomID];
}

- (void)SetUsername:(NSString *)username andPassword:(NSString *)password
{
    self.UserName = username;
    self.UserPassword = password;
    
    // encode pass as in .Net client/server
    self.UserPasswordEncrypted = [[CommonTasks DoCipher:[password dataUsingEncoding:NSUTF8StringEncoding] ToEncrypt:YES] base64EncodedStringWithOptions:0];}


- (id)initWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    self = [super init];
    if (self)
    {
        [self SetUsername:userName andPassword:password];
    }
    return self;
}

- (BOOL)DeinitUserSession
{
    if (self.UserData)
    {
        [self.UserData RemoveTable:YES];
        self.UserData = nil;
    }
    if (self.Rooms)
    {
        [self.Rooms RemoveTable:YES];
        self.Rooms = nil;
    }
    if (self.RoomInfoAppData && self.RoomInfoAppData.count > 0)
    {
        for (NSString *tableName in self.RoomInfoAppData)
            [[self.RoomInfoAppData objectForKey:tableName] RemoveTable:YES];
        self.RoomInfoAppData = nil;
    }
    
    return YES;
}

@end

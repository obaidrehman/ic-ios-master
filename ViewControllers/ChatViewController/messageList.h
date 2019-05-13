//
//  messageList.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/7/18.
//

#import <Foundation/Foundation.h>

@interface messageList : NSObject
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSNumber* recieverId;
@property (nonatomic, strong) NSNumber* messageId;
@property BOOL isSender;
@end

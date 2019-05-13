//
//  nView.h
//  Infinity Chess iOS
//
//  Created by user on 5/30/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOptions.h"

@interface nView : UIView

@property (strong) NSString* tagString;
@property (strong) NSObject* extraInfo;

/// @description set a small view with a textfield and sendbutton
- (id)initAsPrivateChatViewWithFrame:(CGRect)frame TextField:(nTextField*)textField andSendButton:(nButton *)sendButton;


@end

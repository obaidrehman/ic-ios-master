//
//  ChatScreenViewController.h
//  Infinity Chess iOS
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "AppOptions.h"

@interface ChatScreenViewController : UIViewController <UITextFieldDelegate, RNRippleTableViewDataSource, RNRippleTableViewDelegate>

@property (strong) volatile AppOnline *appOnline;
@property CGRect viewFrame;

@end

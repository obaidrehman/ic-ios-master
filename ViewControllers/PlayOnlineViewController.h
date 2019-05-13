//
//  PlayOnlineViewController.h
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "SplashScreen.h"

@interface PlayOnlineViewController : UIViewController <UITextFieldDelegate>

@property (strong) volatile AppOnline* appOnline;

@end

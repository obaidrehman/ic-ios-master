//
// PlayOnlineMainScreenViewController.h
// Infinity Chess iOS
//
// Created by user on 3/19/15.
// Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "SplashScreen.h"
#import "AppOptions.h"

@interface PlayOnlineMainScreenViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong) volatile AppOnline *appOnline;
- (void)setGameScreenController;
@end

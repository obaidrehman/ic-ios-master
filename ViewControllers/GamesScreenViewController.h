//
//  GamesScreenViewController.h
//  Infinity Chess iOS
//
//  Created by user on 5/13/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "SplashScreen.h"

@interface GamesScreenViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property CGRect viewFrame;
@property (strong) volatile AppOnline *appOnline;
@property UIView *gameView;

- (void)RequestNewGamesList;
- (void)ResetGamesList;

@end

//
//  RoomsScreenViewController.h
//  Infinity Chess iOS
//
//  Created by user on 3/21/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "SplashScreen.h"

@interface RoomsScreenViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property CGRect viewFrame;
@property (strong) volatile AppOnline *appOnline;
- (void)setRoomData;
@end

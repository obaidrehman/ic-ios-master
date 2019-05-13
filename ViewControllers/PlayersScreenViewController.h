//
//  PlayersScreenViewController.h
//  Infinity Chess iOS
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "AppOptions.h"

@interface PlayersScreenViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) volatile AppOnline *appOnline;
@property CGRect viewFrame;

/// @description reloads all room users
- (void)ResetRoomUsers;

@end

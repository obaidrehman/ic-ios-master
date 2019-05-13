//
//  NewGameTypeViewController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 4/9/18.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "BaseController.h"
@interface NewGameTypeViewController : BaseController<UITableViewDataSource, UITableViewDelegate>
@property (strong) volatile AppOnline *appOnline;
@end

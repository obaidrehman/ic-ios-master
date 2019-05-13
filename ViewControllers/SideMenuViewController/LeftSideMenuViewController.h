//
//  LeftSideMenuViewController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/11/18.
//

#import <UIKit/UIKit.h>
@class LeftSideMenuViewController;

@interface LeftSideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

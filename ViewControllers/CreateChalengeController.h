//
//  CreateChalengeController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 5/2/18.
//

#import <UIKit/UIKit.h>
#import "CreateChalengeTimeCell.h"
#import "AppOnline.h"
#import "ADTransitioningViewController.h"
#import "GamePlayScreenViewController.h"
@interface CreateChalengeController : UIViewController <UITableViewDataSource,UITableViewDelegate,stopChalengeTimer,CreateChalengeTimeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) volatile AppOnline *appOnline;
@property (weak, nonatomic) IBOutlet UIWebView *webViewGif;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGif;
@property (weak, nonatomic) IBOutlet UIView *gifView;

@end

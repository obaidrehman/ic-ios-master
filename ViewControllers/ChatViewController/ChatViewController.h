//
//  ChatViewController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/5/18.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtFieldStackBtmConstraint;
@property (strong) volatile AppOnline *appOnline;
@property (strong) volatile NSNumber *oppId;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (strong) volatile  NSMutableArray *arrCellMessage;
@end

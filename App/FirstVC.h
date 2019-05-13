//
//  FirstVC.h
//  InfinityChess2018
//
//  Created by Shehzar on 1/30/18.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "MyManager.h"
#import "BaseController.h"
@interface FirstVC : BaseController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOrProfile;
@property (strong)  AppOnline* appOnline;
@property (strong)  AppOnline* againLogin2;
@property (weak, nonatomic) IBOutlet UIView *versionChkView;
@property (weak, nonatomic) IBOutlet UIImageView *splashImageView;
@property (weak, nonatomic) IBOutlet UIView *splashView;
-(void)pushColorVC;
-(void)checkForLogin;
@end

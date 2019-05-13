//
//  ProfileViewController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/27/18.
//

#import <UIKit/UIKit.h>
#import "CountryListController.h"
#import "AppOnline.h"
@interface ProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,countrySelectedDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewControllerTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (strong)  AppOnline* appOnline;

@end

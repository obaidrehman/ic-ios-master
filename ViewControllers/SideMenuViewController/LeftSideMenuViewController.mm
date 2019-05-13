 //
//  LeftSideMenuViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/11/18.
//

#import "LeftSideMenuViewController.h"
#import "LeftSideViewCell.h"
#import "SideMenuViewController.h"
#import "MyManager.h"
#import "FirstVC.h"
#import "AppDelegate.h"
#import "SelectColorSchemeController.h"
#import "ThemeViewController.h"
@interface LeftSideMenuViewController ()
@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *titlesArray2;
@property (strong, nonatomic) NSArray *imgArray;
@end

@implementation LeftSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArray = @[@"Play",
                         @"Tactics",
                         @"Lessons",
                         @"Videos",
                         @"Computer",
                         @"Drills",
                         @"Vision",
                         @"Solo Chess",
                         @"Articles",
                         @"News",
                         @"Forums",
                         @"Friends",
                         @"Themes",
                         @"LogOut"];
    
    self.titlesArray2 = @[@"Play",
                         @"Tactics",
                         @"Lessons",
                         @"Videos",
                         @"Computer",
                         @"Drills",
                         @"Vision",
                         @"Articles",
                         @"News",
                         @"Forums",
                         @"Friends",
                         @"Themes"];
    
    self.imgArray = @[[UIImage imageNamed:@"Play 01-1"],
                      [UIImage imageNamed:@"Tactics"],
                      [UIImage imageNamed:@"lessons-1"],
                      [UIImage imageNamed:@"videos-1"],
                      [UIImage imageNamed:@"computer-1"],
                      [UIImage imageNamed:@"drills-1"],
                      [UIImage imageNamed:@"vision-1"],
                      [UIImage imageNamed:@"Solo chess-1"],
                      [UIImage imageNamed:@"Articles-1"],
                      [UIImage imageNamed:@"News-1"],
                      [UIImage imageNamed:@"Forums-1"],
                      [UIImage imageNamed:@"Friends-1"],
                      [UIImage imageNamed:@"Theme-1"],
                      [UIImage imageNamed:@"logout"]];
    // Do any additional setup after loading the view.
}


//[[[MyManager sharedManager] sideMenuController] willShowLeftView];

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftSideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titlelbl.text = _titlesArray[indexPath.row];
    cell.imgTitle.image = _imgArray[indexPath.row];
    NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    if ((indexPath.row == 13 || indexPath.row == 12 ) && !([userData isEqualToString:@""] || userData == nil)) {
    [cell.titlelbl setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    }else{
    [cell.titlelbl setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    if ([userData isEqualToString:@""] || userData == nil){
        return;
    }
    if (indexPath.row == 12){
        NSString * storyboardName = @"Storyboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        SelectColorSchemeController *scsc = [[SelectColorSchemeController alloc]
                                             initWithParentViewController: nil];
        SideMenuViewController *sideMenuObj = (SideMenuViewController*)[[MyManager sharedManager] sideMenuController];
        [[[MyManager sharedManager] firVC] pushColorVC];
        //ThemeViewController * themeVC = [storyboard instantiateViewControllerWithIdentifier:@"ThemeViewController"];
        ///scsc.view.frame = themeVC.view.frame;
        //[themeVC. addSubview:scsc];
        //[self setVCTransition:kCATransitionReveal subType:kCATransitionFromBottom childVC:self duration:0.7];
        
        //[sideMenuObj setRootViewController:themeVC];
        [sideMenuObj hideLeftViewAnimated];
        
    }
    
    if (indexPath.row == 13){
        [self setAlert];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
        
    }
    [defs synchronize];
    
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(void)setAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout" message:@"Are you sure" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self resetDefaults];
        [_tableView reloadData];
        SideMenuViewController *sideMenuObj = (SideMenuViewController*)[[MyManager sharedManager] sideMenuController];
        [[self appDelegate] setIsLoginUser:false];
        [[[MyManager sharedManager] firVC] checkForLogin];
        [sideMenuObj hideLeftViewAnimated];
        ;
    }];
    
    // relate actions to controllers
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    //presentViewController(alertController, animated: true, completion: nil)
}
@end

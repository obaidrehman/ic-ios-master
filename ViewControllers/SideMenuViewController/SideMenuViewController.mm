//
//  SideMenuViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/11/18.
//

#import "SideMenuViewController.h"
#import "MyManager.h"
@interface SideMenuViewController (){
//    FirstVC *fvc;
}

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.65 blue:0.5 alpha:0.95];
    //self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    int width = [UIScreen mainScreen].bounds.size.width;
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    self.leftViewWidth = width * 0.6;
   // self.leftViewBackgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    //SideMenuViewController *mainViewController = [storyboard instantiateInitialViewController];
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"FirstVC"]]];
    self.rootViewController = navigationController;
    [self setLeftViewSwipeGestureEnabled:false];
    [[MyManager sharedManager] setSideMenuController:self];
    //self.leftViewSwipeGestureEnabled = NO;
   // [self setRightViewSwipeGestureDisabled:true];
    //[[MyManager sharedManager] set]
    // Do any additional setup after loading the view.
}



-(void)callRootsViewWillAppear{
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogOut" object:nil];
    //[self.rootViewController viewWillAppear:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//PlayOnlineMainScreenViewController.m
// Infinity Chess iOS
//
// Created by user on 3/19/15.
// Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "PlayOnlineMainScreenViewController.h"
#import "RoomsScreenViewController.h"
#import "RoomInfoScreenViewController.h"
#import "PlayersScreenViewController.h"
#import "ChatScreenViewController.h"
#import "GamesScreenViewController.h"
#import "GamePlayScreenViewController.h"
#import "JGProgressHUD.h"
#import "MyManager.h"
#import "NewGameTypeViewController.h"
#import "UIView+Toast.h"
enum ContentViewControllersReferenceIndexes
{
    contentRefRoomsScreenViewController = 0, // rooms ViewController
    contentRefRoomInfoScreenViewController = 1, // room info ViewController
    contentRefPlayersScreenViewController = 2, // players ViewController
    contentRefChatScreenViewController = 3, // chat ViewController
    contentRefGamesScreenViewController = 4, // games ViewController
    contentRefGamePlayScreenViewController = 5, // gameplay viewController
};


@interface PlayOnlineMainScreenViewController ()
@property (nonatomic,strong) NSArray * allItems;
@property (strong) NSString *serverTime;
@property (weak, nonatomic) IBOutlet UIView *RoomScreenContentView;
@property (weak, nonatomic) IBOutlet UIView *gameScreenContentView;
//@property (weak, nonatomic) IBOutlet UIView *newGameTypeScreenContentView;
@property (weak, nonatomic) IBOutlet UIView *gnewGameScreenContentView;
@end

@implementation PlayOnlineMainScreenViewController
{
    NSArray *contentViewControllers;
    GamesScreenViewController *gameScreenVC;
    GamePlayScreenViewController *gamePlayScreenVC;
    JGProgressHUD *HUD;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [self LoadPageViewController];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[MyManager sharedManager] showHUDWithTransform:@"Waiting for Server Response" forView:self.gameScreenContentView];
//    [self setNewGameTypeController];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBackButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:true];
}


//•mod•
//- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
//{
// if ([item.title isEqualToString:@"Logout"])
// {
// if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
// {
// [CommonTasks LogMessage:@"sending logout!" MessageFlagType:logMessageFlagTypeSystem];
//
// [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
// [self.appOnline SendLogOffUser];
// [self.appOnline DeinitAppOnline:self];
// self.appOnline = nil;
// }];
// }
// // tear down socket connection if any!
//
// [self dismissViewControllerAnimated:YES completion:nil];
// }
//}


/// @description this is to used to load the page view controller and all related contents
- (void)LoadPageViewController
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateServerTime:) name:@"UpdateServerTime" object:nil];
    [self.appOnline SubscribeToNotifications:self];
    
    [self LoadPlayOnlineMainScreenPageViewController:nil];
}


- (void)setGameScreenController
{
    
    gameScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GamesScreenViewController"];
    [self addChildViewController:gameScreenVC];
    gameScreenVC.appOnline = self.appOnline;
    gameScreenVC.gameView = self.gameScreenContentView;
    [self.gameScreenContentView addSubview:gameScreenVC.view];
    [gameScreenVC didMoveToParentViewController:self];
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Do some work");
         [self.view bringSubviewToFront:self.gameScreenContentView];
    });
   
    
}

- (void)setNewGameTypeController
{
    
    NewGameTypeViewController *newGameTypeVC;
    newGameTypeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGameTypeViewController"];
    [self addChildViewController:newGameTypeVC];
    [self.gnewGameScreenContentView addSubview:newGameTypeVC.view];
    [newGameTypeVC didMoveToParentViewController:self];
  //  newGameTypeVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view bringSubviewToFront:self.gnewGameScreenContentView];
    
}

- (void)setGamePlayScreenController
{
   
    gamePlayScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePlayScreenViewController"];
    gamePlayScreenVC.appOnline = self.appOnline;
    [self presentViewController:gamePlayScreenVC animated:YES completion:nil];
 //   [navVC pushViewController:gamePlayScreenVC animated:YES];
//    [self addChildViewController:gamePlayScreenVC];
//    gamePlayScreenVC.appOnline = self.appOnline;
//    [self.gamePlayScreenContentView addSubview:gamePlayScreenVC.view];
//    [gamePlayScreenVC didMoveToParentViewController:self];
//    [self.view bringSubviewToFront:self.gamePlayScreenContentView];
    
}


- (void)LoadPlayOnlineMainScreenPageViewController:(NSNumber*)pageIndex;
{
    RoomsScreenViewController *RoomsScreenVC;
    RoomsScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomsScreenViewController"];
    [self addChildViewController:RoomsScreenVC];
    RoomsScreenVC.appOnline = self.appOnline;
    [self.RoomScreenContentView addSubview:RoomsScreenVC.view];
    [RoomsScreenVC didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.RoomScreenContentView];
    [RoomsScreenVC setRoomData];
   // [self setGameScreenController];
    
    
    // load content view controllers
    // contentViewControllers = @[
    // [self.storyboard instantiateViewControllerWithIdentifier:@"RoomsScreenViewController"], // rooms ViewController
    // [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoScreenViewController"], // room info ViewController
    // [self.storyboard instantiateViewControllerWithIdentifier:@"PlayersScreenViewController"], // players ViewController
    // [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreenViewController"], // chat ViewController
    // [self.storyboard instantiateViewControllerWithIdentifier:@"GamesScreenViewController"], // games ViewController
    // [self.storyboard instantiateViewControllerWithIdentifier:@"GamePlayScreenViewController"], // gameplay ViewController
    // ];
    //
    // ((RoomsScreenViewController*)contentViewControllers[contentRefRoomsScreenViewController]).appOnline = self.appOnline;
    // ((RoomsScreenViewController*)contentViewControllers[contentRefRoomsScreenViewController]).viewFrame = pageFrame;
    //
    // ((RoomInfoScreenViewController*)contentViewControllers[contentRefRoomInfoScreenViewController]).appOnline = self.appOnline;
    // ((RoomInfoScreenViewController*)contentViewControllers[contentRefRoomInfoScreenViewController]).viewFrame = pageFrame;
    //
    // ((PlayersScreenViewController*)contentViewControllers[contentRefPlayersScreenViewController]).appOnline = self.appOnline;
    // ((PlayersScreenViewController*)contentViewControllers[contentRefPlayersScreenViewController]).viewFrame = pageFrame;
    //
    // ((ChatScreenViewController*)contentViewControllers[contentRefChatScreenViewController]).appOnline = self.appOnline;
    // ((ChatScreenViewController*)contentViewControllers[contentRefChatScreenViewController]).viewFrame = pageFrame;
    //
    // ((GamesScreenViewController*)contentViewControllers[contentRefGamesScreenViewController]).appOnline = self.appOnline;
    // ((GamesScreenViewController*)contentViewControllers[contentRefGamesScreenViewController]).viewFrame = pageFrame;
    //
    // ((GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController]).appOnline = self.appOnline;
    // ((GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController]).viewFrame = pageFrame;
    //
    //
    // [self addChildViewController:playOnlineMainScreenPageViewController]; // add page view controller as child view controller
    // playOnlineMainScreenPageViewController.view.frame = CGRectMake(0.0f, 0.0f, self.viewPage.frame.size.width, self.viewPage.frame.size.height); // set page view controller frame's bound
    // [playOnlineMainScreenPageViewController.view setAutoresizesSubviews:YES];
    // [playOnlineMainScreenPageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    //
    // [self.view setAutoresizesSubviews: YES];
    // [self.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    // [self.viewPage addSubview:playOnlineMainScreenPageViewController.view]; // add page view controller's view as subview
    // [playOnlineMainScreenPageViewController didMoveToParentViewController:self];
    // self.viewPage.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f]; // make this refrence view transparent
    //
}




// notofications ________________

- (void)UpdateServerTime:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        // using try catch, to avoid crash when the apponline get nil and at the same time this event is fired
        @try {
            NSDictionary *time = [notificationSender userInfo];
            self.serverTime = [NSString stringWithFormat:@"Server Time: %@", [time valueForKey:@"time"] ];
        }
        @catch (NSException *exception) {
            [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
        }
        
    }];
}

//- (void)AppOnlineLoggedInNotification:(NSNotification*)notificationSender
- (void)AppOnlineLoginSuccessNotification:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"AppOnline Logged In / Room Changed Notification....!" MessageFlagType:logMessageFlagTypeSystem];
    
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        NSLog(@"          ");
        [[MyManager sharedManager] removeHud];
        //[[SplashScreen SplashScreenInstance] Stop];
        [self setGameScreenController];
       // [[MyManager sharedManager] showHUDWithTransform:@"Loading..." forView:self.view];
       // [self LoadPlayOnlineMainScreenPageViewController:nil];
        
    }];
}


- (void)AppOnlineUserIsBanOrBlockedInRoom:(NSNotification*)notififcationSender
{
    [CommonTasks LogMessage:@"AppOnline Logged In / Room Changed Notification....!" MessageFlagType:logMessageFlagTypeSystem];
    
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        [[MyManager sharedManager] removeHud];
       // [[SplashScreen SplashScreenInstance] Stop];
        [self LoadPlayOnlineMainScreenPageViewController:nil];
        
        // RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"From Room" message:@"You are not allowed in this room"];
        // [alert show];
    }];
}

- (void)AppOnlineLaunchKibitzGame:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"game recieved for kibitzing....!" MessageFlagType:logMessageFlagTypeSystem];
    
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        //[[SplashScreen SplashScreenInstance] Stop];
        [[MyManager sharedManager] removeHud];
        // unload previous game if any
//        if ((GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController])
//            [(GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController] UnloadPreviousGame];
//
//        [self LoadPlayOnlineMainScreenPageViewController:nil];
       
        if (self.appOnline.theFlag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"inside dispatch async block main thread from main thread");
                self.appOnline.theFlag = false;
                        double delayInSeconds = 0.2;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [self setGamePlayScreenController];
                        });
                
                // [self.view bringSubviewToFront:self.gnewGameScreenContentView];
            });
        }
       
        
    }];
}

- (void)AppOnlineUpdateKibitzGame:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        //[[SplashScreen SplashScreenInstance] Stop];
        [[MyManager sharedManager] removeHud];
//        if ((GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController])
//            [(GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController] UpdateGame];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"inside dispatch async block main thread from main thread");
           [gamePlayScreenVC UpdateGame];
            
        });
        
        
    }];
}

- (void) AppOnlineUpdateGame:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
       // [[SplashScreen SplashScreenInstance] Stop];
        
//        if ((GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController])
//            [(GamePlayScreenViewController*)contentViewControllers[contentRefGamePlayScreenViewController] UpdateGameWithUpdateGamePacket:[notificationSender userInfo]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MyManager sharedManager] removeHud];
            NSLog(@"inside dispatch async block main thread from main thread");
           [gamePlayScreenVC UpdateGameWithUpdateGamePacket:[notificationSender userInfo]];
            
        });
        
    }];
}

- (void)AppOnlineUpdateUserRow:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        if ((PlayersScreenViewController*)contentViewControllers[contentRefPlayersScreenViewController])
            [(PlayersScreenViewController*)contentViewControllers[contentRefPlayersScreenViewController] ResetRoomUsers];
        
    }];
}

- (void)AppOnlineUpdateGamesList:(NSNotification*)notificationSender
{
    
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        [gameScreenVC ResetGamesList];
      //  if ((GamesScreenViewController*)contentViewControllers[contentRefGamesScreenViewController])
           // [(GamesScreenViewController*)contentViewControllers[contentRefGamesScreenViewController] ResetGamesList];
        
    }];
}

- (void)AppOnlineReset:(NSNotification*)notificationSender
{
    
   
    NSLog(@"AppOnlineReset •••");
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        //[[SplashScreen SplashScreenInstance] Stop];
       
    }];
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithDisplayP3Red:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    style.messageColor = [UIColor colorWithDisplayP3Red:40.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1];
     double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline SendLogOffUser];
            [self.appOnline DeinitAppOnline:self];
            self.appOnline = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[MyManager sharedManager] removeHud];
                [self.view makeToast:@"Server connection error."
                            duration:2.0
                            position:CSToastPositionCenter
                               style:style];
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"Do some work");
                    [[self navigationController] popToRootViewControllerAnimated:true];
                });
            });
           
        }];
    }
    else
    {
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline SendLogOffUser];
            [self.appOnline DeinitAppOnline:self];
            self.appOnline = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"Server connection error."
                            duration:2.0
                            position:CSToastPositionCenter
                               style:style];
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"Do some work");
                    [[self navigationController] popToRootViewControllerAnimated:true];
                });
            });
        }];
    }
    // tear down socket connection if any!
    
  //  [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)AppOnlineLoginFailureNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineLoginFailureNotification");
}

- (void)AppOnlineErrorNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineErrorNotification");
    [CommonTasks LogMessage:@"AppOnline Error Notification!...." MessageFlagType:logMessageFlagTypeSystem];
}

- (void)AppOnlineServerTimeNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineServerTimeNotification");
}








- (void)AppOnlineChatNotification:(NSNotification*)notificationSender
{
    // int index = (int)contentRefChatScreenViewController;
    // [pageControl.activeImage replaceObjectAtIndex:(index + index) withObject:[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom]];
    // [pageControl.inactiveImage replaceObjectAtIndex:(index + index) withObject:[[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha]];
    
    // [CommonTasks DoAsyncTaskOnMainQueue: ^{
    //
    // pageControl.activeImage = [NSMutableArray arrayWithArray:@[
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iRooms"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iRooms"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iInfo"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iInfo"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iUsers"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iUsers"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iList"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iList"] ByValue:pageControlZoom],
    // [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iGame"] ByValue:pageControlZoom],
    // ]];
    // pageControl.inactiveImage = [NSMutableArray arrayWithArray:@[
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iRooms"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iRooms"] ByValue:pageControlZoom] imageByApplyingAlpha:0],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iInfo"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iInfo"] ByValue:pageControlZoom] imageByApplyingAlpha:0],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iUsers"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iUsers"] ByValue:pageControlZoom] imageByApplyingAlpha:0],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iChats1"] ByValue:pageControlZoom] imageByApplyingAlpha:0],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iList"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iList"] ByValue:pageControlZoom] imageByApplyingAlpha:0],
    // [[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iGame"] ByValue:pageControlZoom] imageByApplyingAlpha:pageControlAlpha],
    // ]];
    //
    //
    //
    // [pageControl setCurrentPage:currentPageIndexRef * extraControls];
    // [self.view setNeedsDisplay];
    // [playOnlineMainScreenPageViewController.view setNeedsDisplay];
    // [pageControl setNeedsDisplay];
    //
    // }];
}

//- (void)showHUDWithTransform:(NSString *)message{
//    JGProgressHUD *innerHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
//    innerHUD.textLabel.text = message;//@"Loading...";
//    HUD = innerHUD;
//    [innerHUD showInView:self.gameScreenContentView];
//    //'[HUD dismissAfterDelay:3.0];
//}
//- (void)removeHud{
//    
//    [HUD dismissAfterDelay:3.0];
//}


@end

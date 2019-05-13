//
//  PlayOfflineViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "PlayOfflineViewController.h"
#import "AppOptions.h"
//#import "AppThemes.h"
#import "CommonTasks.h"
#import "AppDelegate.h"

@interface PlayOfflineViewController ()


@property (weak, nonatomic) IBOutlet UIView *viewStockfish;
@property (strong) AppDelegate *stockfish;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

@end



@implementation PlayOfflineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set background
//    [[AppOptions AppOptionsInstance].themes DefaultBackground:self.view];
//    [[AppOptions AppOptionsInstance].themes ThemeBackGround:self.view IsOptional:NO];

    
    
    // subscribe to application notifications
    [AppOptions SubscribeForApplicationNotifications:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    @try {
        //•mod•
//        self.stockfish = [[AppDelegateStockfish alloc] initAndLoadStockfishInView:self.viewStockfish ForOfflinePlay:YES AppOnlineReference:nil];
//        [self.stockfish SubscribeToStockfishPlayOfflineNotifications:self];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@", exception);
//    }
    
//    [self SetControlsAndThemes];
}

- (void)SetControlsAndThemes
{
    self.viewStockfish.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLight"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLight"]];
    [self.imageViewBackground setImage:[UIImage imageNamed:@"backgroundLight"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)StockfishPlayOfflineQuit:(NSNotification*)notificationSender
{
    //•mod•
    // dealloc stockfish before moving ahead!
//    if (self.stockfish)
//    {
//        [self.stockfish UnsubscribeToStockfishPlayOfflineNotifications:self];
//        [self.stockfish DeInitStockfish];
//        self.stockfish = nil;
//    }
    
    
    // just return to main menu
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// application notification events
- (void)ApplicationWillEnterForegroundNotification:(NSNotification*)notificationSender
{
    //•mod•
//    @try {
//        if (self.stockfish)
//            [self.stockfish.gameController checkPasteboard];
//    }
//    @catch (NSException *exception) {
//        [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
//    }
}


- (void)ApplicationDidEnterBackgroundNotification:(NSNotification*)notificationSender
{
    //•mod•
//    @try {
//        if (self.stockfish)
//            [self.stockfish saveState];
//    }
//    @catch (NSException *exception) {
//        [CommonTasks LogMessage:[exception description] MessageFlagType:logMessageFlagTypeError];
//    }
}

- (void)ApplicationWillResignActiveNotification:(NSNotification*)notificationSender
{
    
}

- (void)ApplicationWillTerminateNotification:(NSNotification*)notificationSender
{
    
}

@end

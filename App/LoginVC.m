//
//  LoginVC.m
//  InfinityChess2018
//
//  Created by Shehzar on 3/16/18.
//

#import "LoginVC.h"
#import "CommonTasks.h"
#import "TheAlerts.h"
#import "PlayOnlineMainScreenViewController.h"
#import "MyManager.h"
#import "NewGameTypeViewController.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "SignUpViewController.h"
//#import "BoardVCOffline.h"


@interface LoginVC (){
    NSDictionary *userData;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UISwitch *btnSwitch;


@property (strong, nonatomic) TheAlerts *theAlert;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.theAlert = [[TheAlerts alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(AppOnlineLoginSuccessNotification:)
                                                 name: @"AppOnlineLoginSuccessNotification"
                                               object: nil];
}

//-(void)fetchProfile{
//    NSDictionary *parameters = @{@"fields":@"email,first_name,last_name"};
//    FBSDKGraphRequest
//}
- (IBAction)actionLoginFB:(id)sender {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                           userData = @{@"email":result[@"email"],@"userName":result[@"name"]};
                          [self setConnection];
                          
                      }else{
                          
                          
                      }
                  }];
             }
         }];
    [login logOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)actionSignUpButton:(id)sender {
    
        NSString * storyboardName = @"Storyboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
         SignUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        //vc.appOnline = self.appOnline;
        [[self navigationController] pushViewController:vc animated:true];
    
}

- (IBAction)loginButtonAction:(id)sender {
   // [[MyManager sharedManager]showHUDWithTransform:@"loading..." forView:self.view];
    
    if (![self connected]) {
        [self.theAlert showOkAlert:self title:@"Internet Problem" message:@"Please connect to the WiFi"];
    } else {
        
        [self ConnectOnline];
    }
}


- (void)ConnectOnline
{
    // validate textFields
    if ((self.txtFieldUserName.text && self.txtFieldPassword.text) && (!self.txtFieldUserName.text.isEmptyOrWhiteSpaces && !self.txtFieldPassword.text.isEmptyOrWhiteSpaces))
    {
        [[MyManager sharedManager] showHUDWithTransform:@"Connecting to Server" forView:self.view];
        // now connect to server
        [self setConnection];
    }else{
        [self.theAlert showOkAlert:self title:@"" message:@"Username or Password can not be empty"];
    }
}

-(void)setConnection{
        self.appOnline = [[AppOnline alloc] initWithSocket:nil];
        [self.appOnline SubscribeToNotifications:self];
        
        // check if connected
        if (![self.appOnline CheckServerConnectionStateForDataFlow:100000])
        {
            // retry in case new server is available
            [self.appOnline.socketSession TearDown:NO];
        }
        // again check if connected
        if (![self.appOnline CheckServerConnectionStateForDataFlow:0])
        {
            [self.theAlert closeSplashAlert];
            [[MyManager sharedManager] removeHud];
            [self.theAlert showOkAlert:self title:@"Connection Error" message:@"Unable to connect to server now, try again later!"];
            
            [CommonTasks LogMessage:[NSString stringWithFormat:@"unalbe to establish socket connection to server %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeError];
            
            // tear down socket connection if any!
            self.appOnline = [self.appOnline DeinitAppOnline:self];
            
            // now just return
            return;
        }
        
        // if connected to server, send handshake
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            [CommonTasks LogMessage:@"sending handshake!" MessageFlagType:logMessageFlagTypeSystem];
            
            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                [self.appOnline.socketSession SendHandShakeRequest];
            }];
        }
        
        // now send login
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            [CommonTasks LogMessage:@"sending login!" MessageFlagType:logMessageFlagTypeSystem];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (userData){
                   // [login logOut];
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [self.appOnline SendSocialLoginUser:userData];
                    return ;
                }else{
                [self.appOnline SendLoginUser:self.txtFieldUserName.text.trim Password:self.txtFieldPassword.text.trim];
               
                }
                });
                        [CommonTasks DoAsyncTaskOnMainQueue:^{
                            [self.appOnline SendLoginUser:self.txtFieldUserName.text.trim Password:self.txtFieldPassword.text.trim];
                        }];
        }
    else
    {
        
        [self.theAlert closeSplashAlert];
        
        [self.theAlert showOkAlert:self title:@"Signin Error" message:@"User name and/or password cannot be empty"];
        [[MyManager sharedManager] removeHud];
        [CommonTasks LogMessage:[NSString stringWithFormat:@"User name and/or password cannot be empty! %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeWarning];
        
        // tear down socket connection if any!
        self.appOnline = [self.appOnline DeinitAppOnline:self];
        
        // now just return
        return;
    }
}

- (void)AppOnlineIsConnectingNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineIsConnectingNotification");
}

- (void)AppOnlineHasDisconnectingNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineHasDisconnectingNotification");
}

- (void)AppOnlineReset:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineReset <><><><><>");
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithDisplayP3Red:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    style.messageColor = [UIColor colorWithDisplayP3Red:40.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.theAlert closeSplashAlert];
        [self.view makeToast:@"Server connection error."
                    duration:2.0
                    position:CSToastPositionCenter
                       style:style];
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"Do some work");
           // [[self navigationController] popToRootViewControllerAnimated:true];
        });
      
    });

    //TOAST DIKHADE
  //  [self performSegueWithIdentifier:@"UWtoLoginSID" sender:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.txtFieldPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"];
        self.txtFieldUserName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    
}
- (IBAction)actionBackBtn:(id)sender {
    [[self navigationController] popViewControllerAnimated:true];
}

- (void)AppOnlineLoginSuccessNotification:(NSNotification*)notificationSender
{
    NSLog(@"LOGINVC œœœœœœœœœœœœœœœœœœœœœœ");
    
    [CommonTasks LogMessage:@"AppOnline Logged In Notification....!" MessageFlagType:logMessageFlagTypeSystem];
    
    // login successful, now move ahead to online game
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"inside dispatch async block main thread from main thread");
        [[MyManager sharedManager] removeHud];
        
        // moving to PlayOnlineMainScreenViewController
        //[self.appOnline UnsubscribeToNotifications:self];
        [[NSUserDefaults standardUserDefaults] setObject:_txtFieldUserName.text.trim forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:_txtFieldPassword.text.trim forKey:@"Password"];
        DataTable *userTable = self.appOnline.User.UserData;
        //games = [[self.appOnline.User.RoomInfoAppData objectForKey:@"Games"] FetchAllRowsFromTable];
        NSString *firstName = [userTable FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"FirstName"];
        NSString *lastName = [userTable FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"LastName"];
        NSString *userId = [userTable FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"UserID"];
        NSString *countryCode = [userTable FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"CountryName"];
        //if (firstName != nil && lastName != nil){
         [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"FirstName"];
        [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:@"LastName"];
         [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:@"CountryCode"];
        NSString * storyboardName = @"Storyboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        NewGameTypeViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"NewGameTypeViewController"];
        vc.appOnline = self.appOnline;
        [[self navigationController] pushViewController:vc animated:false];
        [self flipPushVC:self];
        //[self performSegueWithIdentifier:@"MainScreen" sender:self];
    });
    
  // 0x1c4e71280
}


- (void)AppOnlineLoginFailureNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineLoginFailureNotification >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"inside dispatch async block main thread from main thread");
        [self.theAlert closeSplashAlert];
        [[MyManager sharedManager] removeHud];
            [self.theAlert showOkAlert:self title:@"Login Failure" message:@"Username or Password is incorrect"];
        
    });
}

- (void)AppOnlineErrorNotification:(NSNotification*)notificationSender {
    NSLog(@"AppOnlineErrorNotification");
    [CommonTasks LogMessage:@"AppOnline Error Notification!...." MessageFlagType:logMessageFlagTypeSystem];
}

//MARK:- Internet connectivity method
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


- (IBAction)btnSignUp:(id)sender {
}
@end

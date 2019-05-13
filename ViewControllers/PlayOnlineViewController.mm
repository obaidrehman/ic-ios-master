//
//  PlayOnlineViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "PlayOnlineViewController.h"
#import "PlayOnlineMainScreenViewController.h"
#import "AppOptions.h"
//#import "AppThemes.h"
#import "CommonTasks.h"
#import "MyManager.h"

@interface PlayOnlineViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet nTextField *txtFieldUserName;
@property (weak, nonatomic) IBOutlet nTextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet nButton *buttonReturn;
@property (weak, nonatomic) IBOutlet nButton *buttonSignin;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayonline;
@property (weak, nonatomic) IBOutlet UILabel *labelRememberCredentials;
@property (weak, nonatomic) IBOutlet UISwitch *switchRememberCredentials;

@end

@implementation PlayOnlineViewController


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

    [self.view setAutoresizesSubviews:YES];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    //[AppOptions SubscribeForKeyboardNotifications:self];
    [self SetControlsAndThemes];
    
    //•mod•
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(AppOnlineLoginSuccessNotification:) name: @"AppOnlineLoginSuccessNotification" object: nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self SetControlsAndThemes];
}

/// @description all new controls/views additions, modification to present controls/views and themes in this method
- (void)SetControlsAndThemes
{
    // set background
    self.imageViewBackground.image = [UIImage imageNamed:@"backgroundLight"];
    
    // set label colors
    self.labelUsername.textColor = [UIColor colorWithHexString:@"#0b2744"];
    self.labelPassword.textColor = [UIColor colorWithHexString:@"#0b2744"];
    self.labelPlayonline.textColor = [UIColor colorWithHexString:@"#0b2744"];
    self.labelRememberCredentials.textColor = [UIColor colorWithHexString:@"#0b2744"];
    
    // set text fields color
    [self.txtFieldPassword SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:[UIColor colorWithHexString:@"#0b2744"]
                                                                  TextFieldTextColor:[UIColor whiteColor]
                                                              TextFieldTextAlignment:NSTextAlignmentLeft
                                                            TextFieldBackgroundColor:[UIColor clearColor]];
    [self.txtFieldUserName SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:[UIColor colorWithHexString:@"#0b2744"]
                                                                  TextFieldTextColor:[UIColor whiteColor]
                                                              TextFieldTextAlignment:NSTextAlignmentLeft
                                                            TextFieldBackgroundColor:[UIColor clearColor]];
    
    // set buttons
    [self.buttonSignin SetAsDualColorButtonWithText:@"Sign in"
                                          TextColor:[UIColor colorWithHexString:@"#0b2744"]
                                       TextFontType:self.buttonSignin.titleLabel.font
                                        TextScaling:1
                                      TextAlignment:NSTextAlignmentCenter
                                              Image:[UIImage imageNamed:@"iconSignin"]
                                ImageScalingPercent:3
                                     ImageTintColor:[UIColor whiteColor]
                                    ImageOnLeftSide:NO
                                          LeftColor:[UIColor whiteColor]
                                   LeftColorPercent:60
                                         RightColor:[UIColor colorWithHexString:@"#0b2744"]
                                       CornerRadius:5
                                       Transparency:1
                                    DropShadowColor:nil
                                   DropShadowRadius:0
                                  DropShadowOpacity:0
                                   DropShadowOffset:CGSizeZero];
    
    [self.buttonReturn SetAsImageOnlyButtonWithImage:[UIImage imageNamed:@"iconReturn"]
                                   ImageScalingValue:4
                                     ImageTintColor:[UIColor whiteColor]
                                       CornerRadius:(self.buttonReturn.frame.size.width / 2)
                              ButtonBackgroundColor:[UIColor colorWithHexString:@"#0b2744"]
                                        Transparency:1
                                     DropShadowColor:nil
                                    DropShadowRadius:0
                                   DropShadowOpacity:0
                                    DropShadowOffset:CGSizeZero];
    
    self.switchRememberCredentials.onTintColor = [UIColor colorWithHexString:@"#0b2744"];
    if (self.switchRememberCredentials.isOn)
    {
        if ([CommonTasks AppGetValueForKey:@"AppUserName"])
            self.txtFieldUserName.text = (NSString*)[CommonTasks AppGetValueForKey:@"AppUserName"];
        if ([CommonTasks AppGetValueForKey:@"AppUserPass"])
            self.txtFieldPassword.text = (NSString*)[CommonTasks AppGetValueForKey:@"AppUserPass"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SwitchRememberCredentialsValueChanged:(id)sender
{
    if (self.switchRememberCredentials.isOn)
    {
        if ((self.txtFieldUserName.text && self.txtFieldPassword.text)
            &&
            (!self.txtFieldUserName.text.isEmptyOrWhiteSpaces && !self.txtFieldPassword.text.isEmptyOrWhiteSpaces))
        {
            [CommonTasks AppSetValue:self.txtFieldUserName.text forKey:@"AppUserName"];
            [CommonTasks AppSetValue:self.txtFieldPassword.text forKey:@"AppUserPass"];
        }
    }
    else
    {
        [CommonTasks AppSetValue:[NSString Empty] forKey:@"AppUserName"];
        [CommonTasks AppSetValue:[NSString Empty] forKey:@"AppUserPass"];
    }
}


- (IBAction)ButtonReturnTapped:(id)sender
{
    // in case the splash got hanged on this screen.. is this even possible?
//    if (self.splash)
//    {
//        [self.splash Stop];
//        self.splash = nil;
//    }

    [[SplashScreen SplashScreenInstance] Stop];
    
    // tear down socket connection if any!
    if (self.appOnline)
    {
        // tear down socket connection if any!
        [self.appOnline DeinitAppOnline:self];
        self.appOnline = nil;
    }
    
    // just return to main menu
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ButtonSignInClick:(id)sender
{
    // remove the keyboard from view
    [self.view endEditing:YES];
    
    // add a splash screen and wait until connected!
//    if (!self.splash)
//        self.splash = [[SplashScreen alloc] initWithMessage:@"Conneting to server..." ViewToAddTo:self.view];
//    [self.splash Start];
    [[SplashScreen SplashScreenInstance] Stop];
    [[SplashScreen SplashScreenInstance] Start:@"Connecting to server..."];
    
    // now connect online if possible!
    //[self performSelectorInBackground:@selector(ConnectOnline) withObject:nil];
    [self ConnectOnline];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // remove the keyboard from view
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the keyboard from view
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // just pass a reference to apponline
    ((PlayOnlineMainScreenViewController*)[segue destinationViewController]).appOnline = self.appOnline;
}



- (void)ConnectOnline
{
    // validate textFields
    if ((self.txtFieldUserName.text && self.txtFieldPassword.text)
        &&
        (!self.txtFieldUserName.text.isEmptyOrWhiteSpaces && !self.txtFieldPassword.text.isEmptyOrWhiteSpaces))
        {
            // save user name and pass
            if (self.switchRememberCredentials.isOn)
            {
                [CommonTasks AppSetValue:self.txtFieldUserName.text forKey:@"AppUserName"];
                [CommonTasks AppSetValue:self.txtFieldPassword.text forKey:@"AppUserPass"];
            }
            
            // now connect to server
            
            // init sockets
            //self.appOnline = [[txtFieldUserName alloc] initWithSocket:nil];
            
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
                // ok something is wrong so stop splashing!
//                if (self.splash)
//                {
//                    [self.splash Stop];
//                    self.splash = nil;
//                }

                [[SplashScreen SplashScreenInstance] Stop];
                [[MyManager sharedManager] removeHud];
 
                
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
                
                [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                    [self.appOnline SendLoginUser:self.txtFieldUserName.text.trim Password:self.txtFieldPassword.text.trim];
                }];
            }
        }
    else
    {

        [[SplashScreen SplashScreenInstance] Stop];
         [[MyManager sharedManager] removeHud];

        
        [CommonTasks LogMessage:[NSString stringWithFormat:@"User name and/or password cannot be empty! %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeWarning];
        
        // tear down socket connection if any!
        self.appOnline = [self.appOnline DeinitAppOnline:self];
        
        // now just return
        return;
    }
}


// subscribed notifications ______________________________

//- (void)AppOnlineLoggedInNotification:(NSNotification*)notificationSender
- (void)AppOnlineLoginSuccessNotification:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"AppOnline Logged In Notification....!" MessageFlagType:logMessageFlagTypeSystem];
    
    // login successful, now move ahead to online game
//    if (self.splash)
//    {
//        [self.splash Stop];
//        self.splash = nil;
//    }

    [[SplashScreen SplashScreenInstance] Stop];
     [[MyManager sharedManager] removeHud];
    // moving to PlayOnlineMainScreenViewController
    [self.appOnline UnsubscribeToNotifications:self];
    [self performSegueWithIdentifier:@"MainScreen" sender:self];
}

- (void)AppOnlineLoggedInStopNotification:(NSNotification*)notificationSender
{
    // tear down socket connection if any!
    [self.appOnline DeinitAppOnline:self];
    self.appOnline = nil;
    
    [CommonTasks DoAsyncTaskOnMainQueue:^{
        
        [[SplashScreen SplashScreenInstance] Stop];
         [[MyManager sharedManager] removeHud];

    }];
}

- (void)AppOnlineErrorNotification:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"AppOnline Error Notification!...." MessageFlagType:logMessageFlagTypeSystem];
}

- (void)KeyboardDidShowNotification:(NSNotification*)notificationSender
{
    [AppOptions SetViewMovedUp:YES View:self.view KeyboardNotification:notificationSender ErrorValue:self.view.frame.origin.y];
}

- (void)KeyboardWillHideNotification:(NSNotification*)notificationSender
{
    [AppOptions SetViewMovedUp:NO View:self.view KeyboardNotification:notificationSender ErrorValue:self.view.frame.origin.y];
}

@end

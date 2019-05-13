//
//  FirstVC.m
//  InfinityChess2018
//
//  Created by Shehzar on 1/30/18.
//

#import "FirstVC.h"
#import "BaseVC.h"
#import "SideMenuViewController.h"
#import "FirstVCViewCell.h"
#import "TheAlerts.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "Packet.h"
#import "DataTable.h"
#import "UserSession.h"
#import "AppOnline.h"
#import "Reachability.h"
#import "UIImage+animatedGIF.h"
#import "NewGameTypeViewController.h"
#import "ProfileViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "SelectColorSchemeController.h"

@interface FirstVC () {
    BOOL isNewGame;
    BOOL isSplashAppeared;
    NSString *appVersionFromServer;
    BOOL willAppearDidAppearLock;
}
@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) TheAlerts *theAlert;
@end

@implementation FirstVC

-(void)versionCheckViaLink {
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"http://ashajju.net/infinitychess/api/v1/getVersion.php"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = @"action=ios_ver";
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    
    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    
    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       appVersionFromServer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       // appVersionFromServer = @"1.8";
        NSLog(@"•••••>>>>> %@", appVersionFromServer);
    }];
    
    // Fire the request
    [dataTask resume];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.titlesArray = @[@"Play Computer",
                         @"Play Online",
                         @"Tactics",
                         @"Vision Trainer",
                         @"Lesson",
                         @"Video",
                         @"Daily Puzzle",
                         @"Article"];
    isSplashAppeared = false;
  
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(checkForLoginNot)
                                                 name: @"UserLogOut"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(versionCheckResponse:)
                                                 name: @"icPacketCheckAppVersionResponse"
                                               object: nil];
    [[MyManager sharedManager]setFirVC:self];
    self.theAlert = [[TheAlerts alloc]init];
    
    willAppearDidAppearLock = NO;
   
    
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
//    if (!isSplashAppeared){
//    [self runSpinAnimationOnView:self.splashImageView duration:1.0 rotations:1.0 repeat:0];
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.splashView.hidden = YES;
//        [self checkForAppVersion];
//        isSplashAppeared = true;
//        [self checkForLogin];
//    });
//    }else{
//        [self checkForAppVersion];
//        [self checkForLogin];
//    }
    
    [self checkForLogin];
    
    NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    if ([userData isEqualToString:@""] || userData == nil){
        self.appOnline = [self.appOnline DeinitAppOnline:self];
    }else{
       //  [self setLoginAutoConnection];
    }
   
      // [self ConnectToSocket2];
}

- (void)viewDidAppear:(BOOL)animated {
    
     [super viewDidAppear:animated];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"chess_800x600" withExtension:@"gif"];
//    self.splashImageView.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    
    //[self performSelector:@selector(splashFunctionality) withObject:self afterDelay:5.0];
   // [self performSelector:@selector(versionCheckFunctionality) withObject:self afterDelay:6.0];
    
    
    //self.splashView.hidden = YES;
   
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"chess_800x600" withExtension:@"gif"];
    self.splashImageView.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    if (!isSplashAppeared){
        //[self checkForAppVersion];
        isSplashAppeared = true;
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.splashView.hidden = YES;
            self.splashImageView.image=nil;
                isSplashAppeared = true;
            [self setLoginAutoConnection];
            
              //  [self checkForAppVersion];
//            if (![self connected]) {
//                [self.theAlert showOkAlert:self title:@"Internet Problem" message:@"Please connect to the WiFi"];
//            } else {
            int randomIndex = arc4random_uniform(9);
             [[MyManager sharedManager] starAnimationWithTableView:_tblView :randomIndex];
                [self checkForLogin];
                 [self versionCheckViewSetting];
           // }
            
           
        });
//        double delayInSeconds2 = 6.0;
//        dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
//        dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
//           // [self checkForAppVersion];
//
//            //[self checkForLogin];
//        });
    }else{
//        [self checkForAppVersion];
        [self checkForLogin];
    }

    [self versionCheckViaLink];
   
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(void)splashFunctionality {
    self.splashView.hidden = YES;
    self.splashImageView.image=nil;
}

-(void)versionCheckFunctionality {
    [self checkForAppVersion];
}

-(void)checkForLoginNot{
    NSLog(@"NOTIFICATION================HAI");
}

-(void)checkForLogin{
    NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    
//    _btnLoginOrProfile.font = [UIFont fontWithName:@"chessglyph-webfont" size:20];
//    [_btnLoginOrProfile setTitle:@"Z" forState:normal];
    
    
    if ([userData isEqualToString:@""] || userData == nil){
        _btnLoginOrProfile.font = [UIFont systemFontOfSize:17];
        [_btnLoginOrProfile setImage:nil forState:normal];
        [_btnLoginOrProfile setTitle:@"Log In" forState:normal];
        _btnLoginOrProfile.tag = 0;
        
       // [_btnSignUp.titleLabel setText:@"Sign Up"];
        NSLog(@"");
    }else{
        [_btnLoginOrProfile setTitle:@"" forState:normal];
        _btnLoginOrProfile.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        UIImage *icon = [UIImage imageWithIcon:@"fa-user"
                               backgroundColor:[UIColor clearColor]
                                     iconColor:[UIColor whiteColor]
                                       andSize:CGSizeMake(20, 20)];
        [_btnLoginOrProfile setImage:icon forState:normal];
        _btnLoginOrProfile.tag = 1;
      //  [_btnSignUp.titleLabel setText:@"New Game"];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstVCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        [cell.imgGameType setImage:[UIImage imageNamed:@"user1"]];
    }
    if (indexPath.row > 1){
        [cell.disableView setHidden:false];
    }else{
        [cell.disableView setHidden:true];
        [cell setImgTitleGif];
    }
    cell.lblGameType.text = _titlesArray[indexPath.row];
    [[cell.imgGameType layer] setCornerRadius:3.0];
    [[cell.imgGameType layer] setMasksToBounds:true];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:
            [self.appOnline checkMasla];
            break;
        case 0:
            isNewGame = NO;
            [self performSegueWithIdentifier:@"playVsCompSegueID" sender:self];
            break;
        case 1:
            NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
            if ([userData isEqualToString:@""] || userData == nil){
                [self setAlert];
            }else{
                NSString * storyboardName = @"Storyboard";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                NewGameTypeViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"NewGameTypeViewController"];
                vc.appOnline = self.appOnline;
                //[self setVCTransition:kCATransitionReveal subType:kCATransitionFromBottom childVC:self duration:0.7];
                [[self navigationController] pushViewController:vc animated:false];
                [self flipPushVC:self];
                //[self pushLoginVC:@"NewGameTypeViewController"];
            }
            break;
           
      //  default:
     //       break;
    }
}

-(void)setAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Sign In" message:@"Please log in or sign up (it's free!) to play other members, join the discussion, and get the full Infinity Chess experience" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Get Started!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self pushLoginVC:@"LoginVC2"];
        
    }];
    
    // relate actions to controllers
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    //presentViewController(alertController, animated: true, completion: nil)
}

//MARK:- Action Login
- (IBAction)actionLoginButton:(UIButton*)sender {
    if (sender.tag == 1){
        NSString * storyboardName = @"Storyboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        ProfileViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        vc.appOnline = self.appOnline;
        [[self navigationController] pushViewController:vc animated:true];
       // [self pushLoginVC:@"ProfileViewController"];
    }else{
    [self pushLoginVC:@"LoginVC2"];
    }
}

-(void)pushColorVC{
    SelectColorSchemeController *scsc = [[SelectColorSchemeController alloc]
                                         initWithParentViewController: nil];
    [self.navigationController pushViewController:scsc animated:true];
}

-(void)pushLoginVC:(NSString *)vcIdentifier{
    NSString * storyboardName = @"Storyboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
    [[self navigationController] pushViewController:vc animated:true];
}


- (IBAction)playVsCompBtnAction:(id)sender {
    isNewGame = NO;
    [self performSegueWithIdentifier:@"playVsCompSegueID" sender:self];
}

- (IBAction)newGameBtnAction:(id)sender {
    isNewGame = YES;
    [self performSegueWithIdentifier:@"newGameSegueID" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"loginSID"]) {
        
    } else {
        BaseVC *bvc = (BaseVC*)segue.destinationViewController;
        if([segue.identifier isEqualToString:@"playVsCompSegueID"]){
            [bvc hideOptions];
        }
        bvc.isNewGame = isNewGame;
    }
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:true];
//    [self.againLogin2 DeinitAppOnline:self];
//}

-(void)versionCheckViewSetting{
    if (![self connected]) {
        [self.theAlert showOkAlert:self title:@"Internet Problem" message:@"Please connect to the WiFi"];
    }else{
    
    NSString *localVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![localVer isEqualToString:appVersionFromServer]){
        [_versionChkView setHidden:false];
    }else{
        [_versionChkView setHidden:true];
    }}
}

//-(void)versionCheckResponse:(NSNotification*)notificationSender{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
//        NSString *serVersion= [packet PacketGetStringForKey:icPacketSignUpAlreadyWithTheAccount];
//             NSString *localVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//        if (![localVer isEqualToString:serVersion]){
//            [_versionChkView setHidden:false];
//        }else{
//             [_versionChkView setHidden:true];
//        }
//       // [_versionChkView setHidden:false];
//         //[_versionChkView setHidden:false];
//        //[self.againLogin2 DeinitAppOnline:self];
//        NSLog(@"");
//    });
//}

- (IBAction)actionUpdateButton:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://ashajju.net/infinitychess/v1/"];
    if (![[UIApplication sharedApplication] openURL:url]) {
    }
}

-(void)checkForAppVersion{
    
    if (![self connected]) {
        [self.theAlert showOkAlert:self title:@"Internet Problem" message:@"Please connect to the WiFi"];
    } //else
        //[self ConnectToSocket];
    
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


//-(void)ConnectToSocket{
//
//    self.againLogin2 = [[AppOnline alloc] initWithSocket:nil];
//    [self.againLogin2 SubscribeToNotifications:self];
//
//    // check if connected
//    if (![self.againLogin2 CheckServerConnectionStateForDataFlow:100000])
//    {
//        // retry in case new server is available
//        [self.againLogin2.socketSession TearDown:NO];
//    }
//    // again check if connected
//    if (![self.againLogin2 CheckServerConnectionStateForDataFlow:0])
//    {
//
//        [CommonTasks LogMessage:[NSString stringWithFormat:@"unalbe to establish socket connection to server %@", [CommonTasks Bad]] MessageFlagType:logMessageFlagTypeError];
//
//        // tear down socket connection if any!
//        self.againLogin2 = [self.againLogin2 DeinitAppOnline:self];
//
//        // now just return
//        return;
//    }
//
//    // if connected to server, send handshake
//    if ([self.againLogin2 CheckServerConnectionStateForDataFlow:10])
//    {
//        [CommonTasks LogMessage:@"sending handshake!" MessageFlagType:logMessageFlagTypeSystem];
//
//        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
//            [self.againLogin2.socketSession SendHandShakeRequest];
//        }];
//    }
//
//    if ([self.againLogin2 CheckServerConnectionStateForDataFlow:10])
//    {
//        [CommonTasks LogMessage:@"Checking App Version" MessageFlagType:logMessageFlagTypeSystem];
//       // [[MyManager sharedManager] setAgainLoginAppOnline:self.appOnline];
//       // [self.appOnline SendLogOffUser];
//       // [self.appOnline SendLoginUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"Password"]];
//        [self.againLogin2 checkForAppVersion];
//
//        // self.appOnline;
//        NSLog(@"Checking");
//    }
//
//}


-(void)setLoginAutoConnection{
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
       // [self.theAlert closeSplashAlert];
       // [[MyManager sharedManager] removeHud];
       // [self.theAlert showOkAlert:self title:@"Connection Error" message:@"Unable to connect to server now, try again later!"];
        
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
        
        [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"];
        //self.txtFieldUserName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.appOnline SendLoginUser:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"Password"]];
            [[self appDelegate]setAppOnline:_appOnline];
            [[self appDelegate] setIsLoginUser:true];
             [[self appDelegate] timerMethod];
        });
    }
    else
    {
        
        // tear down socket connection if any!
        self.appOnline = [self.appOnline DeinitAppOnline:self];
        
        // now just return
        return;
    }
}

@end

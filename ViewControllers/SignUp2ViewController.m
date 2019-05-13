//
//  SignUp2ViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/18/18.
//

#import "SignUp2ViewController.h"
#import "NSLocale+TTEmojiFlagString.h"
#import "MyManager.h"
#import "AppOnline.h"
#import "Reachability.h"
#import "TheAlerts.h"
@interface SignUp2ViewController (){
    NSString *countryCode;
    NSString *country;
}
@property (strong, nonatomic) TheAlerts *theAlert;

@end

@implementation SignUp2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUserNameOrEmailAlreadyThere = false;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(signUpUserResponseAction:)
                                                 name: @"icPacketSignUpUserResponse"
                                               object: nil];
    NSLocale *countryLocale = [NSLocale currentLocale];
    countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    NSLog(@"Country Code:%@ Name:%@", countryCode, country);
   // return;
   // [_lblCountryFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:country]]];
    [_lblCountryFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[[MyManager sharedManager] getFlagOfTheCountry:country]]]];
    [_txtCountryName setText:country];
     self.theAlert = [[TheAlerts alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionContinueButton:(id)sender {
    if (![self connected]) {
        [self.theAlert showOkAlert:self title:@"Internet Problem" message:@"Please connect to the WiFi"];
    } else
    [self ConnectToSocket];
    NSLog(@"%@",_userData);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)ConnectToSocket{
    
    NSMutableDictionary *userFullData;
    //userFullData = _userData;
    _userData = @{@"FirstName":_txtFirstName.text,
                  @"LastName":_txtLastName.text,
                  @"UserName":[_userData objectForKey:@"UserName"],
                  @"Password":[_userData objectForKey:@"Password"],
                  @"Email":[_userData objectForKey:@"Email"],
                  @"CountryCode":countryCode
                  };
    [[MyManager sharedManager] showHUDWithTransform:@"Connecting to Server" forView:self.view];
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
    
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending login!" MessageFlagType:logMessageFlagTypeSystem];
        [self.appOnline signUpUser:_userData];
    }
    
}

//MARK:- Sign Up Response
-(void)signUpUserResponseAction:(NSNotification*)notificationSender {
    dispatch_async(dispatch_get_main_queue(), ^{
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        NSString *isAccountAlreadyThere = [packet PacketGetStringForKey:icPacketSignUpAlreadyWithTheAccount];
        if ([isAccountAlreadyThere isEqualToString:@"0"]){
            [[MyManager sharedManager] removeHud];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username or Email already in use" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                _isUserNameOrEmailAlreadyThere = true;
                [self.navigationController popViewControllerAnimated:true];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
           // NSLog(@"inside dispatch async block main thread from main thread");
            [[NSUserDefaults standardUserDefaults] setObject:[_userData objectForKey:@"UserName"] forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:[_userData objectForKey:@"Password"] forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults] setObject:[_userData objectForKey:@"FirstName"] forKey:@"FirstName"];
            [[NSUserDefaults standardUserDefaults] setObject:[_userData objectForKey:@"LastName"] forKey:@"LastName"];
            [[NSUserDefaults standardUserDefaults] setObject:country forKey:@"Country"];
            [[MyManager sharedManager] removeHud];
            [self.navigationController popViewControllerAnimated:false];
        }
        NSLog(@"");
    });
    
    NSLog(@"");
}

@end

//
//  SignUpViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/13/18.
//

#import "SignUpViewController.h"
#import "Utility.h"
#import "TheAlerts.h"
#import "MyManager.h"
#import "SignUp2ViewController.h"
@interface SignUpViewController (){
    SignUp2ViewController *vc;
}
@property (strong, nonatomic) TheAlerts *theAlert;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theAlert = [[TheAlerts alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(vc){
        if(!vc.isUserNameOrEmailAlreadyThere){
            [self.navigationController popViewControllerAnimated:true];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//icPacketSignUpUserResponse

- (IBAction)actionBackButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)actionContinueButton:(id)sender {
    
    //if ([_txtUserName cha])

    NSDictionary *dict =  @{ @"UserName" : _txtUserName.text, @"Password" : _txtPassword.text,@"Email":_txtEmail.text};
    
    if (![Utility isValidText:_txtUserName.text]){
        [self.theAlert showOkAlert:self title:@"UserName" message:@"UserName length must be greater than 5"];
        return;
    }
    if(![Utility isValidEmailAddress:_txtEmail.text]){
        [self.theAlert showOkAlert:self title:@"Email" message:@"Please enter valid Email"];
        return;
    }
    if(![Utility isValidText:_txtPassword.text]){
        [self.theAlert showOkAlert:self title:@"Password" message:@"Password length must be greater than 5"];
        return;
    }
    
    NSString * storyboardName = @"Storyboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp2ViewController"];
    vc.userData = dict;
    [[self navigationController] pushViewController:vc animated:true];
}
@end

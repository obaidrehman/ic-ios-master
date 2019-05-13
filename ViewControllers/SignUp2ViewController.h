//
//  SignUp2ViewController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/18/18.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
@interface SignUp2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblCountryFlag;
@property (weak, nonatomic) IBOutlet UITextField *txtCountryName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) NSDictionary *userData;
@property (strong)  AppOnline* appOnline;
@property (nonatomic)  BOOL isUserNameOrEmailAlreadyThere;
@end

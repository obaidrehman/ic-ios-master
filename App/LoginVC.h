//
//  LoginVC.h
//  InfinityChess2018
//
//  Created by Shehzar on 3/16/18.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "BaseController.h"
@interface LoginVC : BaseController


@property (strong)  AppOnline* appOnline;
- (BOOL)connected;

@end

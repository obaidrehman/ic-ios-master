/*
  Stockfish, a chess program for iOS.
  Copyright (C) 2004-2014 Tord Romstad, Marco Costalba, Joona Kiiski.

  Stockfish is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Stockfish is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "AppDelegate.h"
#import "ECO.h"
#import "MoveListView.h"
#import "Options.h"

#include "../Chess/mersenne.h"
#include "../Chess/movepick.h"
#import "MyManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface AppDelegate(){
}



/// @description helpers for inifinty chess to stockfish squares
@property (strong,readonly) NSArray *moveSquaresICtoSF;

/// @description helpers for infinity chess to stockfish promotion pieces
@property (strong, readonly) NSArray *movePromotionPiecesICtoSF;

@end


using namespace Chess;

@implementation AppDelegate

@synthesize window /*, viewController, gameController*/;


- (BOOL)application :(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:@"User_Id"];
    // if ([currentElement isEqualToString:@"aaa"] || [currentElement isEqualToString:@"bbb"])
    if ([userData isEqualToString:@""] || userData == nil){
        
        NSLog(@"");
    }else{
        
    }
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // Add any custom logic here.
    _isLoginUser = false;
    [application setStatusBarHidden:YES];
   return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

-(void)timerMethod{
__weak id weakSelf = self;
__block void (^timer)(void) = ^{ double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ id strongSelf = weakSelf;
        if (!strongSelf){
            return;
        }
        // Schedule the timer again
        if(_isLoginUser){
             timer();
            BOOL isServerOkay = [[strongSelf appOnline] CheckServerConnectionState];
            if (!isServerOkay){
                [[[UIAlertView alloc]initWithTitle:@"Server Not Responding" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
            }
        }
       
        // Always use strongSelf when calling a method or accessing an iVar
       // [strongSelf doSomething];
       // strongSelf->anIVar = 0;
        
       
        NSLog(@"TIMER======================================%@",self.appOnline);
    });
    
}; // Start the timer for the first time
    timer();
}
//- (void)applicationWillTerminate:(UIApplication *)application {
//   NSLog(@"AppDelegate applicationWillTerminate:");
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillTerminate" object:self userInfo:nil];
//
//    [self.appOnline destruct];
//
//    NSLog(@" D E S T R U C T ");
//
//
////   [self saveState];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
   NSLog(@"AppDelegate applicationWillResignActive:");
//   [self saveState];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   NSLog(@"AppDelegate willEnterForeground:");
    
//   [gameController checkPasteboard];
}
-(void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"applicationDidBecomeActive");
}


@end

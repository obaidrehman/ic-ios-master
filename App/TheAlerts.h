//
//  TheAlerts.h
//  InfinityChess2018
//
//  Created by Shehzar on 3/19/18.
//

#import <Foundation/Foundation.h>

@interface TheAlerts : NSObject

- (void)showSplashAlert:(UIViewController*)vc message:(NSString*)msg;
- (void)closeSplashAlert;


- (void)showOkAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*)msg;

@property BOOL splashIsOnScreen;

@end

//
//  SplashScreen.h
//  Infinity Chess iOS
//
//  Created by user on 3/21/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppOptions.h"
//#import "JGProgressHUD.h"
/// @description the splash screen itself is just a view that can be bring fourth and removed when not required
@interface SplashScreen : NSObject

/// @description this will return a singleton splashcreen instance, use this where ever required
+ (SplashScreen*) SplashScreenInstance;

- (void)SetMessage:(NSString*)message;

/// @description init an instance of splash screen with the message to display
//- (id)initWithMessage:(NSString*)message View:(UIView*)view;

/// @description this returns the top most view in the app
- (UIView *)GetTopView;


/// @description this starts the splash screen i.e. bring it into view
- (void)Start:(NSString*)message;

/// @description this stops the splash screen i.e. remove it form view
- (void)Stop;

@end

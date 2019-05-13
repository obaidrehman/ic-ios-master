//
//  AppOptions.h
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AppThemes.h"
//#import "RNBlurModalView.h"
#import "RNRippleTableView.h"
#import "RNSampleCell.h"
//#import "RNGridMenu.h"
#import "nMoonButtonView.h"
#import "nButton.h"
//#import "nSlider.h"
#import "nTextField.h"
#import "nView.h"
#import "nPageControl.h"
#import "HexColor.h"
#import "ImageEditing.h"
#import <MediaPlayer/MediaPlayer.h>

/// @description use this class for all options themes and related stuff!
///
/// Note: the MainViewController should always have an object of this type, and is passed to other view controllers
///
/// VERY IMPORTANT: Only use object type properties here in this class as main menu instance refrence is passed and no delegation is used! alternatively im providing a static instance also, use this instead where ever necessary!
@interface AppOptions : NSObject

+ (AppOptions*)AppOptionsInstance;

//@property (strong, readonly) AppThemes *themes;

/// @description this lets a class or viewcontroller get notifications about app launch, pause, resume and terminate etc, the class or viewcontroller need to implement the related methods
/// @param subscriber those who are blind and wanna know xD
+ (void)SubscribeForApplicationNotifications:(id)subscriber;
/// @description so a.. now u wanna know when u see the keys...
/// @param subscriber those who are blind and wanna know xD
+ (void)SubscribeForKeyboardNotifications:(id)subscriber;
/// @description related methods to keyboard notification
+ (void)SetViewMovedUp:(BOOL)movedUp View:(UIView*)view KeyboardNotification:(NSNotification*)notificationSender ErrorValue:(CGFloat)error;

/// @description app display brightness adjustment
+ (void)SetDisplayBrightness:(CGFloat)value;
/// @description app display brightness
+ (CGFloat)DisplayBrightness;

/// @description get value for key in info.plist
+ (NSObject*)GetKeyValue:(NSString*)key;


@end

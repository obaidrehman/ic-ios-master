//
//  AppOptions.m
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "AppOptions.h"
#import "CommonTasks.h"


@implementation AppOptions
{
    //AppThemes *_themes;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        //_themes = [[AppThemes alloc] init];
    }
    return self;
}


static AppOptions *options;
+ (AppOptions*)AppOptionsInstance
{
    if (options == nil)
        options = [[AppOptions alloc] init];
    return options;
}

+ (void)SubscribeForApplicationNotifications:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(ApplicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(ApplicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(ApplicationWillResignActiveNotification:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(ApplicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification object:nil];
}

+ (void)SubscribeForKeyboardNotifications:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(KeyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(KeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)ApplicationDidEnterBackgroundNotification:(NSNotification*)notificationSender { }
- (void)ApplicationWillEnterForegroundNotification:(NSNotification*)notificationSender { }
- (void)ApplicationWillResignActiveNotification:(NSNotification*)notificationSender { }
- (void)ApplicationWillTerminateNotification:(NSNotification*)notificationSender { }
- (void)KeyboardDidShowNotification:(NSNotification*)notificationSender { }
- (void)KeyboardWillHideNotification:(NSNotification*)notificationSender { }



+ (void)SetViewMovedUp:(BOOL)movedUp View:(UIView*)view KeyboardNotification:(NSNotification*)notificationSender ErrorValue:(CGFloat)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    CGRect rect = view.frame;
    CGRect keyboardframe = [[[notificationSender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (movedUp)
        rect.size.height -= (keyboardframe.size.height - error);
    else
        rect.size.height += (keyboardframe.size.height - error);

    view.frame = rect;
    
    [UIView commitAnimations];
}
- (void)keyboardWasShown:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"ok now you seeing the keyboard xD"
            MessageFlagType:logMessageFlagTypeInfo];
}

- (void)keyboardWillBeHidden:(NSNotification*)notificationSender
{
    [CommonTasks LogMessage:@"ok now you dont see the keyboard xD"
            MessageFlagType:logMessageFlagTypeInfo];
}


+ (void)SetDisplayBrightness:(CGFloat)value
{
    [[UIScreen mainScreen] setBrightness:value];
}
+ (CGFloat)DisplayBrightness
{
    return [[UIScreen mainScreen] brightness];
}

+ (NSObject *)GetKeyValue:(NSString*)key
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:key];
}

@end

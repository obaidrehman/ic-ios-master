//
//  SplashScreen.m
//  Infinity Chess iOS
//
//  Created by user on 3/21/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "SplashScreen.h"
#import "CommonTasks.h"

@implementation SplashScreen
{
    UIView *parentView;
    UIView *splashView;
    UILabel *splashMessage;
    UIActivityIndicatorView *splashActivity;
    UIView *splashContentHolder;
    
    NSThread *timerThread;
    int timeLimitToKillSplash;
    int timeCounter;
}

- (NSString*)DefaultConnectMessage
{
    return @"Connecting...";
}

- (NSString*)DefaultDisconnectMessage
{
    return @"Unable to connect\nRetrying...";
}


- (void)InitAndRunTimerThread
{
    if (timerThread == nil)
    {
        timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(DoTimerThreadWork) object:nil];
        timerThread.name = @"splash timer thread";
    }
    timeLimitToKillSplash = 3; // time in seconds
    if (!timerThread.isExecuting)
        [timerThread start];
}
//- (void)SetMessage:(NSString *)message



- (void)SleepTimerThread
{
    //[NSThread sleepForTimeInterval:1.0];
}

- (void)DoTimerThreadWork
{
    while (YES)
    {
        [self performSelector:@selector(SleepTimerThread) onThread:timerThread withObject:nil waitUntilDone:YES];
        if (timerThread.isCancelled)
            [NSThread exit];
        
        @synchronized(self)
        {
            timeCounter++;
            if (timeCounter == timeLimitToKillSplash / 2)
                splashMessage.text = [self DefaultDisconnectMessage];
            if (timeCounter >= timeLimitToKillSplash)
                [self DeinitAndStopTimerThread];
        }
    }
}

- (void)DeinitAndStopTimerThread
{
    if (timerThread != nil)
    {
        [timerThread cancel];
    }
    [self Stop];
}








static SplashScreen* splash;
+ (SplashScreen *)SplashScreenInstance
{
    if (!splash)
        splash = [[SplashScreen alloc] init];
    return splash;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        //parentView = view;
        parentView = [self GetTopView];
        
        splashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
        
        splashView.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5f];
        
        splashContentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, splashView.frame.size.height / 2 - 50, splashView.frame.size.width, 100.0f)];
        
        CALayer *layer = [CALayer layer];
        layer.frame = splashContentHolder.layer.bounds;
        layer.shadowRadius = 4.0f;
        layer.shadowOpacity = 0.15f;
        layer.shadowOffset = CGSizeZero;
        layer.masksToBounds = NO;
        layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f].CGColor;
        layer.shadowColor = [UIColor colorWithHexString:@"#0b2744"].CGColor; //[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
        [splashContentHolder.layer addSublayer:layer];
        
        
        splashMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, splashContentHolder.frame.size.width, splashContentHolder.frame.size.height / 2)];
        splashMessage.backgroundColor = [UIColor clearColor];
        splashMessage.textColor = [UIColor colorWithHexString:@"#0b2744"];//[UIColor blackColor];
        splashMessage.userInteractionEnabled = NO;
        splashMessage.textAlignment = NSTextAlignmentCenter;
        //splashMessage.text = message || message.isEmptyOrWhiteSpaces ? [NSString Empty] : message;
        
        [splashContentHolder addSubview:splashMessage];
        
        
        
        splashActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, splashContentHolder.frame.size.height / 2, splashContentHolder.frame.size.width, splashContentHolder.frame.size.height / 2)];
        splashActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        splashActivity.backgroundColor = [UIColor clearColor];
        splashActivity.color = [UIColor colorWithHexString:@"#0b2744"];//[UIColor grayColor];
        
        [splashContentHolder addSubview:splashActivity];
        
        
        //splashContentHolder.backgroundColor = [UIColor whiteColor];
        
        
        
        [splashView addSubview:splashContentHolder];
    }
    return self;
}

- (void)SetMessage:(NSString *)message
{
    splashMessage.text = !message || message.isEmptyOrWhiteSpaces ? [NSString Empty] : message;
}

- (UIView *)GetTopView
{
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

- (void)Start:(NSString*)message
{
    [self SetMessage:message];
    //splashView.hidden = NO;
    [parentView addSubview:splashView];
    [parentView bringSubviewToFront:splashView];
    [splashActivity startAnimating];
    [self InitAndRunTimerThread];
}

- (void)Stop
{
    [splashActivity stopAnimating];
    //splashView.hidden = YES;
    [parentView sendSubviewToBack:splashView];
    [splashView removeFromSuperview];
    splash = nil;
}

@end

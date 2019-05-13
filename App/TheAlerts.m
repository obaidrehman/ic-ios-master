//
//  TheAlerts.m
//  InfinityChess2018
//
//  Created by Shehzar on 3/19/18.
//

#import "TheAlerts.h"
#import <UIKit/UIKit.h>


@interface TheAlerts () {
    
}

@property (nonatomic, strong) UIAlertController *splashAlertController;

@end


@implementation TheAlerts

- (void)showSplashAlert:(UIViewController*)vc message:(NSString*)msg{
    UIAlertController *splashAlertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    self.splashAlertController = splashAlertController;
    [vc presentViewController:splashAlertController animated:YES completion:nil];
    self.splashIsOnScreen = YES;
}
- (void)closeSplashAlert {
    NSLog(@"");
    [self.splashAlertController dismissViewControllerAnimated:YES completion:nil];
    self.splashIsOnScreen = NO;
}


- (void)showOkAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [vc presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:action1];
}

@end

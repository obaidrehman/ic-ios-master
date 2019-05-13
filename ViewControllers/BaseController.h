//
//  BaseController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/11/18.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController
-(void)setVCTransition:(NSString *)type subType:(NSString *)subType childVC:(UIViewController *)childVC duration:(CFTimeInterval)duration;
-(void)flipPushVC:(UIViewController *)VC;
@end

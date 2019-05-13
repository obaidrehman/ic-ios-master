//
//  BaseController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/11/18.
//

#import "BaseController.h"

@interface BaseController ()

@end
typedef NSString TransitionType,transitionSubType;
@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   // [self setVCTransition:Fade subType:kcatra];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
}

-(void)setVCTransition:(NSString *)type subType:(NSString *)subType childVC:(UIViewController *)childVC duration:(CFTimeInterval)duration{
    CATransition* transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = subType; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [childVC.navigationController.view.layer addAnimation:transition forKey:nil];
}

-(void)flipPushVC:(UIViewController *)VC{
    [UIView transitionWithView:VC.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}

//-(void)setTransitionsForViewController_ratingEnum:(enum TransitionType) tttt{
//
//}

@end
//enum transitionType{
//    Fade = 1,
//    Push = 2,
//    Reveal = 3,
//    MoveIn = kCATransitionMoveIn
//};
//enum transitionSubType{
//    TransitionFromLeft = 1,
//    TransitionFromRight = 2,
//    TransitionFromTop = 3,
//    TransitionFromBottom = 4
//};
//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//enum transitionValue:int{
//    //kCATransitionMoveIn //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    Fade = 1,
//    Push = 2,
//    Reveal = 3,
//    MoveIn = 4
//};



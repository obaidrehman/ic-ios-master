//
//  CheckMatePopUp.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/27/18.
//

#import "CheckMatePopUp.h"

@implementation CheckMatePopUp

- (void)awakeFromNib{
    [super awakeFromNib];
    [_popUpView.layer setCornerRadius:5];
    [_btnDone.layer setCornerRadius:5];
    [_btnShare.layer setCornerRadius:5];
    [_btnRematch.layer setCornerRadius:5];
    [_btnAnalysis.layer setCornerRadius:5];
    [self setClipsToBounds:true];
    
}
- (IBAction)actionShareButton:(id)sender {
}
- (IBAction)actionRematchButton:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName: @"RematchGameNotification"
     object: self
     userInfo:nil];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   
}
- (IBAction)actionAnalysisButton:(id)sender {
}
- (IBAction)actionDoneButton:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}

@end

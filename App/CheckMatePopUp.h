//
//  CheckMatePopUp.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/27/18.
//

#import <UIKit/UIKit.h>

@interface CheckMatePopUp : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblWinnerColor;
@property (weak, nonatomic) IBOutlet UILabel *lblWinnerName;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnRematch;
@property (weak, nonatomic) IBOutlet UIButton *btnAnalysis;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

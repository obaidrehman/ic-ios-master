//
//  CreateChalengeTimeCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 5/2/18.
//

#import <UIKit/UIKit.h>
@protocol CreateChalengeTimeDelegate<NSObject>

- (void) CreateChalengeTimeCell:(UITableViewCell *)cell button1Pressed:(UIButton *)btn;
- (void) CreateChalengeTimeCell:(UITableViewCell *)cell timeButtonPressed:(UIButton *)btn;
@end
@interface CreateChalengeTimeCell : UITableViewCell{
    BOOL isSliderMinuteSelected;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSliderMinutes;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *btnCustom;
@property (weak, nonatomic) IBOutlet UIView *customTimeView;
@property (weak, nonatomic) IBOutlet UIButton *btnSliderSeconds;
@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@property (weak, nonatomic) IBOutlet UIStackView *stackView2;
@property (weak, nonatomic) IBOutlet UIStackView *stackView3;
@property (weak, nonatomic) IBOutlet UIStackView *stackView4;
@property (weak, nonatomic) IBOutlet UIStackView *stackView5;



@property (nonatomic, assign) id<CreateChalengeTimeDelegate> delegate;
@end

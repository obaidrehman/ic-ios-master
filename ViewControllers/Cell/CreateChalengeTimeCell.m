//
//  CreateChalengeTimeCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 5/2/18.
//

#import "CreateChalengeTimeCell.h"
@implementation CreateChalengeTimeCell{
    UIColor *selectedColor;
    UIColor *unselectedColor;
}
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    selectedColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1];
    unselectedColor = [UIColor colorWithRed:39.0/255.0 green:37.0/255.0 blue:34.0/255.0 alpha:1];
   // [self setTimButtonsColor:@"5 min"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)actionCustomButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CreateChalengeTimeCell:button1Pressed:)]) {
        [self.delegate CreateChalengeTimeCell:self button1Pressed:self.btnCustom];
    }
    isSliderMinuteSelected = true;
}
- (IBAction)actionLiveTimeBtn:(UIButton *)sender {
    [self.btnTime setTitle:sender.titleLabel.text forState:normal];
    [self setTimButtonsColor:sender.titleLabel.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CreateChalengeTimeCell:timeButtonPressed:)]) {
        [self.delegate CreateChalengeTimeCell:self timeButtonPressed:self.btnTime];
    }
   
}

- (IBAction)actionSliderValueChanged:(id)sender {
     int myInt = [[NSNumber numberWithFloat:self.slider.value*60] intValue];
    if (isSliderMinuteSelected) {
        NSString *value = [NSString stringWithFormat:@"%i", myInt];
        [self.btnSliderMinutes setTitle:value forState:normal];
    }else{
        NSString *value = [NSString stringWithFormat:@"%i", myInt];
        [self.btnSliderSeconds setTitle:value forState:normal];
    }
    NSString *title = [NSString stringWithFormat:@"%@ | %@", _btnSliderMinutes.titleLabel.text,_btnSliderSeconds.titleLabel.text];
    [self.btnTime setTitle:title forState:normal];
    //NSLog(@"%i",myInt);
}

- (IBAction)actionTimeBtnClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CreateChalengeTimeCell:timeButtonPressed:)]) {
        [self.delegate CreateChalengeTimeCell:self timeButtonPressed:self.btnTime];
    }
    [self setTimButtonsColor:@"5 min"];
}

- (IBAction)actionCustomMinuteAndSecBtn:(UIButton *)sender {
    if (sender == _btnSliderMinutes){
        _btnSliderMinutes.backgroundColor = selectedColor;
        _btnSliderSeconds.backgroundColor = unselectedColor;
        isSliderMinuteSelected = true;
    }else{
        _btnSliderMinutes.backgroundColor = unselectedColor;
        _btnSliderSeconds.backgroundColor = selectedColor;
        isSliderMinuteSelected = false;
        self.slider.value = 0.0;
    }
}

-(void)setTimButtonsColor:(NSString *)buttonTitle{
    NSArray *arrBtns;
    arrBtns = [NSArray arrayWithObjects:
               self.stackView1.subviews[0],
               self.stackView1.subviews[1],
               self.stackView1.subviews[2],
               self.stackView2.subviews[0],
               self.stackView2.subviews[1],
               self.stackView2.subviews[2],
               self.stackView3.subviews[0],
               self.stackView3.subviews[1],
               self.stackView3.subviews[2],
               self.stackView4.subviews[0],
               self.stackView4.subviews[1],
               self.stackView4.subviews[2],
               self.stackView5.subviews[0],
               self.stackView5.subviews[1],
               self.stackView5.subviews[2], nil];
    
    for (int i=0; i<arrBtns.count; i++) {
        UIButton *button = (UIButton *)arrBtns[i];
        
        NSString *stackButtonTitle = button.titleLabel.text;
        if ([buttonTitle isEqualToString:stackButtonTitle] ) {
            button.backgroundColor = selectedColor;//[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1];
            //if ([stackButtonTitle containsString:@"day"]){
//         /       [self actionTimeBtnClicked:nil];
          //  }
        }else{
            button.backgroundColor = unselectedColor;//[UIColor colorWithRed:39.0/255.0 green:37.0/255.0 blue:34.0/255.0 alpha:1];
        }
        
        //button.backgroundColor = [UIColor brownColor];
    }
    
    
}
@end

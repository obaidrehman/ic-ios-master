//
//  NewGameTypeButtonCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 4/10/18.
//

#import "NewGameTypeButtonCell.h"

@implementation NewGameTypeButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    _btnPlay.layer.cornerRadius = 5;
    _btnPlay.layer.masksToBounds = true;
    _btnTime.layer.cornerRadius = 5;
    _btnTime.layer.masksToBounds = true;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

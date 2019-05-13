//
//  ProfileViewCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/27/18.
//

#import "ProfileViewCell.h"

@implementation ProfileViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    [_btnInviteYrFrnds.layer setCornerRadius:5];
    [_btnInviteYrFrnds setClipsToBounds:true];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

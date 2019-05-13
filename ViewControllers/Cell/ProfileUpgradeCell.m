//
//  ProfileUpgradeCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/27/18.
//

#import "ProfileUpgradeCell.h"

@implementation ProfileUpgradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [_btnUpgrade.layer setCornerRadius:3];
    [_btnRestorePurchase.layer setCornerRadius:3];
    [_btnRestorePurchase setClipsToBounds:true];
    [_btnUpgrade setClipsToBounds:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

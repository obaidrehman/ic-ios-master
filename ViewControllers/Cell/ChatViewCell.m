//
//  ChatViewCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/5/18.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_messageView.layer setCornerRadius:5];
    [_messageView setClipsToBounds:true];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

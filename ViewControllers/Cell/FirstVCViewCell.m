//
//  FirstVCViewCell.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/13/18.
//

#import "FirstVCViewCell.h"
#import "UIImage+animatedGIF.h"
@implementation FirstVCViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.imgTitle
    // Initialization code
}

-(void)setImgTitleGif{
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ChessBoard" withExtension:@"gif"];
//        self.imgTitle.image= [UIImage animatedImageWithAnimatedGIFURL:url];
//        
//    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

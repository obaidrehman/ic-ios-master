//
//  FirstVCViewCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/13/18.
//

#import <UIKit/UIKit.h>

@interface FirstVCViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblGameType;
@property (weak, nonatomic) IBOutlet UIImageView *imgGameType;
@property (weak, nonatomic) IBOutlet UIView *disableView;
-(void)setImgTitleGif;
@end

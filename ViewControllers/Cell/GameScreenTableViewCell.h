//
//  GameScreenTableViewCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 4/20/18.
//

#import <UIKit/UIKit.h>

@interface GameScreenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblWhiteUser;
@property (weak, nonatomic) IBOutlet UILabel *lblWhiteFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblBlackUser;
@property (weak, nonatomic) IBOutlet UILabel *lblBlackFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;


@end

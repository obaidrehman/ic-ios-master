//
//  ChatViewCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/5/18.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

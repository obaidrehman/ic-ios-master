//
//  ProfileViewCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/27/18.
//

#import <UIKit/UIKit.h>

@interface ProfileViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnInviteYrFrnds;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblTermsAndCondition;
@property (weak, nonatomic) IBOutlet UITextField *txtDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;


@end

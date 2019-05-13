//
//  CountryListCell.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 8/1/18.
//

#import <UIKit/UIKit.h>

@interface CountryListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCountryFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedCountryImage;

@end

//
//  CountryListController.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 8/1/18.
//

#import <UIKit/UIKit.h>
@protocol countrySelectedDelegate <NSObject>
@optional
-(void)getSelectedCountry:(NSString *)country;
@end
@interface CountryListController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *selectedCountry;
@property (nonatomic, weak) id <countrySelectedDelegate> delegate;

@end

//
//  MyManager.h
//  InfinityChess2018
//
//  Created by Manoj Kumar on 3/28/18.
//

@class FirstVC;

#import <Foundation/Foundation.h>
#import "SideMenuViewController.h"


@interface MyManager : NSObject {
    NSString *someProperty;
    CGRect *deviceScreenSize;
    BOOL isGameDismiss;
}

@property (nonatomic, readwrite) CGRect *deviceScreenSize;
@property (nonatomic, readwrite) UIImage *userImage;
@property (nonatomic, readwrite) NSString *boardColor;
@property  (nonatomic, readwrite) SideMenuViewController *sideMenuController;
@property  (nonatomic, strong) FirstVC *firVC;
//@property  (nonatomic, readwrite) FirstVC *firstVC;
//@property (strong)  AppOnline* againLoginAppOnline;
@property int isPlayerWhite;
+ (id)sharedManager;
- (void)showHUDWithTransform:(NSString *)message forView:(UIView *)view;
- (void)removeHud;
- (void)setScreenSize:(CGRect *)size;
-(NSArray *)getAllCountryList;
-(NSString *)getFlagOfTheCountry:(NSString *)country;
-(NSString *)getCountryNameByCountryIndex:(NSInteger)ctryInd;
-(NSString *)getCountryNameByCode:(NSString *)countryCode;
-(void)loadImages:(NSNumber *)userId :(UIImageView *)imgView;
- (void)starAnimationWithTableView:(UITableView *)tableView :(int )index;
@end

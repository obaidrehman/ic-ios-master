//
//  ThemeTemplate.h
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardView.h"
#import "MoveListView.h"


/// @description this is the default theme number
enum AppThemeE
{
    themeAllIsBlack = 0,
    themeAllIsWhite = 1,
    themeDefault    = 2,
    themeRainbow    = 3,
    themeGlassLand       = 4,
    themeMetroLastLight  = 5,
    themeAngelsAndDemons = 6,
    /// the color used are
    /// for Black  = dimgray = #696969 (RGB:105 for all) with 100% alpha
    /// for Yellow =         =
    themeBlackAndYellow  = 7,
    themeTheDarkKnight   = 8,
};


@interface AppThemes : NSObject

@property int currentTheme;

- (void)MainMenuBackGround:(UIView*)view;
- (void)PlayOfflineBackground:(UIView*)view;
- (void)PlayOnlineBackGround:(UIView*)view;
- (void)AboutInfinityChessBackground:(UIView*)view;
- (void)OptionsBackground:(UIView*)view;

- (void)DefaultBackground:(UIView*)view;
- (void)DefaultButton:(UIButton*)button;
- (void)DefaultLabel:(UILabel*)label;
- (void)DefaultTextField:(UITextField*)textField;


// theme apply methods!
- (void)ThemeBackGround:(UIView*)view IsOptional:(BOOL)optional;
- (void)ThemeButton:(UIButton*)button;
- (void)ThemeLabel:(UILabel*)label;
- (void)ThemeTextField:(UITextField*)textField;


// stockfish theme default
- (void)StockfishContentView:(UIView*)view;
- (void)StockfishBoardView:(BoardView*)board;
- (void)StockfishClockView:(UILabel*)label;
- (void)StockfishMoveListView:(MoveListView*)moveList;
- (void)StockfishBookMovesView:(UILabel*)label;
- (void)StockfishAnalysisView:(UILabel*)label;
- (void)StockfishSearchStatsView:(UILabel*)label;
- (void)StockfishToolBar:(UIToolbar*)toolBar;
- (void)StockfishBarButton:(UIBarButtonItem*)barButton;
- (void)StockfishActivityIndicator:(UIActivityIndicatorView*)activityIndicator;



// here lies theme Black & Yellow, plz dont spoil the code!
- (void)BackGroundBlackAndYellow:(UIView*)view IsOptional:(BOOL)optional;
- (void)ButtonBlackAndYellow:(UIButton*)button;
- (void)LabelBlackAndYellow:(UILabel*)label;
- (void)TextFieldBlackAndYellow:(UITextField*)textField;

// here lies theme Angles & Demons, plz dont spoil the code!
- (void)BackGroundAngelsAndDemons:(UIView*)view IsOptional:(BOOL)optional;
- (void)ButtonAngelsAndDemons:(UIButton*)button;
- (void)LabelAngelsAndDemons:(UILabel*)label;
- (void)TextFieldAngelsAndDemons:(UITextField*)textField;

// here lies theme Metro Last Light, plz dont spoil the code!
- (void)BackGroundMetroLastLight:(UIView*)view IsOptional:(BOOL)optional;
- (void)ButtonMetroLastLight:(UIButton*)button;
- (void)LabelMetroLastLight:(UILabel*)label;
- (void)TextFieldMetroLastLight:(UITextField*)textField;

// here lies theme Glass Land, plz dont spoil the code!
- (void)BackGroundGlassLand:(UIView*)view IsOptional:(BOOL)optional;
- (void)ButtonGlassLand:(UIButton*)button;
- (void)LabelGlassLand:(UILabel*)label;
- (void)TextFieldGlassLand:(UITextField*)textField;

// here lies theme The Dark Knight, plz dont spoil the code!
- (void)BackGroundTheDarkKnight:(UIView*)view IsOptional:(BOOL)optional;
- (void)ButtonTheDarkKnight:(UIButton*)button;
- (void)LabelTheDarkKnight:(UILabel*)label;
- (void)TextFieldTheDarkKnight:(UITextField*)textField;



@end


// image effects
@interface UIView (ImageEffects)

-(UIImage *)convertViewToImage;

@end

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
//- (UIImage *)applyMakkajaiBlurEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end


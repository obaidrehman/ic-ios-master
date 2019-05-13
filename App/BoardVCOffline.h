/*
 Stockfish, a chess program for iOS.
 Copyright (C) 2004-2014 Tord Romstad, Marco Costalba, Joona Kiiski.
 
 Stockfish is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Stockfish is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>


#import "BoardView.h"
#import "RootView.h"

@class GameController;
@class MoveListView;
@class BaseVC;

@interface BoardVCOffline : UIViewController <UIActionSheetDelegate> {
    
    UILabel *gameInfo;
    
    RootView *rootView;
    UIView *contentView;
    UILabel *analysisView;
    UILabel *bookMovesView;
    BoardView *boardView;
    UILabel *whiteClockView, *blackClockView;
    UILabel *searchStatsView;
    MoveListView *moveListView;
    GameController *__weak gameController;
    UINavigationController *navigationController;
    UIActivityIndicatorView *activityIndicator;
    UIActionSheet *gameMenu, *newGameMenu, *moveMenu;
    UIBarButtonItem *gameButton, *optionsButton, *moveButton;
    UIPopoverController *optionsMenu, *saveMenu, *emailMenu, *levelsMenu, *loadMenu, *moveListMenu;
    UIPopoverController *popoverMenu;
    UIToolbar *toolbar;
    CGRect iPadBoardRectLandscape, iPadBoardRectPortrait,
    iPadWhiteClockRectPortrait, iPadWhiteClockRectLandscape,
    iPadBlackClockRectPortrait, iPadBlackClockRectLandscape,
    iPadMoveListRectPortrait, iPadMoveListRectLandscape,
    iPadAnalysisRectPortrait, iPadAnalysisRectLandscape,
    iPadSearchStatsRectPortrait, iPadSearchStatsRectLandscape,
    iPadBookRectLandscape, iPadBookRectPortrait;
}


@property (weak, nonatomic) BaseVC *basevc;


@property (nonatomic, readonly) UILabel *analysisView;
@property (nonatomic, readonly) UILabel *bookMovesView;
@property (nonatomic, readonly) BoardView *boardView;
@property (nonatomic, readonly) UILabel *whiteClockView;
@property (nonatomic, readonly) UILabel *blackClockView;
@property (nonatomic, readonly) MoveListView *moveListView;
@property (nonatomic, readonly) UILabel *searchStatsView;
@property (nonatomic, weak) GameController *gameController;



/// @description this refer to the frame size in which the app should load
@property CGRect appFrame;
/// @description this is a reference that determine if board is in offline or online mode
@property BOOL isOfflinePlay;
@property (nonatomic, readonly) UILabel *gameInfo;


- (void)SetGameInfo:(NSString*)info;

- (void)toolbarButtonPressed:(id)sender;
- (void)showOptionsMenu;
- (void)optionsMenuDonePressed;
- (void)showLevelsMenu;
- (void)levelWasChanged;
- (void)gameModeWasChanged;
- (void)levelsMenuDonePressed;
- (void)editPosition;
- (void)editPositionCancelPressed;
- (void)editPositionDonePressed:(NSString *)fen;
- (void)showSaveGameMenu;
- (void)saveMenuDonePressed;
- (void)saveMenuCancelPressed;
- (void)showLoadGameMenu;
- (void)moveListMenuDonePressed:(int)ply;
- (void)moveListMenuCancelPressed;
- (void)loadMenuCancelPressed;
- (void)loadMenuDonePressedWithGame:(NSString *)gameString;
- (void)showEmailGameMenu;
- (void)emailMenuDonePressed;
- (void)emailMenuCancelPressed;
- (void)stopActivityIndicator;
- (void)hideAnalysis;
- (void)hideBookMoves;
- (void)showBookMoves;
- (void)showMoveListMenu;

/// @description subscribe Stockfish PlayOffline Notification
- (void)SubscribeToStockfishPlayOfflineNotifications:(id)subscriber;
/// @description unsubscribe to stockfish playoffline notifications
- (void)UnsubscribeToStockfishPlayOfflineNotifications:(id)subscriber;








@property (strong, nonatomic) IBOutlet UIView *customViewOnTop;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *movesView;
@property (weak, nonatomic) IBOutlet UIView *theAnalysisView;
@property (weak, nonatomic) IBOutlet UIView *playerView1;
@property (weak, nonatomic) IBOutlet UIView *chessBoardView;
@property (weak, nonatomic) IBOutlet UIView *playerView2;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//


- (IBAction)topBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *compImgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *computerLevelLbl;
- (IBAction)settingsBtnAction:(id)sender;
- (IBAction)bottomBtnAction:(id)sender;
- (IBAction)bottomCompBtnAction:(id)sender;
- (IBAction)backMoveBtnAction:(id)sender;
- (IBAction)fwdMoveBtnAction:(id)sender;

-(void)newGamePlayAsWhite;



@end


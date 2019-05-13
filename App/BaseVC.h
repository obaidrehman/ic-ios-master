// BaseVC.h
// Stockfish
//
// Created by Shehzar on 1/16/18.
//

#import <UIKit/UIKit.h>

#import "BoardVCOffline.h"
#import "GameController.h"

@class GameOptionsViewController;


@interface BaseVC : UIViewController {
    BoardVCOffline *viewController;
    GameController *gameController;
    
    UINavigationController *navigationController;
    
    GameOptionsViewController *ovc;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) BoardVCOffline *viewController;
@property (nonatomic, readonly) GameController *gameController;

@property BOOL isNewGame;
@property BOOL isPlayer2Player;


- (void)backgroundInit:(id)anObject;
- (void)backgroundInitFinished:(id)anObject;

-(void)showOptions;
-(void)hideOptions;
-(void)showboard;
-(void)hideBoard;

-(void)setComputerlevelLblTextOnBoardVC:(NSString*)text;

- (void)saveState;

-(void)showHideAnalysis:(BOOL)flag;

@end


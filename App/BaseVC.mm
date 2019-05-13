
// BaseVC.m
// Stockfish
//
// Created by Shehzar on 1/16/18.
//

#import "BaseVC.h"
#import "ECO.h"
#import "MoveListView.h"
#import "Options.h"
#import "MyManager.h"
#include "GameOptionsViewController.h"

#include "../Chess/mersenne.h"
#include "../Chess/movepick.h"

@interface BaseVC (){
    
}

@property (weak, nonatomic) IBOutlet UIStackView *boardVCStackView;
@property (weak, nonatomic) IBOutlet UIView *boardVCContainerView;

@property (weak, nonatomic) IBOutlet UIStackView *optionsVCStackView;
@property (weak, nonatomic) IBOutlet UIView *optionsVCHeaderView;
@property (weak, nonatomic) IBOutlet UIView *optionsVCContainerView;
@property (weak, nonatomic) IBOutlet UIView *optionsVCApplyButtonView;

@end

@implementation BaseVC

@synthesize viewController, gameController;


-(void)awakeFromNib {
    [super awakeFromNib];
     self.isPlayer2Player = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    NSLog(@"loadPreviousGame %d", self.isNewGame);
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
 
    UIView *optionsView;
    UIView *boardView;
    
    viewController = [[BoardVCOffline alloc] init];
    viewController.basevc = self;
    [self addChildViewController:viewController];
    [viewController loadView];
    boardView = viewController.view;
    [self.boardVCContainerView addSubview:boardView];
    [self performSelectorInBackground: @selector(backgroundInit:) withObject: nil];
    boardView.frame = self.boardVCContainerView.bounds;
    boardView.translatesAutoresizingMaskIntoConstraints = false;
    [boardView.centerXAnchor constraintEqualToAnchor:self.boardVCContainerView.centerXAnchor].active = YES;
    [boardView.centerYAnchor constraintEqualToAnchor:self.boardVCContainerView.centerYAnchor].active = YES;
    [boardView.heightAnchor constraintEqualToAnchor:self.boardVCContainerView.heightAnchor].active = YES;
    [boardView.widthAnchor constraintEqualToAnchor:self.boardVCContainerView.widthAnchor].active = YES;
    
    
    
    ovc = [[GameOptionsViewController alloc]initWithBoardVCOffline:viewController];
    ovc.basevc = self;
    [self addChildViewController:ovc];
    optionsView = ovc.view;
    [self.optionsVCContainerView addSubview:optionsView];
    
    optionsView.frame = self.optionsVCContainerView.bounds;
    optionsView.translatesAutoresizingMaskIntoConstraints = false;
    [optionsView.centerXAnchor constraintEqualToAnchor:self.optionsVCContainerView.centerXAnchor].active = YES;
    [optionsView.centerYAnchor constraintEqualToAnchor:self.optionsVCContainerView.centerYAnchor].active = YES;
    [optionsView.heightAnchor constraintEqualToAnchor:self.optionsVCContainerView.heightAnchor].active = YES;
    [optionsView.widthAnchor constraintEqualToAnchor:self.optionsVCContainerView.widthAnchor].active = YES;
    
    [ovc didMoveToParentViewController:self];
    
    NSLog(@"");
    
    if(!self.isNewGame){
        [self hideOptions];
    } else {
        [self showOptions];
    }
    
    [[Options sharedOptions] setMoveSound: YES];
    
    // view1.translatesAutoresizingMaskIntoConstraints = false
    //
    // //Constraints
    // let centerXConstraint = view1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
    // let centerYConstraint = view1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
    // let widthConstraint = view1.widthAnchor.constraint(equalToConstant: 100)
    // let heightConstraint = view1.heightAnchor.constraint(equalToConstant: 100)
    //
    // //Apply constraints
    // constraintToApply.append(centerXConstraint)
    // constraintToApply.append(centerYConstraint)
    // constraintToApply.append(widthConstraint)
    // constraintToApply.append(heightConstraint)
    
    
    // boardView.translatesAutoresizingMaskIntoConstraints = false;
    // [boardView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    // [boardView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    // [boardView.heightAnchor constraintEqualToAnchor:self.boardVCContainerView.heightAnchor].active = YES;
    // [boardView.widthAnchor constraintEqualToAnchor:self.boardVCContainerView.widthAnchor].active = YES;
    
    
    // optionsView.translatesAutoresizingMaskIntoConstraints = false;
    // [optionsView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    // [optionsView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    // [optionsView.heightAnchor constraintEqualToAnchor:self.optionsVCContainerView.heightAnchor].active = YES;
    // [optionsView.widthAnchor constraintEqualToAnchor:self.optionsVCContainerView.widthAnchor].active = YES;
    
    
    //[viewController didMoveToParentViewController:self];
    //[ovc didMoveToParentViewController:self];
    
    // UIView *v = [[UIView alloc]init];//WithFrame:CGRectMake(0, 0, 100, 100)];
    // v.backgroundColor = [UIColor blueColor];
    //
    // [self.optionsVCContainerView addSubview:v];
    //
    // v.translatesAutoresizingMaskIntoConstraints = false;
    // [v.centerXAnchor constraintEqualToAnchor:self.optionsVCContainerView.centerXAnchor].active = YES;
    // [v.centerYAnchor constraintEqualToAnchor:self.optionsVCContainerView.centerYAnchor].active = YES;
    // [v.heightAnchor constraintEqualToAnchor:self.optionsVCContainerView.heightAnchor].active = YES;
    // [v.widthAnchor constraintEqualToAnchor:self.optionsVCContainerView.widthAnchor].active = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.optionsVCContainerView setNeedsLayout];
    [self.optionsVCContainerView layoutIfNeeded];
    
    NSString *boardTheme = [[NSUserDefaults standardUserDefaults] valueForKey:@"boardTheme"];
    if ([boardTheme isEqualToString:@""] || boardTheme == nil){
        [[Options sharedOptions] setValue: [[MyManager sharedManager] boardColor] forKey: @"colorScheme"];
    }else{
        [[Options sharedOptions] setValue: boardTheme forKey: @"colorScheme"];
    }
    
    NSLog(@"");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveState {
    // Save the current game, level and game mode so we can recover it the next
    // time the program starts up:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[gameController game] pgnString]
                 forKey: @"lastGame"];
    [defaults setInteger: ((int)[[Options sharedOptions] gameLevel] + 1)
                  forKey: @"gameLevel"];
    [defaults setInteger: ((int)[[Options sharedOptions] gameMode] + 1)
                  forKey: @"gameMode"];
    [defaults setInteger: [[[gameController game] clock] whiteRemainingTime] + 1
                  forKey: @"whiteRemainingTime"];
    [defaults setInteger: [[[gameController game] clock] blackRemainingTime] + 1
                  forKey: @"blackRemainingTime"];
    [defaults setBool: [gameController rotated]
               forKey: @"rotateBoard"];
    [defaults setInteger: [[gameController game] currentMoveIndex]
                  forKey: @"currentMoveIndex"];
    [defaults synchronize];
}

- (void)backgroundInit:(id)anObject {
    @autoreleasepool {
        
        gameController =
        [[GameController alloc] initWithBoardView: [viewController boardView]
                                     moveListView: [viewController moveListView]
                                     analysisView: [viewController analysisView]
                                    bookMovesView: [viewController bookMovesView]
                                   whiteClockView: [viewController whiteClockView]
                                   blackClockView: [viewController blackClockView]
                                  searchStatsView: [viewController searchStatsView]];
        
        /* Chess init */
        init_mersenne();
        init_direction_table();
        init_bitboards();
        Position::init_zobrist();
        Position::init_piece_square_tables();
        MovePicker::init_phase_table();
        
        // Make random number generation less deterministic, for book moves
        int i = abs(get_system_time() % 10000);
        for (int j = 0; j < i; j++)
            genrand_int32();
        
        [gameController loadPieceImages];
        
        [self performSelectorOnMainThread: @selector(backgroundInitFinished:) withObject: nil waitUntilDone: NO];
        
    }
}


- (void)backgroundInitFinished:(id)anObject {
    
    [gameController showPiecesAnimate: NO];
    [viewController stopActivityIndicator];
    
    [viewController setGameController: gameController];
    [[viewController boardView] setGameController: gameController];
    [[viewController moveListView] setGameController: gameController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastGamePGNString = [defaults objectForKey: @"lastGame"];
    if (lastGamePGNString) {
        [gameController gameFromPGNString: lastGamePGNString
                        loadFromBeginning: NO];
        int currentMoveIndex = (int)[defaults integerForKey: @"currentMoveIndex"];
        [gameController jumpToPly: currentMoveIndex animate: NO];
    }
    else
        [gameController
         gameFromFEN: @"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"];
    
    NSInteger gameLevel = [defaults integerForKey: @"gameLevel"];
    if (gameLevel) {
        [[Options sharedOptions] setGameLevel: (GameLevel)((int)gameLevel - 1)];
        [gameController setGameLevel: [[Options sharedOptions] gameLevel]];
    }
    
    NSInteger whiteRemainingTime = [defaults integerForKey: @"whiteRemainingTime"];
    NSInteger blackRemainingTime = [defaults integerForKey: @"blackRemainingTime"];
    ChessClock *clock = [[gameController game] clock];
    if (whiteRemainingTime)
        [clock addTimeForWhite: ((int)whiteRemainingTime - [clock whiteRemainingTime])];
    if (blackRemainingTime)
        [clock addTimeForBlack: ((int)blackRemainingTime - [clock blackRemainingTime])];
    
    if ([defaults objectForKey: @"rotateBoard"])
        [gameController rotateBoard: [defaults boolForKey: @"rotateBoard"] animate: NO];
    
    
//    if(self.isPlayer2Player){
//        [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
//        [gameController setGameMode: GAME_MODE_TWO_PLAYER];
//        [gameController startNewGame];
//        [self.viewController.chessBoardView setUserInteractionEnabled:false];
//    } else {
//        NSInteger gameMode = [defaults integerForKey: @"gameMode"];
//        if (gameMode) {
//            [[Options sharedOptions] setGameMode: (GameMode)(gameMode - 1)];
//            [gameController setGameMode: [[Options sharedOptions] gameMode]];
//            if(self.isNewGame)
//                [gameController startNewGame];
//        }
//    }
    NSInteger gameMode = [defaults integerForKey: @"gameMode"];
    if (gameMode) {
        // [[Options sharedOptions] setGameMode: (GameMode)(gameMode - 1)];
        // [gameController setGameMode: [[Options sharedOptions] gameMode]];
        [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
        [gameController setGameMode: GAME_MODE_COMPUTER_BLACK];
        if(self.isNewGame)
            [gameController startNewGame];
    }
    // }
    
    
    [gameController startEngine];
    [gameController showBookMoves];
    //ye to comment krne wali chz hai crash maregi
    //[gameController checkPasteboard];
    

}

-(void)showOptions {
    self.optionsVCContainerView.hidden = NO;
}
-(void)hideOptions {
    self.optionsVCContainerView.hidden = YES;
}
-(void)showboard {
    self.boardVCContainerView.hidden = NO;
}
-(void)hideBoard {
    self.boardVCContainerView.hidden = YES;
}

-(void)setComputerlevelLblTextOnBoardVC:(NSString*)text{
    [[viewController computerLevelLbl]setText:[NSString stringWithFormat:@"Computer (Level %@)", text]];
    //return [ovc mrOVCTellMeStrength];
}

-(void)showHideAnalysis:(BOOL)flag {
    [ovc CR_showAnalysis:flag];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

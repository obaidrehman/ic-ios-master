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

#import "AppDelegateStockfish.h"
#import "ECO.h"
#import "MoveListView.h"
#import "Options.h"
#import "MyManager.h"
#include "../Chess/mersenne.h"
#include "../Chess/movepick.h"

using namespace Chess;

@interface AppDelegateStockfish()

@property (strong) volatile AppOnline *appOnline;

/// @description helpers for inifinty chess to stockfish squares
@property (strong,readonly) NSArray *moveSquaresICtoSF;
/// @description helpers for infinity chess to stockfish promotion pieces
@property (strong, readonly) NSArray *movePromotionPiecesICtoSF;

@end

@implementation AppDelegateStockfish
{
    NSTimer *aTimer;
}


@synthesize viewController, gameController;

- (NSArray *)moveSquaresICtoSF
{
    return @[
        @"a1", @"b1", @"c1", @"d1", @"e1", @"f1", @"g1", @"h1",
        @"a2", @"b2", @"c2", @"d2", @"e2", @"f2", @"g2", @"h2",
        @"a3", @"b3", @"c3", @"d3", @"e3", @"f3", @"g3", @"h3",
        @"a4", @"b4", @"c4", @"d4", @"e4", @"f4", @"g4", @"h4",
        @"a5", @"b5", @"c5", @"d5", @"e5", @"f5", @"g5", @"h5",
        @"a6", @"b6", @"c6", @"d6", @"e6", @"f6", @"g6", @"h6",
        @"a7", @"b7", @"c7", @"d7", @"e7", @"f7", @"g7", @"h7",
        @"a8", @"b8", @"c8", @"d8", @"e8", @"f8", @"g8", @"h8",
        @"none"
        ];
}

- (NSArray *)movePromotionPiecesICtoSF
{
    return @[
              [NSString Empty], @"P", @"N", @"B", @"R", @"Q", @"K",
             ];
}

- (id)initAndLoadStockfishInViewPlayerToPlayer:(UIView *)view ForOfflinePlay:(BOOL)isOfflinePlay AppOnlineReference:(volatile AppOnline *) appOnline:(BOOL)isPlayerWhite
{
    self = [super init];
    if (self)
    {
        // assign ref to apponline first
        if (!isOfflinePlay)
            if (appOnline)
                self.appOnline = appOnline;
        
        // set reference to view that will hold stockfish
        //self.viewStockfish = view;
        self.isOfflineStockfish = isOfflinePlay;
        self.isPlayerToPlayer = !isOfflinePlay;
        self.isWhitePlayer = isPlayerWhite;
        // init board view controller and assign parent view size so that it can be scaled accordingly
        viewController = [[BoardViewController alloc] init];
        CGRect screenFrame = [[UIScreen mainScreen]bounds];
        viewController.appFrame =  CGRectMake(0, 0, view.frame.size.width, view.frame.size.height); //
        // assign the frame to which stockfish should resize and adjust
        NSLog(@"--#############################################",viewController.appFrame);
        viewController.isOfflinePlay = self.isOfflineStockfish;     // assign of launch so, in online some not all stockfish options are available
        [viewController loadView];
        [self hideShowLabelsoFPlayers:YES];
        viewController.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
        [self.viewStockfish addSubview: [viewController view]];
        
        //        [self performSelectorInBackground: @selector(backgroundInit:) withObject: nil];
//        [[NSNotificationCenter defaultCenter] addObserver: self
//                                                 selector: @selector(getCurrentGameResponseUpdate:)
//                                                     name: @"getCurrentGameResponseUpdate"
//                                                   object: nil];
        
    }
    
    return self;
}



- (id)initAndLoadStockfishInView:(UIView *)view ForOfflinePlay:(BOOL)isOfflinePlay AppOnlineReference:(volatile AppOnline *) appOnline
{
    self = [super init];
    if (self)
    {
        // assign ref to apponline first
        if (!isOfflinePlay)
            if (appOnline)
                self.appOnline = appOnline;
        
        // set reference to view that will hold stockfish
        //self.viewStockfish = view;
        self.isOfflineStockfish = isOfflinePlay;
                 
        // init board view controller and assign parent view size so that it can be scaled accordingly
        viewController = [[BoardViewController alloc] init];
        CGRect screenFrame = [[UIScreen mainScreen]bounds];
        viewController.appFrame =  CGRectMake(0, 0, view.frame.size.width, view.frame.size.height); //
        // assign the frame to which stockfish should resize and adjust
        NSLog(@"--#############################################",viewController.appFrame);
        viewController.isOfflinePlay = self.isOfflineStockfish;     // assign mode of launch so, in online some not all stockfish options are available
        [viewController loadView];
        viewController.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
        
        [self.viewStockfish addSubview: [viewController view]];
        
//        [self performSelectorInBackground: @selector(backgroundInit:) withObject: nil];
    }
    return self;
}

-(void)hideShowLabelsoFPlayers:(BOOL)value {
    [[viewController whiteStackView] setHidden:value];
    [[viewController compStackView] setHidden:value];

}

-(UIView*)abcd {
    return viewController.view;
}

-(void)xyz {
    [self hideShowLabelsoFPlayers:false];
    [self performSelectorInBackground: @selector(backgroundInit:) withObject: nil];
}

- (void)DeInitStockfish
{
    if (gameController)
    {
        [self saveState];
        gameController = nil;
    }
    if (viewController)
    {
        [viewController.view removeFromSuperview];
        [viewController dismissViewControllerAnimated: NO completion: nil];
        viewController = nil;
    }
    self.viewStockfish = nil;
}

- (void)SubscribeToStockfishPlayOfflineNotifications:(id)subscriber
{
    if (viewController)
        [viewController SubscribeToStockfishPlayOfflineNotifications:subscriber];
}
- (void)UnsubscribeToStockfishPlayOfflineNotifications:(id)subscriber
{
    if (viewController)
        [viewController UnsubscribeToStockfishPlayOfflineNotifications:subscriber];
}


- (BOOL)application :(UIApplication *)application
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
   window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

   viewController = [[BoardViewController alloc] init];
   [viewController loadView];
   [window addSubview: [viewController view]];
   [window setRootViewController: viewController];
   [window makeKeyAndVisible];

   [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

   [self performSelectorInBackground: @selector(backgroundInit:)
                          withObject: nil];
      */
   return YES;
}


- (void)saveState
{
    // Save the current game, level and game mode so we can recover it the next
    // time the program starts up:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[gameController game] pgnString] forKey: @"lastGame"];
    [defaults setInteger: ((int)[[Options sharedOptions] gameLevel] + 1) forKey: @"gameLevel"];
    [defaults setInteger: ((int)[[Options sharedOptions] gameMode] + 1) forKey: @"gameMode"];
    [defaults setInteger: ([[[gameController game] clock] whiteRemainingTime] + 1) forKey: @"whiteRemainingTime"];
    [defaults setInteger: ([[[gameController game] clock] blackRemainingTime] + 1) forKey: @"blackRemainingTime"];
    [defaults setBool: [gameController rotated] forKey: @"rotateBoard"];
    [defaults setInteger: [[gameController game] currentMoveIndex] forKey: @"currentMoveIndex"];
    [defaults synchronize];
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
   NSString *homeDir = NSSearchPathForDirectoriesInDomains(
         NSDocumentDirectory, NSUserDomainMask, YES)[0];
   NSString *fileName = [url.absoluteString componentsSeparatedByString:@"/"].lastObject;
   NSURL *url2 = [NSURL fileURLWithPath: [homeDir stringByAppendingPathComponent: fileName]];
   [[NSFileManager defaultManager] moveItemAtURL:url toURL:url2 error:NULL];

   [[Options sharedOptions] setLoadGameFile: [url2 absoluteString]];
   [[Options sharedOptions] setLoadGameFileGameNumber:NSIntegerMax]; // HACK
   [viewController showLoadGameMenu];
   return YES;
}

- (void)backgroundInit:(id)anObject
{
    @autoreleasepool
    {
        gameController = [[GameController alloc] initWithBoardView: [viewController boardView]
                                                      moveListView: [viewController moveListView]
                                                      analysisView: [viewController analysisView]
                                                     bookMovesView: [viewController bookMovesView]
                                                    whiteClockView: [viewController lblTimeWhite]
                                                    blackClockView: [viewController lblTimeBlack]
                                                   searchStatsView: [viewController searchStatsView]
                                                    scoreview:[viewController lblScore]];
        
        gameController.isOfflinePlay = self.isOfflineStockfish; // assign game launch mode

        /* Chess init */
        init_mersenne();
        init_direction_table();
        init_bitboards();
        Position::init_zobrist();
        Position::init_piece_square_tables();
        MovePicker::init_phase_table();
//8000 + 4500 + 3000 + 4000 + 2500 =
        // Make random number generation less deterministic, for book moves
        int i = abs(get_system_time() % 10000);
        for (int j = 0; j < i; j++)
            genrand_int32();

        [gameController loadPieceImages];
      
        [self performSelectorOnMainThread: @selector(backgroundInitFinished:)
                               withObject: nil
                            waitUntilDone: NO];
    }
}


- (void)backgroundInitFinished:(id)anObject
{
    [gameController showPiecesAnimate: NO];
    
    [viewController stopActivityIndicator];
    [viewController setGameController: gameController];
    [[viewController boardView] setGameController: gameController];
    [[viewController moveListView] setGameController: gameController];
    
    //MARK:- Player to Player
    if (_isPlayerToPlayer){
        [gameController gameFromFEN: @"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"];
      //  GAME_MODE_TWO_PLAYER
        //[gameController setGameMode:GAME_MODE_TWO_PLAYER];//
        //[[viewController chessBoardView] setUserInteractionEnabled:([[MyManager sharedManager] isPlayerWhite] == 1) ? true:false];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"new game (both)");
        [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
        [gameController setGameMode: GAME_MODE_TWO_PLAYER];
        [gameController startNewGame];
        self.appOnline.arrFenList = nil;
       // if ([[MyManager sharedManager] isPlayerWhite] == 1)
        //    [gameController rotateBoard: [defaults boolForKey: @"rotateBoard"] animate: NO];
       return;
    }
    
    
    if (self.isOfflineStockfish)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lastGamePGNString = [defaults objectForKey: @"lastGame"];
        
        if (lastGamePGNString)
        {
            [gameController gameFromPGNString: lastGamePGNString loadFromBeginning: NO];
            int currentMoveIndex = (int)[defaults integerForKey: @"currentMoveIndex"];
            [gameController jumpToPly: currentMoveIndex animate: NO];
        }
        else
            [gameController gameFromFEN: @"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"];

        NSInteger gameLevel = [defaults integerForKey: @"gameLevel"];
        if (gameLevel)
        {
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

        NSInteger gameMode = [defaults integerForKey: @"gameMode"];
        if (gameMode)
        {
            [[Options sharedOptions] setGameMode: (GameMode)(gameMode - 1)];
            [gameController setGameMode: [[Options sharedOptions] gameMode]];
        }

        //[gameController startEngine];
        [gameController showBookMoves];
        [gameController checkPasteboard];
    }
    else    // for online gameplay
    {
        [self SetOnlineGameForKibitzing];
    }
}

- (void)SetOnlineGameForKibitzing
{
    // todo? for online mode, kibitzing only for now!
    [gameController gameFromFEN: @"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"];
    [gameController setGameMode:GAME_MODE_KIBITZ];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: @"rotateBoard"])
        [gameController rotateBoard: [defaults boolForKey: @"rotateBoard"] animate: NO];
    [self UpdateOnlineGameWithGameDataSet];
}

-(void)getCurrentGameResponseUpdate:(NSNotification*)notification {
    NSDictionary *currentMoveData = [notification userInfo];
    Square fSq = (Square)[[currentMoveData valueForKey:@"from"] integerValue];
    Square tSq =  (Square)[[currentMoveData valueForKey:@"to"] integerValue];
    
    NSString *fen = [currentMoveData valueForKey:@"fen"];
    NSNumber *userId = [currentMoveData valueForKey:@"userId"];
    NSString *PGN = [currentMoveData valueForKey:@"PGN"];
    NSLog(@"FEN CONTAINS%@",self.appOnline.arrFenList);
    if (![self.appOnline.arrFenList containsObject:fen]){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Do some work");
        if (userId == self.appOnline.User.UserID){
            return ;
        }
      //
     
        
        [gameController gameFromPGNString:PGN loadFromBeginning:false];
        [gameController ShowArrowFromSquare:fSq To:tSq];
        //[gameController gameFromFEN:fen];
        [[viewController chessBoardView] setUserInteractionEnabled:true];
        [self.appOnline addFenListToArray:fen];
        double delayInSeconds = 1.0;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [self.appOnline sendConfirmationOfCurrentMoveRecieved:userId];
            //[gameController replayMove];
            //[gameController animateMoveFrom:fSq to:tSq];
        });
       
        bool isGameCheckMate =  [[gameController game] positionIsMate];
        if (isGameCheckMate){
            [[NSNotificationCenter defaultCenter] postNotificationName: @"GameResultNotification"
                                                                object: self
                                                              userInfo:nil];
        }
        bool isGameDraw =  [[gameController game] positionIsDraw];//[[[viewController gameController] game] positionIsDraw];
        NSLog(@"%d",isGameCheckMate);
        NSLog(@"%d",isGameDraw);
        //[[viewController chessBoardView] setUserInteractionEnabled:true];
    //[gameController animateMoveFrom:SQ_D2 to:SQ_D3];
       // [gameController updateMoveList];
        
    });
    }else{
        NSLog(@"SAME PACKET ======= ===== ===== ===== ==== === == === ==");
    }
}

- (void)UpdateOnlineGameWithGameDataSet
{
    @try {
    // set players name
    gameController.game.whitePlayer = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"WhiteUserName"];
    gameController.game.blackPlayer = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"BlackUserName"];
    gameController.game.whiteEngine = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"WhiteEngineName"];
    gameController.game.blackEngine = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"BlackEngineName"];
    gameController.game.eloWhite = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"EloWhiteBefore"];
    gameController.game.eloBlack = [[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"EloBlackBefore"];
    gameController.game.gameTime = [NSString stringWithFormat:@"%d min %d sec",[[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"TimeMin"] intValue],[[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GainPerMoveMin"] intValue]];
    // get number of moves played
        int numberOfMoves = [[self.appOnline.User.Game objectForKey:@"Moves"] NumberOfRowsInTable];
    // set time
    // note time is in milli seconds WTF sf? so * 1000
    int maxGameTimeInMilliSeconds = 1000 * 60 * [(NSString*)[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"TimeMin"] intValue];
    int GainPerMoveInMilliSeconds = 1000 * [(NSString*)[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GainPerMoveMin"] intValue];
    [gameController.game setTimeControlWithTime:maxGameTimeInMilliSeconds increment:GainPerMoveInMilliSeconds];
  
    if (numberOfMoves > 0)
    {
        [gameController.game.clock setWhiteInitialTime:1000 * [(NSString*)[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:(numberOfMoves - 1) ColumnName:@"Mw"] intValue]];
        [gameController.game.clock setBlackInitialTime:1000 * [(NSString*)[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:(numberOfMoves - 1) ColumnName:@"Mb"] intValue]];
    }
    
    // play past moves
    for (int i = 0; i < numberOfMoves; i++)
    {
        Square fromSquare = (Square)[self.moveSquaresICtoSF indexOfObject:[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"F"]];
        Square toSquare = (Square)[self.moveSquaresICtoSF indexOfObject:[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"T"]];
        PieceType promotionPiece = ([gameController pieceCanMoveFrom:fromSquare to:toSquare] > 1) ?
        (PieceType)[self.movePromotionPiecesICtoSF indexOfObject:[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"P"]] :
        NO_PIECE_TYPE;
        
        [gameController rotateBoard:NO];
        if ([gameController pieceCanMoveFrom:fromSquare to:toSquare])
        {
            [gameController animateMoveFrom:fromSquare to:toSquare promotionPieceType:promotionPiece];
            
        
        [gameController SetScoreForLastMove:[NSString stringWithFormat:@"(%@%@)", @"Score:",[[self.appOnline.User.Game objectForKey:@"Moves"] FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"E"]]];
        }
        else
        {
            NSLog(@"");
        }
    }
        
    int gameResult = (GameResultE)[[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GameResultID"] intValue];
    if (gameResult == 0 || gameResult == 1 || gameResult == 6) { }
    else [gameController.game.clock stopClock];
    }
    @catch(NSException *e)
    {
        [CommonTasks LogMessage:e.description MessageFlagType:logMessageFlagTypeError];
    }
}

- (void)UpdateOnlineGame:(DataTable *)moves
{
    int numberOfMoves = moves.NumberOfRowsInTable;
    int startingMoveIndex = 0;
   
    if (numberOfMoves > 1)
    {
        if (gameController.game.moves && gameController.game.moves.count > 0)
        {
            startingMoveIndex = (int)gameController.game.moves.count + 1;
        }
        else
        {
            if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
            {
                [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
                
                [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                    [self.appOnline SendGetGameDataByGameID];
                }];
            }
            return;
        }
    }
    else
        startingMoveIndex = [[moves FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"Id"] intValue];
    
    if (gameController.game.moves && startingMoveIndex == gameController.game.moves.count + 1)
    {
    
    }
    else
    {
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
            
            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                [self.appOnline SendGetGameDataByGameID];
            }];
        }
        return;
    }
    
        int totalNumberofRecords = (int)[moves FetchAllRowsFromTable].count;
        int i = 0;
        if(totalNumberofRecords > 1)
        {
            i = startingMoveIndex - 1;
        }
        for (; i < totalNumberofRecords; i++)
        {
            
            [gameController rotateBoard:NO];
            Square fromSquare = (Square)[self.moveSquaresICtoSF indexOfObject:[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"F"]];
            Square toSquare = (Square)[self.moveSquaresICtoSF indexOfObject:[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"T"]];
            
            PieceType promotionPiece = ([gameController pieceCanMoveFrom:fromSquare to:toSquare] > 1) ?
            (PieceType)[self.movePromotionPiecesICtoSF indexOfObject:[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"P"]] :
            NO_PIECE_TYPE;
            
            if ([gameController pieceCanMoveFrom:fromSquare to:toSquare])
            {
                [gameController animateMoveFrom:fromSquare to:toSquare promotionPieceType:promotionPiece];
                
                [gameController ShowArrowFromSquare:fromSquare To:toSquare];
                
               
                [gameController SetScoreForLastMove:[NSString stringWithFormat:@"(%@%@)", @"Score:",[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"E"]]];
                
                int GainPerMoveInMilliSeconds = 1000 * [(NSString*)[[self.appOnline.User.Game objectForKey:@"Game"] FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"GainPerMoveMin"] intValue];
                
                if (gameController.game.moves.count % 2 == 1)
                {
                    [gameController.game.clock resetWithWhiteTime:1000 * [(NSString*)[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"Mw"] intValue] increment:GainPerMoveInMilliSeconds];
                    
                }
                else
                {
                    [gameController.game.clock resetWithBlackTime:1000 * [(NSString*)[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"Mb"] intValue] increment:GainPerMoveInMilliSeconds];
                    
                    
                }
                [gameController.game.clock setWhiteInitialTime:1000 * [(NSString*)[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"Mw"] intValue]];
                [gameController.game.clock setBlackInitialTime:1000 * [(NSString*)[moves FetchColumnValueOfRowAtIndexFromTable:i ColumnName:@"Mb"]
                    intValue]];
               
            
            }
            else
            {
                if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
                {
                    [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
                    
                    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                        [self.appOnline SendGetGameDataByGameID];
                    }];
                }
            }
            
//            if ([[moves FetchColumnValueOfRowAtIndexFromTable:(int)([moves FetchAllRowsFromTable].count - 1) ColumnName:@"Id"] intValue] != gameController.game.moves.count) {
//                
//                [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
//                
//                [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
//                    [self.appOnline SendGetGameDataByGameID];
//                }];
//
//            }
          
        }
    
    if (aTimer != nil) {
        [aTimer invalidate];
        aTimer = nil;
    }
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
}
-(void)aTime
{
    if ([gameController.game.result  isEqual: @"*"]) {
        [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
        
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline SendGetGameDataByGameID];
        }];
    }
    
}

- (void)dealloc {
    aTimer = nil;
   NSLog(@"AppDelegate dealloc");
}


@end

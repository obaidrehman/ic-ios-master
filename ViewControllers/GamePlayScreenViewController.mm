//
//  GamePlayScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 5/15/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//
#define systemSoundID    1007

#import "GamePlayScreenViewController.h"
#import "AppOptions.h"
#import "AppDelegateStockfish.h"
#import "TheAlerts.h"
#import "AppOnline.h"
#import "MyManager.h"
#import "UIImage+animatedGIF.h"
#import "UIView+Toast.h"
#import "ChatViewController.h"
#import "messageList.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CheckMatePopUp.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectColorSchemeController.h"
//#import "UIImageView+WebCache.h"




@interface GamePlayScreenViewController ()

@property (strong) AppDelegateStockfish *stockfish;

@property (weak, nonatomic) IBOutlet UIView *gamePlayView;
@property (strong, nonatomic) TheAlerts *theAlert;
@property (weak, nonatomic) IBOutlet UIView *gifImgViewContainer;

@end

@implementation GamePlayScreenViewController
{
//    RNBlurModalView *alert;
   // NSMutableDictionary *gameData;
        NSArray *squareMoveInString;
        NSArray *arrGIF;
        int prevGifNo;
        NSString *fen;
        int timerCount;
        BOOL isPacketRecievedToOtherPlayer;
        NSTimer *timerr;
        NSTimer *loginTimer;
        NSTimer *autoAbortTimer;
        NSDictionary *currentMoveData;
        NSNumber *opponentId;
        int autoAbortWiatingTime;
        int blackWaitingTime;
        BOOL isPlayerWhite;
        BOOL isWhitesTurn;
        BOOL isMsgChatVCPresent;
    BOOL isGameMate;
    CheckMatePopUp *chkMateView;
    BOOL isRematch;
    int beforeMsgVCPresentCount;
    int msgRecievedOnChatScrCount;
    NSMutableArray *arrCellMessage;
        }

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_gameData);
    arrCellMessage = [[NSMutableArray alloc] init];
    isPacketRecievedToOtherPlayer = false;
    isMsgChatVCPresent = false;
    timerCount = 2000;
    autoAbortWiatingTime = 0;
    beforeMsgVCPresentCount = 0;
    msgRecievedOnChatScrCount = 0;
    blackWaitingTime = 0;
    isRematch = false;
    isGameMate = false;
    _arrFenList = [[NSMutableArray alloc] init];
   //  [self setSquareArrayData];
     arrGIF = @[@"liveSearching1",@"liveSearching2",@"liveSearching3",@"liveSearching1",@"liveSearching2",@"liveSearching3"];
    [self setRandomGif];
    [self.gifView setHidden:false];
    [[MyManager sharedManager] sideMenuController].leftViewSwipeGestureEnabled = false;

    [self setNotificationsObserver];
       self.theAlert = [[TheAlerts alloc]init];
   

}

-(void)forceTouchIntialize{
    if ([self isForceTouchAvailable]) {
        UIButton *chatBtn = [[self.stockfish viewController] btnChat];
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:chatBtn];
    }
}

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing> )previewingContext viewControllerForLocation:(CGPoint)location{
    NSString * storyboardName = @"Storyboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    ChatViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.appOnline = self.appOnline;
    vc.arrCellMessage = arrCellMessage;
    vc.oppId = opponentId;
    isMsgChatVCPresent = true;
    beforeMsgVCPresentCount = arrCellMessage.count;
    return vc;
    
}

-(void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
   [[self navigationController] presentViewController:viewControllerToCommit animated:true completion:nil];
    //[self.navigationController showViewController:viewControllerToCommit sender:nil];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [[self.gifImgViewContainer layer] setCornerRadius:7];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"VIEW DID APPEAR");
    
    NSString *boardTheme = [[NSUserDefaults standardUserDefaults] valueForKey:@"boardTheme"];
    if ([boardTheme isEqualToString:@""] || boardTheme == nil){
        [[Options sharedOptions] setValue: [[MyManager sharedManager] boardColor] forKey: @"colorScheme"];
    }else{
        [[Options sharedOptions] setValue: boardTheme forKey: @"colorScheme"];
    }
    
    if (!isMsgChatVCPresent){
    @try {
        BOOL isPlayerWhite = ([[_gameData valueForKey:@"isPlayerWhite"] isEqualToString:@"1"]) ? true : false;
        self.stockfish = [[AppDelegateStockfish alloc] initAndLoadStockfishInViewPlayerToPlayer:self.gamePlayView ForOfflinePlay:NO AppOnlineReference:self.appOnline :isPlayerWhite];
        NSLog(@"");
        [self.gamePlayView addSubview:[self.stockfish abcd]];
        [self forceTouchIntialize];
        
    }@catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    [self.stockfish xyz];
    }else{
        UILabel *msgLabelBadge = [[self.stockfish viewController] lblMessageBadge];
        [msgLabelBadge setHidden:true];
        msgRecievedOnChatScrCount = arrCellMessage.count - beforeMsgVCPresentCount;
    }
}

-(void)addCheckMatePopUp:(NSString *)winnerColor:(NSString *)userName{
   NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CheckMatePopUp" owner:self options:nil];
    CheckMatePopUp *customView = [arrayOfViews objectAtIndex:0];
    chkMateView = customView;
    customView.lblWinnerColor.text = winnerColor;
    customView.lblWinnerName.text =  [NSString stringWithFormat:@"%@ - Won by Check Mate",userName];
    customView.alpha = 0.0;
   // customView.frame = CGRectMake(0, self.view.frame.size.height/2,self.view.frame.size.width, 0);
    [self.view addSubview:customView];
    //customView.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    [UIView animateWithDuration:0.5 animations:^{
        customView.alpha = 1.0;
        customView.frame = self.view.frame;
    }];
    
}


- (void)gameEndTest {
   Game *game = [[[self.stockfish viewController] gameController] game];
    if ([game positionIsMate]) {
        isGameMate = true;
        if (([game sideToMove] == WHITE)){
        [self addCheckMatePopUp:@"Black Wins" :[_gameData valueForKey:@"blackName"]];
        }else{
            [self addCheckMatePopUp:@"White Wins":[_gameData valueForKey:@"whiteName"]];
        }
        
        [self.appOnline SendCheckMateUserGameFinishedToServer:opponentId];
        [[[[[self.stockfish viewController] gameController] game] clock] stopClock];
        
//        [[[UIAlertView alloc] initWithTitle: (([game sideToMove] == WHITE)?
//                                              @"Black wins" : @"White wins")
//                                    message: @"Checkmate!"
//                                   delegate: self
//                          cancelButtonTitle: nil
//                          otherButtonTitles: @"OK", nil]
//         show];
      //  [game setResult: (([game sideToMove] == WHITE)? @"0-1" : @"1-0")];
    } else if ([game positionIsDraw]) {
        [[[UIAlertView alloc] initWithTitle: @"Game drawn"
                                    message: [game drawReason]
                                   delegate: self
                          cancelButtonTitle: nil
                          otherButtonTitles: @"OK", nil]
         show];
        [game setResult: @"1/2-1/2"];
    }
}


//-(void)setSquareArrayData{
//    squareMoveInString =  @[
//                            @"SQ_A1", @"SQ_B1", @"SQ_C1", @"SQ_D1", @"SQ_E1", @"SQ_F1", @"SQ_G1", @"SQ_H1",
//                            @"SQ_A2", @"SQ_B2", @"SQ_C2", @"SQ_D2", @"SQ_E2", @"SQ_F2", @"SQ_G2", @"SQ_H2",
//                            @"SQ_A3", @"SQ_B3", @"SQ_C3", @"SQ_D3", @"SQ_E3", @"SQ_F3", @"SQ_G3", @"SQ_H3",
//                            @"SQ_A4", @"SQ_B4", @"SQ_C4", @"SQ_D4", @"SQ_E4", @"SQ_F4", @"SQ_G4", @"SQ_H4",
//                            @"SQ_A5", @"SQ_B5", @"SQ_C5", @"SQ_D5", @"SQ_E5", @"SQ_F5", @"SQ_G5", @"SQ_H5",
//                            @"SQ_A6", @"SQ_B6", @"SQ_C6", @"SQ_D6", @"SQ_E6", @"SQ_F6", @"SQ_G6", @"SQ_H6",
//                            @"SQ_A7", @"SQ_B7", @"SQ_C7", @"SQ_D7", @"SQ_E7", @"SQ_F7", @"SQ_G7", @"SQ_H7",
//                            @"SQ_A8", @"SQ_B8", @"SQ_C8", @"SQ_D8", @"SQ_E8", @"SQ_F8", @"SQ_G8", @"SQ_H8",
//                            @"SQ_NONE"
//                            ];
//}

//CUR MOVE TO SER
-(void)getCurrentMove:(NSNotification*)notification{
    
    isPacketRecievedToOtherPlayer = false;
    [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:false];
    [self stopWaitingTimer];
   // [self.gamePlayView makeToast:@"FALSE" duration:5 position:CSToastPositionTop];
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *toMove = [userInfo valueForKey:@"to"];
    NSNumber *fromMove = [userInfo valueForKey:@"from"];
    NSString *PGN = [userInfo valueForKey:@"PGN"];
    fen = [userInfo valueForKey:@"fen"];
    bool isGameCheckMate =  [[[[self.stockfish viewController] gameController] game] positionIsMate];
    int remainingTimeWhite = [[[[[self.stockfish viewController] gameController] game] clock] whiteRemainingTime];
    int remainingTimeBlack = [[[[[self.stockfish viewController] gameController] game] clock] blackRemainingTime];
    
   // if (isGameCheckMate){
   ///     [self actionGameResult];
   // }
    //NSInteger i = squareMoveInString[str integerValue];
    currentMoveData = @{ @"to": toMove,//squareMoveInString[toMove.integerValue],
                                       @"from":fromMove,//squareMoveInString[fromMove.integerValue],
                                       @"ChalengeID":[_gameData valueForKey:@"ChalengeID"],
                                       @"CurrentUser":[_gameData valueForKey:@"CurrentUser"],
                                       @"Opponent":[_gameData valueForKey:@"Opponent"],
                                       @"fen":fen,
                                        @"PGN":PGN,
                                        @"WT":[NSString stringWithFormat:@"%i", remainingTimeWhite],
                                        @"BT":[NSString stringWithFormat:@"%i", remainingTimeBlack]
                         
                                      };
    [CommonTasks LogMessage:@"Sending Current Move" MessageFlagType:logMessageFlagTypeSystem];
    [self.appOnline sendCurrentMoveToServer:currentMoveData];
   [[[self.stockfish viewController] gameController] playMySound];
    [timerr invalidate];
    timerr = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function methodRunAfterBackground
        [self gameEndTest];
       // [[[self.stockfish viewController] gameController] gameEndTest];
        timerr = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timerr forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
   
}
//MARK:- TIMER FUNC
-(void)timer{
//    NSLog(@"***************************");
//    NSLog(@"TIMER K ANDER AGYA HAI BHAI");
//    NSLog(@"***************************");
    
    dispatch_async(dispatch_get_main_queue(), ^{
      //  [self.gamePlayView makeToast:@"TIMER K ANDER AGYA HAI BHAI" duration:1 position:CSToastPositionBottom];
    });
    timerCount = timerCount + 1;
    NSString *timeCountInText = [NSString stringWithFormat:@"%i", timerCount];
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"Do some work");
        //[self.gamePlayView makeToast:timeCountInText duration:1 position:CSToastPositionCenter];
        [CommonTasks LogMessage:@"Sending Current Move" MessageFlagType:logMessageFlagTypeSystem];
        [self.appOnline sendCurrentMoveToServer:currentMoveData];
        //[[[self.stockfish viewController] blackClockView] setText:@"0"];
         //[[[self.stockfish viewController] lblTimeBlack] setText:timeCountInText];
    });
}

//-(void)loginAfterThreeMinutes{
//   NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
//    NSString *Password = [[NSUserDefaults standardUserDefaults] valueForKey:@"Pass"];
//    dispatch_async(dispatch_get_main_queue(), ^(void)
//                   {
//                       if (![self.appOnline isConnected]) {
//                       [self.appOnline SendLoginUser:userName Password:Password];
//                       [self.gamePlayView makeToast:@"LOGIN" duration:4 position:CSToastPositionBottom];
//                       }
//                   });
//
//}


//MARK:- IS CUR MOVE RCVD 2 OPP
-(void)currentMoveRecievedToOtherPlayer:(NSNotification*)notification{
    
    if (isPacketRecievedToOtherPlayer == false) {
         [self.appOnline addFenListToArray:fen];
        [timerr invalidate];
        timerr = nil;
        timerCount = 2000;
        dispatch_async(dispatch_get_main_queue(), ^{
       // [self.gamePlayView makeToast:@"packet agya hai " duration:3 position:CSToastPositionBottom];
        });
        isPacketRecievedToOtherPlayer = true;
    }
    NSLog(@"");
}

//Mark:- Create Game Response Notification
- (void)createGameChalengeWaitMatched:(NSNotification*)notificationSender
{

Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];

    [self.delegate chalengeCreated];
    
    NSString *userIdString =[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    NSNumber *userId = [[NSNumber alloc] initWithInt: userIdString.integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Do some work");
        UIImageView *player2imgView = [[self.stockfish viewController] compImgView];
        UIImageView *player1imgView = [[self.stockfish viewController] player1ImgView];
        if (self.gameData == nil){
            self.gameData = [notificationSender userInfo];
            NSString *ispalayerwhite =[_gameData valueForKey:@"isPlayerWhite"];
            NSString *oppIdString =[_gameData valueForKey:@"Opponent"];
            opponentId = [[NSNumber alloc] initWithInt: oppIdString.integerValue];
            
        if ([ispalayerwhite isEqualToString:@"1"]){
            [self.view makeToast:@"You Are White" duration:3 position:CSToastPositionCenter];
            [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:true];
            isPlayerWhite = true;
             [self startWaitingTimer];
            [[MyManager sharedManager] loadImages:opponentId :player2imgView];
            [[MyManager sharedManager] loadImages:userId :player1imgView];
        }else{
            [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:false];
            [self.view makeToast:@"You Are black" duration:3 position:CSToastPositionCenter];
            isPlayerWhite = false;
            [[MyManager sharedManager] loadImages:opponentId :player1imgView];
            [[MyManager sharedManager] loadImages:userId :player2imgView];
           // [[[self.stockfish viewController] gameController] rotateBoard:true animate:true];
        }
            isWhitesTurn = true;
            [[[[self.stockfish viewController] gameController] game] pushClock];
        [[[self.stockfish viewController] computerLevelLbl] setText:[_gameData valueForKey:@"blackName"]];
        [[[self.stockfish viewController] player2] setText:[_gameData valueForKey:@"whiteName"]];
            
        [self.gifView setHidden:true];
//            if (isRematch || isGameMate){
//                [[self.stockfish gameController]startNewGame];
//                [chkMateView removeFromSuperview];
//                isRematch = false;
//                isGameMate = false;
//            }
        }});
    
     dispatch_async(dispatch_get_main_queue(), ^{
         Game *game = [[[self.stockfish viewController] gameController] game];
         
    if (isRematch || isGameMate){
        [[self.stockfish gameController]startNewGame];
        [chkMateView removeFromSuperview];
        isRematch = false;
        isGameMate = false;
        self.appOnline.arrFenList = nil;
    }
         
                    });
    NSLog(@"Matched");

}


//Mark:- Create Game Response Not Matched Notification
- (void)createGameChalengeWaitNotMatched:(NSNotification*)notificationSender
{
    NSLog(@"Create Game Chalenge œœœœœœœœœœœœœœœœœœœœœœ");
    Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Do some work");
        //if (!isGameScreenOpened){
            [self.navigationController popViewControllerAnimated:true];
      //  }
    });
}

-(void)dismissOnlineBoardVC {
    NSLog(@"ksg asg ag kdhg khg kag jgj asjhf jahs jsag");
    //self.appOnline.User.Game = nil;
    self.appOnline.theFlag = false;
    if (_gameData != nil){
        [self.appOnline resignOnlineGameChalenge:opponentId];
        [[self navigationController] popViewControllerAnimated:true];
    }else{
    [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (IBAction)actionCrossBtn:(id)sender {
    
    [self.appOnline cancelOnlineGameChalenge];
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    // [[self navigationController] popViewControllerAnimated:NO]
   
    [self.navigationController popViewControllerAnimated:NO];
}

//MARK:- Set random Gif method
-(void)setRandomGif{
    int gifNo = arc4random() % 6;
    NSLog(@"gifNo= ========  %i",gifNo);
        NSURL *url = [[NSBundle mainBundle] URLForResource:arrGIF[gifNo] withExtension:@"gif"];
        self.imgViewGif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
}

-(void)appWillTerminate:(NSNotification*)notificationSender{
    NSLog(@"");
    
    //self.appOnline appTerminatedCloseOnlineGame:
}

//MARK:- CheckMate method
-(void)actionGameResult{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CheckMate" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

//MARK:- action Resign Method
-(void)actionResignGame:(NSNotification*)notificationSender{
    
     NSDictionary *resignType = [notificationSender userInfo];
    
//    if ([resignType valueForKey:@"type"] == @"theme"){
//        //isMsgChatVCPresent = true;
//        SelectColorSchemeController *scsc = [[SelectColorSchemeController alloc]
//                                             initWithParentViewController: nil];
//        [[self navigationController]
//         pushViewController: scsc animated: YES];
//    }else{
        [self.appOnline resignOnlineGameChalenge:opponentId];
        [self.navigationController popViewControllerAnimated:true];
    //}
    
    
    NSLog(@"");
}

//MARK:- Resign Response Method
-(void)actionResignGameResponse{
    if (_gameData != nil){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Resign" message:@"Other User has resigned" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
       [self.navigationController popViewControllerAnimated:true];
    }];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
    }else{
        return;
    }
}

-(void)waitingTimer{
    
    if (autoAbortWiatingTime >= 5){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self.stockfish viewController] lblAutoAbort] setHidden:false];
            [[[self.stockfish viewController] lblAutoAbort] setText:[NSString stringWithFormat:@"Auto-Abort in %i",20 - autoAbortWiatingTime]];
        });
    }
    
    if (autoAbortWiatingTime == 20){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gamePlayView makeToast:@"Game Abort" duration:3 position:CSToastPositionBottom];
            [[[[[self.stockfish viewController] gameController] game] clock] stopClock];
            [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:false];
            [[[self.stockfish viewController] lblAutoAbort] setHidden:true];
            [self.appOnline sendGameAbortToServer:opponentId];
            [self stopWaitingTimer];
        });
        NSLog(@"");
    }
    autoAbortWiatingTime = autoAbortWiatingTime + 1;
}


-(void)stopWaitingTimer{
    [autoAbortTimer invalidate];
    autoAbortTimer = nil;
    autoAbortWiatingTime = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
       [[[self.stockfish viewController] lblAutoAbort] setHidden:true];
    });
    
}

-(void)startWaitingTimer{
    [autoAbortTimer invalidate];
    autoAbortTimer = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //run function methodRunAfterBackground
    autoAbortTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(waitingTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:autoAbortTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    });
  
}

-(void)getCurrentGameResponseUpdate:(NSNotification*)notification {
    [self stopWaitingTimer];
    
    NSDictionary *currentMoveData = [notification userInfo];
    Square fSq = (Square)[[currentMoveData valueForKey:@"from"] integerValue];
    Square tSq =  (Square)[[currentMoveData valueForKey:@"to"] integerValue];
    
    NSString *fen = [currentMoveData valueForKey:@"fen"];
    NSNumber *userId = [currentMoveData valueForKey:@"userId"];
    NSString *PGN = [currentMoveData valueForKey:@"PGN"];
    
    NSInteger whiteTime = [[currentMoveData valueForKey:@"WT"] integerValue];
    NSInteger blackTime = [[currentMoveData valueForKey:@"BT"] integerValue];
    NSLog(@"FEN CONTAINS%@",self.appOnline.arrFenList);
    if (![self.appOnline.arrFenList containsObject:fen]){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Do some work");
            if (userId == self.appOnline.User.UserID){
                return ;
            }
            //
            
            
            [[[self.stockfish viewController] gameController] gameFromPGNString:PGN loadFromBeginning:false];
             [[[self.stockfish viewController] gameController]  ShowArrowFromSquare:fSq To:tSq];
            [[[self.stockfish viewController] gameController] playMySound];
//            [[[self.stockfish viewController] gameController] gameFromFEN:fen];

            [[[[[self.stockfish viewController] gameController] game] clock] resetWithWhiteTime:whiteTime increment:1];
            [[[[[self.stockfish viewController] gameController] game] clock] resetWithBlackTime:blackTime increment:1];
            [[[[self.stockfish viewController] gameController] game] pushClock];
            [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:true];
            [self.appOnline addFenListToArray:fen];
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.appOnline sendConfirmationOfCurrentMoveRecieved:userId];
                [self gameEndTest];
                //[gameController replayMove];
                //[gameController animateMoveFrom:fSq to:tSq];
            });
            
        });
    }else{
        NSLog(@"SAME PACKET ======= ===== ===== ===== ==== === == === ==");
    }
}


//MARK:- Action chat button
-(void)actionChatButton{
    
    NSString * storyboardName = @"Storyboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    ChatViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.appOnline = self.appOnline;
    vc.arrCellMessage = arrCellMessage;
    vc.oppId = opponentId;
    isMsgChatVCPresent = true;
    beforeMsgVCPresentCount = arrCellMessage.count;
    [[self navigationController] presentViewController:vc animated:true completion:nil];
    
}



-(void)gameAbbortResponseAction:(NSNotification*)notificationSender{
    NSLog(@"");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gamePlayView makeToast:@"Game Aborted" duration:3 position:CSToastPositionBottom];
            [[[[[self.stockfish viewController] gameController] game] clock] stopClock];
            [[[self.stockfish viewController] chessBoardView] setUserInteractionEnabled:false];
            [[[self.stockfish viewController] lblAutoAbort] setHidden:true];

        });
        
    }];
}

-(void)rematchGameAction:(NSNotification*)notificationSender{
    NSLog(@"");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appOnline sendRematchGameData:opponentId];
            [self viewDidLoad];
            [self viewWillAppear:YES];
            [[self.stockfish gameController]startNewGame];
            _gameData = nil;
            isRematch = true;
            self.appOnline.arrFenList = nil;
        });
        
    }];
}
-(void)messageResponse:(NSNotification*)notificationSender{
    NSLog(@"");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
        messageList* msg = [[messageList alloc] init];
        NSLog(@"%@",packet);
        NSNumber *recieverId = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:201]];
        NSString *message = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:202]];
        NSNumber *messageId = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:203]];
        
        msg.message = message;
        msg.recieverId = opponentId;
        msg.messageId = messageId;
        msg.isSender = false;
        for (int i = 0 ;i < arrCellMessage.count ;i++){
            messageList *arrMsgList =(messageList*)arrCellMessage[i];
            if (arrMsgList.messageId == messageId)
                return ;
        }
        [arrCellMessage addObject:msg];
        UILabel *msgLabelBadge = [[self.stockfish viewController] lblMessageBadge];
        dispatch_async(dispatch_get_main_queue(), ^{
            [msgLabelBadge setHidden:false];
            [msgLabelBadge setText:[NSString stringWithFormat:@"%i",arrCellMessage.count - beforeMsgVCPresentCount - msgRecievedOnChatScrCount]];
            AudioServicesPlaySystemSound (systemSoundID);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
        
    }];
}

//Mark:- Notification Observer Method
-(void)setNotificationsObserver{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createGameChalengeWaitNotMatched:)
                                                 name: @"createGameChalengeWaitNotMatched"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(createGameChalengeWaitMatched:)
                                                 name: @"createGameChalengeWaitMatched"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(dismissOnlineBoardVC) name: @"dismissOnlineBoardVC" object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(getCurrentMove:) name: @"getCurrentMove" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(currentMoveRecievedToOtherPlayer:) name: @"icPacketCurrentMoveRecieved" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(appWillTerminate:) name: @"applicationWillTerminate" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(actionGameResult) name: @"GameResultNotification" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(actionResignGame:) name: @"ResignGameNotification" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(actionResignGameResponse) name: @"icPacketResignAppResponse" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(getCurrentGameResponseUpdate:)
                                                 name: @"getCurrentGameResponseUpdate"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(actionChatButton) name: @"chatNotification" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(messageResponse:)
                                                 name: @"icPacketMessageResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(gameAbbortResponseAction:)
                                                 name: @"icPacketGameAbbortResponse"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(rematchGameAction:)
                                                 name: @"RematchGameNotification"
                                               object: nil];
}


@end







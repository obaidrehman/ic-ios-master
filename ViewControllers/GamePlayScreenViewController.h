//
//  GamePlayScreenViewController.h
//  Infinity Chess iOS
//
//  Created by user on 5/15/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOnline.h"
#import "ADTransitionController.h"

@protocol stopChalengeTimer <NSObject>
- (void)chalengeCreated;
// ... other methods here
@end

@interface GamePlayScreenViewController :UIViewController<UIViewControllerPreviewingDelegate>

@property CGRect viewFrame;
@property (strong) volatile AppOnline *appOnline;
@property NSDictionary *gameData;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGif;
@property (weak, nonatomic) IBOutlet UIView *gifView;
@property NSMutableArray *arrFenList;
@property (weak, nonatomic) IBOutlet UIButton *btnChk;
@property (nonatomic, weak) id <stopChalengeTimer> delegate;
@property (nonatomic, strong) id previewingContext;

/// @description this is use to unload any previous game in memory
///
/// always call this before loading a new game
- (void) UnloadPreviousGame;

/// @description this updates the online game with the update game pkt
/// @param updateMovePkt this is use to update the game
- (void)UpdateGameWithUpdateGamePacket:(NSDictionary*)updateMovePkt;

/// @description this updates the game with game datatable
- (void)UpdateGame;

@end

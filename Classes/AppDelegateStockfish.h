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

#import "BoardViewController.h"
#import "GameController.h"
#import "AppOnline.h"

@interface AppDelegateStockfish : NSObject /*<UIApplicationDelegate>*/ {
//   UIWindow *window;
   BoardViewController *viewController;
   GameController *gameController;
}

//@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) BoardViewController *viewController;
@property (nonatomic, readonly) GameController *gameController;

- (void)backgroundInit:(id)anObject;
- (void)backgroundInitFinished:(id)anObject;




/// @description this is the reference view which will hold the stockfish app
@property UIView* viewStockfish;
/// @description this determine whether to load stockfish for offline or online purpose, a YES means offline loading
@property BOOL isOfflineStockfish;
@property BOOL isPlayerToPlayer;
@property BOOL isWhitePlayer;
/// @description use this to init and launch stockfish
/// @param view the view which will hold stockfish, stockfish will be scaled to fit this view size
/// @param isOfflinePlay this value determines if stockfish is to be loaded for offline or online gameplay
/// @param appOnline should be nil in offline and refrenced to an apponline instance in online mode
- (id)initAndLoadStockfishInView:(UIView*)view ForOfflinePlay:(BOOL)isOfflinePlay AppOnlineReference:(volatile AppOnline*)appOnline;
- (id)initAndLoadStockfishInViewPlayerToPlayer:(UIView *)view ForOfflinePlay:(BOOL)isOfflinePlay AppOnlineReference:(volatile AppOnline *) appOnline:(BOOL)isPlayerWhite;
/// @description updates game moves and time
- (void)UpdateOnlineGame:(DataTable*)moves;

/// @description use this to save stockfish state
- (void)saveState;

/// @description deinti all stockfish modules
- (void)DeInitStockfish;

/// @description subscribe to Stockfish playoffline notification
- (void)SubscribeToStockfishPlayOfflineNotifications:(id)subscriber;

/// @description unsubscribe Stockfish playoffline notification
- (void)UnsubscribeToStockfishPlayOfflineNotifications:(id)subscriber;

-(UIView*)abcd;

-(void)xyz;

@end


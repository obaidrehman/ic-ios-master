/*
InfinityChess, a chess program for iOS.
  // (c) Copyright Yawar
// All other rights reserved.

  */

#import <UIKit/UIKit.h>

@class BoardViewController;

@interface NewGameViewController : UITableViewController {
   BoardViewController *__weak boardViewController;
}

@property (weak, nonatomic, readonly) BoardViewController *boardViewController;

- (id)initWithBoardViewController:(BoardViewController *)bvc;
- (void)deselect:(UITableView *)tableView;
- (void)toggleShowAnalysis:(id)sender;
- (void)toggleShowBookMoves:(id)sender;
- (void)toggleShowLegalMoves:(id)sender;
- (void)toggleShowCoordinates:(id)sender;
- (void)toggleShowAnalysisArrows:(id)sender;
- (void)togglePermanentBrain:(id)sender;
- (void)toggleFigurines:(id)sender;
- (void)toggleSound:(id)sender;
- (void)updateTableCells;
- (id)initWithBoardViewControllerAndGameController:(BoardViewController *)bvc : (GameController *)GC;

@end

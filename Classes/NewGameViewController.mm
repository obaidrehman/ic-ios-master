/*
InfinityChess, a chess program for iOS.
  // (c) Copyright Yawar
// All other rights reserved.

  */

#import "AboutController.h"
#import "BoardViewController.h"
#import "EditUserNameController.h"
#import "Options.h"
#import "NewGameViewController.h"
#import "SimpleOptionTableController.h"
#import "SelectColorSchemeController.h"
#import "SelectPieceSetController.h"
#import "StrengthOptionController.h"



@implementation NewGameViewController
{
    GameController *GameC;
}

@synthesize boardViewController;

- (id)initWithBoardViewController:(BoardViewController *)bvc {
   if (self = [super initWithStyle: UITableViewStyleGrouped]) {
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         [self setTitle: nil];
      else
         [self setTitle: @"Game"];
      boardViewController = bvc;
   }
   return self;
}
- (id)initWithBoardViewControllerAndGameController:(BoardViewController *)bvc : (GameController *)GC {
    if (self = [super initWithStyle: UITableViewStyleGrouped]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self setTitle: nil];
        else
            [self setTitle: @"Game"];
        boardViewController = bvc;
        GameC = GC;
        
        
    }
    return self;
}

- (void)loadView {
   [super loadView];
   [[self navigationItem] setRightBarButtonItem:
                             [[UIBarButtonItem alloc]
                                 initWithTitle: @"Done"
                                         style: UIBarButtonItemStylePlain
                                        target: boardViewController
                                        action: @selector(optionsMenuDonePressed)]];
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
   // Release anything that's not essential, such as cached data
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger row = [indexPath row];
   //NSInteger section = [indexPath section];

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
   if (cell == nil)
      cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                     reuseIdentifier: @"cell"];

   
    if (row == 0) {
          [[cell textLabel] setText: @"Play White"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];

      } else if (row == 1) {
          [[cell textLabel] setText: @"Play Black"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];
      } else if (row == 2) {
          [[cell textLabel] setText:  @"Play Both"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];
      } else if (row == 3) {
          [[cell textLabel] setText: @"Analysis"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];
      }
    return cell;
}


- (void)deselect {
   [[self tableView] deselectRowAtIndexPath:
                        [[self tableView] indexPathForSelectedRow]
                                   animated: YES];
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:
   (NSIndexPath *)newIndexPath {
   NSInteger row = [newIndexPath row];
   //NSInteger section = [newIndexPath section];

   [self performSelector: @selector(deselect:) withObject: tableView
              afterDelay: 0.1f];

    switch (row) {
        case 0:
            [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
            [GameC setGameMode: GAME_MODE_COMPUTER_BLACK];
            [GameC startNewGame];
            break;
        case 1:
            NSLog(@"new game with black");
            [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_WHITE];
             [GameC setGameMode: GAME_MODE_COMPUTER_WHITE];
             [GameC startNewGame];
        break;
        case 2:
            [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
            [GameC setGameMode: GAME_MODE_TWO_PLAYER];
            [GameC startNewGame];

        break;
        case 3:
            [[Options sharedOptions] setGameMode: GAME_MODE_ANALYSE];
            [GameC setGameMode: GAME_MODE_ANALYSE];
            [GameC startNewGame];
        break;
           
    
    }
    [boardViewController optionsMenuDonePressed];

}


- (void)deselect:(UITableView *)tableView {
   [tableView deselectRowAtIndexPath: [tableView indexPathForSelectedRow]
                            animated: YES];
}


- (void)toggleShowAnalysis:(id)sender {
   [[Options sharedOptions] setShowAnalysis: [sender isOn]];
   if (![sender isOn])
      [boardViewController hideAnalysis];
}

- (void)toggleShowBookMoves:(id)sender {
   [[Options sharedOptions] setShowBookMoves: [sender isOn]];
   if ([sender isOn])
      [boardViewController showBookMoves];
   else
      [boardViewController hideBookMoves];
}

- (void)toggleShowLegalMoves:(id)sender {
   [[Options sharedOptions] setShowLegalMoves: [sender isOn]];
}

- (void)toggleShowAnalysisArrows:(id)sender {
   [Options sharedOptions].showArrow = [sender isOn];
   if (![sender isOn]) {
      [[boardViewController boardView] hideArrow];
   }
}

- (void)toggleShowCoordinates:(id)sender {
   [[Options sharedOptions] setShowCoordinates: [sender isOn]];
}

- (void)togglePermanentBrain:(id)sender {
   [[Options sharedOptions] setPermanentBrain: [sender isOn]];
}

- (void)toggleFigurines:(id)sender {
   [[Options sharedOptions] setFigurineNotation: [sender isOn]];
}

- (void)toggleSound:(id)sender {
   [[Options sharedOptions] setMoveSound: [sender isOn]];
}

- (void)updateTableCells {
   [[self tableView] reloadData];
}



@end

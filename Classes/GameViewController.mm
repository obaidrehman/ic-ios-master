/*
InfinityChess, a chess program for iOS.
  // (c) Copyright Yawar
// All other rights reserved.

  */

#import "AboutController.h"
#import "BoardViewController.h"
#import "EditUserNameController.h"
#import "Options.h"
#import "GameViewController.h"
#import "SimpleOptionTableController.h"
#import "SelectColorSchemeController.h"
#import "SelectPieceSetController.h"
#import "StrengthOptionController.h"
#import "NewGameViewController.h"
#import "GameDetailsTableController.h"
#import "LoadFileListController.h"
#import "SetupViewController.h"
#import "LevelViewController.h"

@implementation GameViewController
{
    NewGameViewController *NGVC;
    GameController *gController;
    GameDetailsTableController *GDTC;
    LoadFileListController *lflc;
    SetupViewController *SVC;
    LevelViewController *lvc;
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
        gController = GC;
        
        
    }
    return self;
}


- (void)loadView {
   [super loadView];
   [[self navigationItem] setRightBarButtonItem:
                             [[UIBarButtonItem alloc]
                                 initWithTitle: @"Back"
                                         style: UIBarButtonItemStylePlain
                                        target: boardViewController
                                        action: @selector(optionsMenuDonePressed)]];
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
   // Release anything that's not essential, such as cached data
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Game Configuration";
            break;
            
    }
    return sectionName;
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
          [[cell textLabel] setText: @"New Game"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];

      } else if (row == 1) {
          [[cell textLabel] setText: @"Save Game"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];
      } else if (row == 2) {
          [[cell textLabel] setText:  @"Load game"];
          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
          [cell setAccessoryView: nil];
          [[cell detailTextLabel] setText: @""];
      }
//      } else if (row == 3) {
//          [[cell textLabel] setText: @"E-mail game"];
//          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
//          [cell setAccessoryView: nil];
//          [[cell detailTextLabel] setText: @""];
//      } else if (row == 4) {
//          [[cell textLabel] setText: @"Edit position"];
//          [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
//          [cell setAccessoryView: nil];
//          [[cell detailTextLabel] setText: @""];
//      }
      else if (row == 3) {
          [[cell textLabel] setText: @"Level/Game mode"];
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
            NGVC = [[NewGameViewController alloc]initWithBoardViewControllerAndGameController:boardViewController :gController];
                          [[self navigationController] pushViewController: NGVC animated: YES];
        break;
        case 1:
            GDTC =
            [[GameDetailsTableController alloc]
             initWithBoardViewController: boardViewController
             game: [gController game]
             email: NO];

              [[self navigationController] pushViewController: GDTC animated: YES];
            break;
        case 2:
            lflc =
            [[LoadFileListController alloc] initWithBoardViewController: boardViewController];
                [[self navigationController] pushViewController: lflc animated: YES];
            break;
//        case 3:
//            GDTC =
//            [[GameDetailsTableController alloc]
//             initWithBoardViewController: boardViewController
//             game: [gController game]
//             email: YES];
//                            [[self navigationController] pushViewController: GDTC animated: YES];
//            break;
//        case 4:
//            SVC =
//            [[SetupViewController alloc]
//             initWithBoardViewController: boardViewController
//             fen: [[gController game] currentFEN]];
//             [[self navigationController] pushViewController: SVC animated: YES];
//            break;
        case 3:
            lvc = [[LevelViewController alloc] initWithBoardViewController: boardViewController];
  [[self navigationController] pushViewController: lvc animated: YES];
            break;
    
    }
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

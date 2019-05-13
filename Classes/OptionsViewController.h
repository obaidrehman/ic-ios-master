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
#import "BaseVC.h"

@class BoardViewController;
@class BoardVCOffline;

@interface OptionsViewController : UITableViewController {
   BoardViewController *__weak boardViewController;
   BoardVCOffline *__weak boardVCOffline;
    
    int apply_Strength;
}

@property (weak, nonatomic, readonly) BoardViewController *boardViewController;
@property (weak, nonatomic) BaseVC *basevc;

- (id)initWithBoardViewController:(BoardViewController *)bvc;
- (id)initWithBoardVCOffline:(BoardVCOffline *)bvcol;

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
- (int)mrOVCTellMeStrength;

-(void)CR_showAnalysis:(BOOL)flag;

@property (strong, nonatomic) IBOutlet UIView *customOnTopView;


- (IBAction)sliderAction:(id)sender;
- (IBAction)switch1Action:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switch1;

- (IBAction)switch2Action:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;

- (IBAction)switch3Action:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;



@property (weak, nonatomic) IBOutlet UILabel *difficulyLabel;
@property (weak, nonatomic) IBOutlet UISlider *strengthSlider;




@end

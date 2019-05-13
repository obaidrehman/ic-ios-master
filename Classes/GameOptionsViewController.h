/*
 InfinityChess, a chess program for iOS.
 // (c) Copyright Innovative Solution, Karachi Pakistan. http://inovativesolution.net/
 // All other rights reserved.
 
 */

#import <UIKit/UIKit.h>

@class BoardViewController;
@class BoardVCOffline; //•
@class BaseVC; //•

@interface GameOptionsViewController : UITableViewController {
    BoardViewController *__weak boardViewController;
    
    BoardVCOffline *__weak boardVCOffline;//•
    int apply_Strength;//•
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

//•
@property (weak, nonatomic, readonly) BoardVCOffline *boardVCOffline;
@property (weak, nonatomic) BaseVC *basevc;

- (id)initWithBoardVCOffline:(BoardVCOffline *)bvcol;

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
//•

@end


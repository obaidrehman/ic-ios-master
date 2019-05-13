/*
 InfinityChess, a chess program for iOS.
 // (c) Copyright Innovative Solution, Karachi Pakistan. http://inovativesolution.net/
 // All other rights reserved.
 
 */

#import "AboutController.h"
#import "BoardViewController.h"
#import "EditUserNameController.h"
#import "Options.h"
#import "GameOptionsViewController.h"
#import "SimpleOptionTableController.h"
#import "SelectColorSchemeController.h"
#import "SelectPieceSetController.h"
#import "StrengthOptionController.h"
#import "BoardVCOffline.h"
#import "BaseVC.h"


@implementation GameOptionsViewController


@synthesize boardViewController, boardVCOffline;

- (id)initWithBoardViewController:(BoardViewController *)bvc {
    if (self = [super initWithStyle: UITableViewStyleGrouped]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self setTitle: nil];
        else
            [self setTitle: @"Options"];
        boardViewController = bvc;
    }
    return self;
}

- (id)initWithBoardVCOffline:(BoardVCOffline *)bvcol {
    if (self = [super initWithStyle: UITableViewStyleGrouped]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self setTitle: nil];
        else
            [self setTitle: @"Options"];
        boardVCOffline = bvcol;
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.boardVCOffline) {
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor blackColor];
        NSLog(@"");
        [[NSBundle mainBundle] loadNibNamed:@"OptionsVCCustomViewOnTop" owner:self options:nil];
        [self.view addSubview:self.customOnTopView];
        
        self.customOnTopView.translatesAutoresizingMaskIntoConstraints = false;
        [self.customOnTopView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self.customOnTopView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        [self.customOnTopView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
        [self.customOnTopView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
        
        //initial settings
        int strength = [[Options sharedOptions] strength];
        apply_Strength = strength;
        [_strengthSlider setValue:strength];
        _difficulyLabel.text = [NSString stringWithFormat:@"Difficulty: %d", strength];
        
        [self.switch1 setOn: [[Options sharedOptions]showLegalMoves]];
        //
        
        
        [self CR_showAnalysis:NO];
        [self CR_hideBookMoves];
        [self CR_showCoordinates];
        [self CR_showAnalysisArrows];
        [self CR_setColorScheme];
        [self CR_FigurineNotation];
    }
    
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
            sectionName = @"Options";
            break;
        case 1:
            sectionName = @"Strength";
            break;
        case 2:
            sectionName = @"Apperence";
            break;
        case 3:
            sectionName = @"Others";;
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.boardVCOffline) {
        return 0;
    } else {
        return 5;
    }
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(self.boardVCOffline) {
        return 0;
    } else {
        switch(section) {
            case 0: return 4;
            case 1: return 3;
            case 2: return 4;
            case 3: return 1;
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: @"cell"];
    
    if (section == 0) {
        UISwitch *sw;
        if (row == 0) {
            [[cell textLabel] setText: @"Show analysis"];
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] showAnalysis] animated: NO];
            [sw addTarget: self action: @selector(toggleShowAnalysis:)
         forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
            // } else if (row == 1) {
            // [[cell textLabel] setText: @"Show book moves"];
            // sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            // [sw setOn: [[Options sharedOptions] showBookMoves] animated: NO];
            // [sw addTarget: self action: @selector(toggleShowBookMoves:)
            // forControlEvents:UIControlEventValueChanged];
            // [cell setAccessoryView: sw];
            // [[cell detailTextLabel] setText: @""];
        } else if (row == 1) {
            [[cell textLabel] setText: @"Show legal moves"];
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] showLegalMoves] animated: NO];
            [sw addTarget: self action: @selector(toggleShowLegalMoves:)
         forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        } else if (row == 2) {
            [[cell textLabel] setText: @"Show coordinates"];
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] showCoordinates] animated: NO];
            [sw addTarget: self action: @selector(toggleShowCoordinates:)
         forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        } else if (row == 3) {
            [[cell textLabel] setText: @"Show analysis arrows"];
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [Options sharedOptions].showArrow animated: NO];
            [sw addTarget: self action: @selector(toggleShowAnalysisArrows:)
         forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        }
    } else if (section == 1) {
        if (row == 0) {
            UISwitch *sw;
            [[cell textLabel] setText: @"Permanent brain"];
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] permanentBrain] animated: NO];
            [sw addTarget: self action: @selector(togglePermanentBrain:)
         forControlEvents:UIControlEventValueChanged];
            [sw setEnabled: YES];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        } else {
            if (row == 1) {
                [[cell textLabel] setText: @"Play style"];
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                [[cell detailTextLabel] setText: [[Options sharedOptions] playStyle]];
                [cell setAccessoryView: nil];
                // } else if (row == 2) {
                // [[cell textLabel] setText: @"Book variety"];
                // [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                // [[cell detailTextLabel] setText: [[Options sharedOptions] bookVariety]];
                // [cell setAccessoryView: nil];
            } else if (row == 2) {
                [[cell textLabel] setText: @"Strength"];
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                [[cell detailTextLabel]
                 setText: [NSString stringWithFormat: @"%d",
                           [[Options sharedOptions] strength]]];
                [cell setAccessoryView: nil];
            }
        }
    } else if (section == 2) {
        if (row == 0) {
            [[cell textLabel] setText: @"Piece set"];
            [[cell detailTextLabel] setText: [[Options sharedOptions] pieceSet]];
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
            [cell setAccessoryView: nil];
        } else if (row == 1) {
            [[cell textLabel] setText: @"Color scheme"];
            [[cell detailTextLabel] setText: [[Options sharedOptions] colorScheme]];
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
            [cell setAccessoryView: nil];
        } else if (row == 2) {
            [[cell textLabel] setText: @"Sound"];
            UISwitch *sw;
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] moveSound]];
            [sw addTarget: self action: @selector(toggleSound:)
         forControlEvents: UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        } else if (row == 3) {
            [[cell textLabel] setText: @"Figurine notation"];
            UISwitch *sw;
            sw = [[UISwitch alloc] initWithFrame: CGRectMake(4.0f, 16.0f, 10.0f, 28.0f)];
            [sw setOn: [[Options sharedOptions] figurineNotation] animated: NO];
            [sw addTarget: self action: @selector(toggleFigurines:)
         forControlEvents: UIControlEventValueChanged];
            [cell setAccessoryView: sw];
            [[cell detailTextLabel] setText: @""];
        }
    } else if (section == 3) {
        if (row == 0) {
            [[cell textLabel] setText: @"Your name"];
            [[cell detailTextLabel] setText: [[Options sharedOptions] fullUserName]];
            [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
            [cell setAccessoryView: nil];
        }
        // } else if (section == 4) {
        // if (row == 0) {
        // [[cell textLabel] setText: @"About/Help"];
        // [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        // [cell setAccessoryView: nil];
        // [[cell detailTextLabel] setText: @""];
        // }
    } else {
        /*
         [[cell textLabel] setText: [NSString stringWithFormat: @"section %d, row %d",
         section, row]];
         */
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
    NSInteger section = [newIndexPath section];
    
    [self performSelector: @selector(deselect:) withObject: tableView
               afterDelay: 0.1f];
    
    SimpleOptionTableController *sotc;
    if (section == 1) {
        if (row == 1) {
            // Play style
            sotc = [[SimpleOptionTableController alloc] initWithOption: @"Play style" parentViewController: self];
            [[self navigationController] pushViewController: sotc animated: YES];
            // } else if (row == 2) {
            // // Book variety
            // sotc = [[SimpleOptionTableController alloc]
            // initWithOption: @"Book variety"
            // parentViewController: self];
            // [[self navigationController] pushViewController: sotc
            // animated: YES];
        } else if (row == 2) {
            // Strength
            StrengthOptionController *soc;
            soc = [[StrengthOptionController alloc] initWithParentViewController: self];
            [[self navigationController] pushViewController: soc
                                                   animated: YES];
        }
    } else if (section == 2) {
        if (row == 0) {
            // Piece set
            SelectPieceSetController *spsc = [[SelectPieceSetController alloc] initWithParentViewController: self];
            [[self navigationController] pushViewController: spsc
                                                   animated: YES];
        } else if (row == 1) {
            // Color scheme
            GameOptionsViewController *ovc = self;
            SelectColorSchemeController *scsc = [[SelectColorSchemeController alloc] initWithParentViewController:ovc];
            [[self navigationController] pushViewController: scsc
                                                   animated: YES];
        }
    }
    else if (section == 3) {
        if (row == 0) {
            // User name
            EditUserNameController *eunc = [[EditUserNameController alloc] initWithParentViewController: self];
            [[self navigationController] pushViewController: eunc animated: YES];
        }
        // } else if (section == 4) {
        // if (row == 0) {
        // AboutController *ac = [[AboutController alloc] init];
        // [[self navigationController] pushViewController: ac animated: YES];
        // }
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








- (IBAction)sliderAction:(id)sender {
    //UISlider *slider = (UISlider *)sender;
    
    int sv = (int)[_strengthSlider value];
    
    apply_Strength = sv;
    
    _difficulyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [NSString stringWithFormat: @"%d", sv]];//(int)[slider value]
    
    NSLog(@"%d", sv);
    
}

- (IBAction)switch1Action:(id)sender {
    [self CR_showLegalMoves:self.switch1.isOn];
}

- (IBAction)switch2Action:(id)sender {
}

- (IBAction)switch3Action:(id)sender {
}

- (IBAction)closeButtonAction:(id)sender {
    [_basevc hideOptions];
}

- (IBAction)applyButtonAction:(id)sender {
    [self saveWhenUserApply];
    [_basevc hideOptions];
}

-(void)saveWhenUserApply {
    [[Options sharedOptions] setStrength: apply_Strength];
    [self.basevc setComputerlevelLblTextOnBoardVC:[NSString stringWithFormat: @"%d", apply_Strength]];
}
//my custom requirment to set some stuff default according to requirment•
//

-(void)CR_showAnalysis:(BOOL)flag {
    [[Options sharedOptions] setShowAnalysis:flag];
    //[boardViewController hideAnalysis];
}

-(void)CR_hideBookMoves {
    [[Options sharedOptions] setShowBookMoves:NO];
    [boardViewController hideBookMoves];
}

- (void)CR_showLegalMoves:(BOOL)flag {
    [[Options sharedOptions] setShowLegalMoves:flag];
}

-(void)CR_showCoordinates{
    [[Options sharedOptions] setShowCoordinates:YES];
}

- (void)CR_showAnalysisArrows {
    //[[boardViewController boardView] hideArrow];
}

-(void)CR_setColorScheme {
    [[Options sharedOptions] setValue:@"Green" forKey: @"colorScheme"];
    [[Options sharedOptions] setValue:@"Alpha" forKey: @"pieceSet"];
}

-(int)mrOVCTellMeStrength {
    return [[Options sharedOptions]strength];
}

-(void)CR_FigurineNotation {
    [[Options sharedOptions] setFigurineNotation:YES];
}


@end

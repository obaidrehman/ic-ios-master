//
//  BoardVCOffline.m
//  InfinityChess2018
//
//  Created by Shehzar on 3/30/18.
//


#import <QuartzCore/QuartzCore.h>

#import "BoardVCOffline.h"
#import "GameController.h"
#import "GameDetailsTableController.h"
#import "LevelViewController.h"
#import "LoadFileListController.h"
#import "MoveListView.h"
#import "MoveTableViewController.h"
#import "Options.h"
//#import "OptionsViewController.h"
#import "PGN.h"
#import "SetupViewController.h"

#import "BaseVC.h"


@implementation BoardVCOffline

@synthesize analysisView, bookMovesView, boardView, whiteClockView, blackClockView, moveListView, gameController, searchStatsView;

/// init

- (id)init {
    if (self = [super init]) {
        [self setTitle:[[NSBundle mainBundle] infoDictionary][@"CFBundleName"]];
        iPadBoardRectLandscape = CGRectMake(5, 49-44, 640, 640);
        iPadWhiteClockRectLandscape = CGRectMake(656, 49-44, 176, 59);
        iPadBlackClockRectLandscape = CGRectMake(656+176+8, 49-44, 176, 59);
        iPadMoveListRectLandscape = CGRectMake(656, 116-44, 360, 573);
        iPadBookRectLandscape = CGRectMake(5, 695-44, 640, 20);
        iPadAnalysisRectLandscape = CGRectMake(5, 721-44, 1011, 20);
        iPadSearchStatsRectLandscape = CGRectMake(656, 695-44, 360, 20);
        
        iPadBoardRectPortrait = CGRectMake(8, 52-44, 752, 752);
        iPadWhiteClockRectPortrait = CGRectMake(8, 814-44, 185, 59);
        iPadBlackClockRectPortrait = CGRectMake(8, 881-44, 185, 59);
        iPadMoveListRectPortrait = CGRectMake(203, 814-44, 760-203, 126);
        iPadBookRectPortrait = CGRectMake(8, 948-44, 752, 20);
        iPadAnalysisRectPortrait = CGRectMake(8, 975-44, 440, 20);
        iPadSearchStatsRectPortrait = CGRectMake(458, 975-44, 302, 20);
    }
    
    return self;
}


/// loadView creates and lays out all the subviews of the main window: The
/// board, the toolbar, the move list, and the small UILabels used to display
/// the engine analysis and the clocks.

- (void)loadView {
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        BOOL portrait = UIInterfaceOrientationIsPortrait([self interfaceOrientation]);
//
//        // Content view
//        CGRect appRect = [[UIScreen mainScreen] applicationFrame];
//        rootView = [[RootView alloc] initWithFrame: appRect];
//        [rootView setAutoresizesSubviews: YES];
//        [rootView setAutoresizingMask: (UIViewAutoresizingFlexibleWidth |
//                                        UIViewAutoresizingFlexibleHeight)];
//        //[rootView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
//        [rootView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
//        appRect.origin = CGPointMake(0.0f, 20.0f);
//
//        contentView = [[UIView alloc] initWithFrame: appRect];
//        [contentView setAutoresizesSubviews: YES];
//        [contentView setAutoresizingMask: (UIViewAutoresizingFlexibleWidth |
//                                           UIViewAutoresizingFlexibleHeight)];
//        //[contentView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
//        [contentView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
//        [rootView addSubview: contentView];
//        [self setView: rootView];
//
//        // Board
//        boardView = [[BoardView alloc] initWithFrame: portrait? iPadBoardRectPortrait : iPadBoardRectLandscape];
//        boardView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        boardView.layer.borderWidth = 1.0;
//        [contentView addSubview: boardView];
//
//        // Clocks
//        whiteClockView = [[UILabel alloc] initWithFrame: portrait? iPadWhiteClockRectPortrait : iPadWhiteClockRectLandscape];
//        [whiteClockView setFont: [UIFont systemFontOfSize: 25.0]];
//        [whiteClockView setTextAlignment: NSTextAlignmentCenter];
//        [whiteClockView setText: @"White: 5:00"];
//        [whiteClockView setBackgroundColor: [UIColor whiteColor]];
//        whiteClockView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        whiteClockView.layer.borderWidth = 1.0;
//
//        blackClockView = [[UILabel alloc] initWithFrame: portrait? iPadBlackClockRectPortrait : iPadBlackClockRectLandscape];
//        [blackClockView setFont: [UIFont systemFontOfSize: 25.0]];
//        [blackClockView setTextAlignment: NSTextAlignmentCenter];
//        [blackClockView setText: @"Black: 5:00"];
//        [blackClockView setBackgroundColor: [UIColor whiteColor]];
//        blackClockView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        blackClockView.layer.borderWidth = 1.0;
//
//        [contentView addSubview: whiteClockView];
//        [contentView addSubview: blackClockView];
//
//        // Move list
//        moveListView =
//        [[MoveListView alloc]
//         initWithFrame: portrait? iPadMoveListRectPortrait : iPadMoveListRectLandscape];
//        moveListView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        moveListView.layer.borderWidth = 1.0;
//        [contentView addSubview: moveListView];
//
//        // Book moves
//        bookMovesView = [[UILabel alloc] initWithFrame: portrait? iPadBookRectPortrait : iPadBookRectLandscape];
//        [bookMovesView setFont: [UIFont systemFontOfSize: 14.0]];
//        [bookMovesView setBackgroundColor: [UIColor whiteColor]];
//        bookMovesView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        bookMovesView.layer.borderWidth = 1.0;
//        [contentView addSubview: bookMovesView];
//
//        // Analysis
//        analysisView = [[UILabel alloc] initWithFrame: portrait? iPadAnalysisRectPortrait : iPadAnalysisRectLandscape];
//        analysisView.numberOfLines = 5;
//        [analysisView setFont: [UIFont systemFontOfSize: 14.0]];
//        [analysisView setBackgroundColor: [UIColor whiteColor]];
//        analysisView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        analysisView.layer.borderWidth = 1.0;
//        [contentView addSubview: analysisView];
//
//        // Search stats
//        searchStatsView = [[UILabel alloc] initWithFrame: portrait? iPadSearchStatsRectPortrait : iPadSearchStatsRectLandscape];
//        [searchStatsView setFont: [UIFont systemFontOfSize: 14.0]];
//        //[searchStatsView setTextAlignment: UITextAlignmentCenter];
//        [searchStatsView setBackgroundColor: [UIColor whiteColor]];
//        searchStatsView.layer.borderColor = [UIColor colorWithRed: 0.781 green: 0.777 blue: 0.797 alpha:1.0].CGColor;
//        searchStatsView.layer.borderWidth = 1.0;
//        [contentView addSubview: searchStatsView];
//
//        // Toolbar
//        toolbar = [[UIToolbar alloc]
//                   initWithFrame: CGRectMake(0, self.view.bounds.size.height-64, 1024, 44)];
//        [contentView addSubview: toolbar];
//        [toolbar setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
//
//        NSMutableArray *buttons = [[NSMutableArray alloc] init];
//        UIBarButtonItem *button;
//        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//
//        button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
//                                                  style: UIBarButtonItemStyleBordered
//                                                 target: self
//                                                 action: @selector(toolbarButtonPressed:)];
//        //[button setWidth: 58.0f];
//        [buttons addObject: button];
//        gameButton = button;
//        [buttons addObject: spacer];
//
//        button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
//                                                  style: UIBarButtonItemStyleBordered
//                                                 target: self
//                                                 action: @selector(toolbarButtonPressed:)];
//        //[button setWidth: 60.0f];
//        [buttons addObject: button];
//        optionsButton = button;
//        [buttons addObject: spacer];
//
//        button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
//                                                  style: UIBarButtonItemStyleBordered
//                                                 target: self
//                                                 action: @selector(toolbarButtonPressed:)];
//        [buttons addObject: button];
//        [buttons addObject: spacer];
//
//        button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
//                                                  style: UIBarButtonItemStyleBordered
//                                                 target: self
//                                                 action: @selector(toolbarButtonPressed:)];
//        //[button setWidth: 53.0f];
//        [buttons addObject: button];
//        moveButton = button;
//        [buttons addObject: spacer];
//
//        button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
//                                                  style: UIBarButtonItemStyleBordered
//                                                 target: self
//                                                 action: @selector(toolbarButtonPressed:)];
//        //[button setWidth: 49.0f];
//        [buttons addObject: button];
//
//        //[buttons addObject: spacer];
//
//        [toolbar setItems: buttons animated: YES];
//        [toolbar sizeToFit];
//        [toolbar setAutoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
//
//        [contentView bringSubviewToFront: boardView];
//
//        // Activity indicator
//        activityIndicator =
//        [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0,30,30)];
//        [activityIndicator setCenter: [boardView center]];
//        [activityIndicator
//         setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
//        [contentView addSubview: activityIndicator];
//        [activityIndicator startAnimating];
//    }
//    else { // iPhone or iPod touch
        // Content view
        CGRect appRect = [[UIScreen mainScreen] applicationFrame];
        rootView = [[RootView alloc] initWithFrame: appRect];
        //[rootView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
        [rootView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
        
        //appRect.origin = CGPointMake(0.0f, 20.0f);
        //appRect.size.height -= 20.0f;
        
        //contentView = [[UIView alloc] initWithFrame: appRect];
        
        [[NSBundle mainBundle] loadNibNamed:@"boardCustomView" owner:self options:nil];
        self.customViewOnTop.frame = appRect;
        [rootView addSubview: self.customViewOnTop];
        [self setView: rootView];
        
        self.customViewOnTop.translatesAutoresizingMaskIntoConstraints = false;
        [self.customViewOnTop.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self.customViewOnTop.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        [self.customViewOnTop.heightAnchor  constraintEqualToAnchor:self.view.heightAnchor].active = YES;
        [self.customViewOnTop.widthAnchor   constraintEqualToAnchor:self.view.widthAnchor].active = YES;
        
        // Board
        boardView = [[BoardView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, appRect.size.width, appRect.size.width)]; /*18.0f/*38.0f*//*18.0f*/
        [self.chessBoardView addSubview: boardView];
        //
        
        //Move list
        moveListView = [[MoveListView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, appRect.size.width, self.movesView.frame.size.height)];
        [self.movesView addSubview: moveListView];
        
        // Analysis
        analysisView = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, appRect.size.width, self.theAnalysisView.frame.size.height)];
        [analysisView setFont: [UIFont systemFontOfSize: 12.0]];
        analysisView.textColor = [UIColor whiteColor];
        [analysisView setBackgroundColor: [UIColor clearColor]];
        self.theAnalysisView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:28.0/255.0 blue:26.0/255.0 alpha:1.0               ];
        [self.theAnalysisView addSubview:analysisView];
        
        
        
        //      // Search stats
        //      searchStatsView = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, /*20.0f*/0.0f, appRect.size.width, 18.0f)];
        //      [searchStatsView setFont: [UIFont systemFontOfSize: 14.0]];
        //      //[searchStatsView setTextAlignment: UITextAlignmentCenter];
        //      //[searchStatsView setBackgroundColor: [UIColor lightGrayColor]];
        //      //[searchStatsView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
        //      [searchStatsView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
        //      [contentView addSubview: searchStatsView];
        //
        //      // Clocks
        //      whiteClockView =
        //         [[UILabel alloc] initWithFrame: CGRectMake(0.0f, /*20.0f*/ 0.0f, 0.5f * appRect.size.width, 18.0f)];
        //      [whiteClockView setFont: [UIFont systemFontOfSize: 14.0]];
        //      [whiteClockView setTextAlignment: NSTextAlignmentCenter];
        //      [whiteClockView setText: @"White: 5:00"];
        //      //[whiteClockView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
        //      [whiteClockView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
        //
        //      blackClockView =
        //         [[UILabel alloc] initWithFrame: CGRectMake(0.5f * appRect.size.width, /*20.0f*/ 0.0f, 0.5f * appRect.size.width, 18.0f)];
        //      [blackClockView setFont: [UIFont systemFontOfSize: 14.0]];
        //      [blackClockView setTextAlignment: NSTextAlignmentCenter];
        //      [blackClockView setText: @"Black: 5:00"];
        //      //[blackClockView setBackgroundColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha: 1.0]];
        //      [blackClockView setBackgroundColor: [UIColor colorWithRed:0.934 green:0.934 blue:0.953 alpha: 1.0]];
        //
        //      [contentView addSubview: whiteClockView];
        //      [contentView addSubview: blackClockView];
        //
        
        //
        //      // Book moves. Shared with analysis view on the iPhone.
        //      bookMovesView = analysisView;
        //
        //      // Move list
        //      float frameHeight = appRect.size.height;
        //      moveListView =
        //         [[MoveListView alloc]
        //            initWithFrame:
        //               CGRectMake(0.0f, appRect.size.width + /*56.0f*/ 36.0f, appRect.size.width,
        //                     frameHeight - appRect.size.width - /*56.0f*/ 36.0f - 44.0f)];
        //      [contentView addSubview: moveListView];
        //
        //      // Toolbar
        //      toolbar =
        //         [[UIToolbar alloc]
        //            initWithFrame: CGRectZero
        //               /*CGRectMake(0.0f, frameHeight-24.0f, appRect.size.width, 44.0f)*/];
        //      //[contentView addSubview: toolbar];
        //
        //      UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //
        //      NSMutableArray *buttons = [[NSMutableArray alloc] init];
        //      UIBarButtonItem *button;
        //
        //      //[buttons addObject: spacer];
        //      button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
        //                                                style: UIBarButtonItemStyleBordered
        //                                               target: self
        //                                               action: @selector(toolbarButtonPressed:)];
        //      [buttons addObject: button];
        //      [buttons addObject: spacer];
        //      button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
        //                                                style: UIBarButtonItemStyleBordered
        //                                               target: self
        //                                               action: @selector(toolbarButtonPressed:)];
        //      [buttons addObject: button];
        //      [buttons addObject: spacer];
        //      button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
        //                                                style: UIBarButtonItemStyleBordered
        //                                               target: self
        //                                               action: @selector(toolbarButtonPressed:)];
        //      [buttons addObject: button];
        //      [buttons addObject: spacer];
        //      button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
        //                                                style: UIBarButtonItemStyleBordered
        //                                               target: self
        //                                               action: @selector(toolbarButtonPressed:)];
        //      [buttons addObject: button];
        //      [buttons addObject: spacer];
        //      button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
        //                                                style: UIBarButtonItemStyleBordered
        //                                               target: self
        //                                               action: @selector(toolbarButtonPressed:)];
        //      [buttons addObject: button];
        //      //[buttons addObject: spacer];
        //
        //      [toolbar setItems: buttons animated: NO];
        //      toolbar.frame = CGRectMake(0.0f, frameHeight-44.0f, appRect.size.width, 44.0f);
        //      [contentView addSubview: toolbar];
        //      //[toolbar sizeToFit];
        //
        //      [contentView bringSubviewToFront: boardView];
        //
        //      // Activity indicator
        //      activityIndicator =
        //         [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0,0,30,30)];
        //      [activityIndicator setCenter: CGPointMake(0.5f * appRect.size.width, (18.0f / 16.0f) * appRect.size.width)];
        //      [activityIndicator
        //         setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
        //      [contentView addSubview: activityIndicator];
        //      [activityIndicator startAnimating];
    
/////}
    
    // Action sheets for menus.
    //   gameMenu = [[UIActionSheet alloc]
    //                    initWithTitle: nil
    //                         delegate: self
    //                cancelButtonTitle: @"Cancel"
    //                 destructiveButtonTitle: nil
    //                otherButtonTitles: @"New game", @"Save game", @"Load game", @"E-mail game", @"Edit position", @"Level/Game mode", nil];
    //   newGameMenu = [[UIActionSheet alloc] initWithTitle: nil
    //                                             delegate: self
    //                                    cancelButtonTitle: @"Cancel"
    //                               destructiveButtonTitle: nil
    //                                    otherButtonTitles:
    //                                           @"Play white", @"Play black", @"Play both", @"Analysis", nil];
    //   moveMenu = [[UIActionSheet alloc] initWithTitle: nil
    //                                          delegate: self
    //                                 cancelButtonTitle: @"Cancel"
    //                            destructiveButtonTitle: nil
    //                                 otherButtonTitles:
    //                                        @"Take back", @"Step forward", @"Take back all", @"Step forward all", @"Move list", @"Move now", nil];
    //   optionsMenu = nil;
    //   saveMenu = nil;
    //   emailMenu = nil;
    //   levelsMenu = nil;
    //   loadMenu = nil;
    //   moveListMenu = nil;
    //   popoverMenu = nil;
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isRunningForBlack:) name:@"isRunningForBlack" object:nil];
    
    
    
    //    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    //
    //    [[NSBundle mainBundle] loadNibNamed:@"boardCustomView" owner:self options:nil];
    //
    //    self.customViewOnTop.frame = appRect;
    //    [self.view addSubview:self.customViewOnTop];
    //    self.customViewOnTop.translatesAutoresizingMaskIntoConstraints = false;
    //    [self.customViewOnTop.topAnchor       constraintEqualToAnchor:self.chessBoardView.topAnchor].active = YES;
    //    [self.customViewOnTop.bottomAnchor    constraintEqualToAnchor:self.chessBoardView.bottomAnchor].active = YES;
    //    [self.customViewOnTop.leadingAnchor   constraintEqualToAnchor:self.chessBoardView.leadingAnchor constant:10.0].active = YES;
    //    [self.customViewOnTop.trailingAnchor  constraintEqualToAnchor:self.chessBoardView.trailingAnchor constant:20.0].active = YES;
    //    [self.customViewOnTop.heightAnchor    constraintEqualToAnchor:self.chessBoardView.heightAnchor].active = YES;
    //    [self.customViewOnTop.widthAnchor     constraintEqualToAnchor:self.chessBoardView.widthAnchor].active = YES;
    //
    //    NSLog(@"");
    
    //    [self.chessBoardView addSubview:boardView];
    //
    //
    //    boardView.translatesAutoresizingMaskIntoConstraints = false;
    //
    //    [boardView.topAnchor       constraintEqualToAnchor:self.chessBoardView.topAnchor].active = YES;
    //    [boardView.bottomAnchor    constraintEqualToAnchor:self.chessBoardView.bottomAnchor].active = YES;
    //    [boardView.leadingAnchor   constraintEqualToAnchor:self.chessBoardView.leadingAnchor constant:10.0].active = YES;
    //    [boardView.trailingAnchor  constraintEqualToAnchor:self.chessBoardView.trailingAnchor constant:20.0].active = YES;
    //    [boardView.heightAnchor    constraintEqualToAnchor:self.chessBoardView.heightAnchor].active = YES;
    //    [boardView.widthAnchor     constraintEqualToAnchor:self.chessBoardView.widthAnchor].active = YES;
    
    
    
    
    
}

-(void)isRunningForBlack:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    NSLog(@"••isRunningForBlack•• %@", dict[@"isRunningForBlack"]);
    BOOL isRunningForBlack = [dict[@"isRunningForBlack"]boolValue];
    if(isRunningForBlack) {
        self.activityIndicator.hidden = NO;
        self.compImgView.hidden = YES;
    } else {
        self.activityIndicator.hidden = YES;
        self.compImgView.hidden = NO;
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return interfaceOrientation == UIInterfaceOrientationPortrait;
}


- (BOOL)shouldAutorotate {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


- (NSUInteger)supportedInterfaceOrientations {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
    UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    //[rootView sizeToFit];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation {
    [boardView hideArrow];
    if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
        [boardView setFrame: iPadBoardRectLandscape];
        if (activityIndicator) [activityIndicator setCenter: [boardView center]];
        [whiteClockView setFrame: iPadWhiteClockRectLandscape];
        [blackClockView setFrame: iPadBlackClockRectLandscape];
        [moveListView setFrame: iPadMoveListRectLandscape];
        [bookMovesView setFrame: iPadBookRectLandscape];
        [analysisView setFrame: iPadAnalysisRectLandscape];
        [searchStatsView setFrame: iPadSearchStatsRectLandscape];
    }
    else {
        [boardView setFrame: iPadBoardRectPortrait];
        [whiteClockView setFrame: iPadWhiteClockRectPortrait];
        [blackClockView setFrame: iPadBlackClockRectPortrait];
        [moveListView setFrame: iPadMoveListRectPortrait];
        [bookMovesView setFrame: iPadBookRectPortrait];
        [analysisView setFrame: iPadAnalysisRectPortrait];
        [searchStatsView setFrame: iPadSearchStatsRectPortrait];
    }
    [gameController updateMoveList];
    [contentView bringSubviewToFront: toolbar];
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    
    // Why is this necessary for the move list menu, but not elsewhere?
    // I should try to find out. FIXME
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [moveListMenu dismissPopoverAnimated: YES];
        moveListMenu = nil;
    }
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView title] isEqualToString: @"Start new game?"]) {
        if (buttonIndex == 1)
            [gameController startNewGame];
    }
    else if ([[alertView title] isEqualToString:
              @"Exit Stockfish and send e-mail?"]) {
        if (buttonIndex == 1)
            [[UIApplication sharedApplication]
             openURL: [[NSURL alloc] initWithString: [gameController emailPgnString]]];
        
        /*
         [[UIApplication sharedApplication]
         openURL: [[NSURL alloc] initWithString:
         [gameController emailPgnString]]];
         */
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex: buttonIndex animated: NO];
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex: buttonIndex];
    
    if (actionSheet == gameMenu) {
        if ([buttonTitle isEqualToString: @"New game"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [newGameMenu showFromBarButtonItem: gameButton animated: YES];
                else
                    [newGameMenu showInView: contentView];
            });
        }
        else if ([buttonTitle isEqualToString: @"Save game"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSaveGameMenu];
            });
        else if ([buttonTitle isEqualToString: @"Load game"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoadGameMenu];
            });
        else if ([buttonTitle isEqualToString: @"E-mail game"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showEmailGameMenu];
            });
        else if ([buttonTitle isEqualToString: @"Edit position"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self editPosition];
            });
        else if ([buttonTitle isEqualToString: @"Level/Game mode"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLevelsMenu];
            });
    }
    else if (actionSheet == moveMenu) {
        if ([buttonTitle isEqualToString: @"Take back"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[Options sharedOptions] displayMoveGestureTakebackHint])
                    [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                                message: ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
                                                          @"You can also take back moves by swiping your finger from right to left in the move list window." :
                                                          @"You can also take back moves by swiping your finger from right to left in the move list area below the board.")
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil]
                     show];
                [gameController takeBackMove];
            });
        }
        else if ([buttonTitle isEqualToString: @"Step forward"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[Options sharedOptions] displayMoveGestureStepForwardHint])
                    [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                                message: ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
                                                          @"You can also step forward in the game by swiping your finger from left to right in the move list window." :
                                                          @"You can also step forward in the game by swiping your finger from left to right in the move list area below the board.")
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil]
                     show];
                [gameController replayMove];
            });
        }
        else if ([buttonTitle isEqualToString: @"Take back all"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [gameController takeBackAllMoves];
            });
        else if ([buttonTitle isEqualToString: @"Step forward all"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [gameController replayAllMoves];
            });
        else if ([buttonTitle isEqualToString: @"Move list"])
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMoveListMenu];
            });
        else if ([buttonTitle isEqualToString: @"Move now"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Move now, computers turn %d, thinking %d", [gameController computersTurnToMove], [gameController engineIsThinking]);
                if ([gameController computersTurnToMove]) {
                    if ([gameController engineIsThinking])
                        [gameController engineMoveNow];
                    else
                        [gameController engineGo];
                }
                else
                    [gameController startThinking];
            });
        }
    }
    else if (actionSheet == newGameMenu) {
        if ([buttonTitle isEqualToString: @"Play white"]) {
            NSLog(@"new game with white");
            [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
            [gameController setGameMode: GAME_MODE_COMPUTER_BLACK];
            [gameController startNewGame];
        }
        else if ([buttonTitle isEqualToString: @"Play black"]) {
            NSLog(@"new game with black");
            [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_WHITE];
            [gameController setGameMode: GAME_MODE_COMPUTER_WHITE];
            [gameController startNewGame];
        }
        else if ([buttonTitle isEqualToString: @"Play both"]) {
            NSLog(@"new game (both)");
            [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
            [gameController setGameMode: GAME_MODE_TWO_PLAYER];
            [gameController startNewGame];
        }
        else if ([buttonTitle isEqualToString: @"Analysis"]) {
            NSLog(@"new game (analysis)");
            [[Options sharedOptions] setGameMode: GAME_MODE_ANALYSE];
            [gameController setGameMode: GAME_MODE_ANALYSE];
            [gameController startNewGame];
        }
    }
}


- (void)toolbarButtonPressed:(id)sender {
    NSString *title = [sender title];
    
    // Ignore duplicate presses on the "Game" and "Move" buttons:
    if (([gameMenu isVisible] && [title isEqualToString: @"Game"]) ||
        ([moveMenu isVisible] && [title isEqualToString: @"Move"]))
        return;
    
    // Dismiss action sheet popovers, if visible:
    if ([gameMenu isVisible] && ![title isEqualToString: @"Game"])
        [gameMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if ([newGameMenu isVisible])
        [newGameMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if ([moveMenu isVisible])
        [moveMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if (optionsMenu != nil) {
        [optionsMenu dismissPopoverAnimated: YES];
        optionsMenu = nil;
    }
    if (levelsMenu != nil) {
        [levelsMenu dismissPopoverAnimated: YES];
        levelsMenu = nil;
    }
    if (saveMenu != nil) {
        [saveMenu dismissPopoverAnimated: YES];
        saveMenu = nil;
    }
    if (emailMenu != nil) {
        [emailMenu dismissPopoverAnimated: YES];
        emailMenu = nil;
    }
    if (loadMenu != nil) {
        [loadMenu dismissPopoverAnimated: YES];
        loadMenu = nil;
    }
    if (moveListMenu != nil) {
        [moveListMenu dismissPopoverAnimated: YES];
        moveListMenu = nil;
    }
    if (popoverMenu != nil) {
        [popoverMenu dismissPopoverAnimated: YES];
        popoverMenu = nil;
    }
    
    if ([title isEqualToString: @"Game"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [gameMenu showFromBarButtonItem: sender animated: YES];
        else
            [gameMenu showInView: contentView];
    }
    else if ([title isEqualToString: @"Options"])
        [self showOptionsMenu];
    else if ([title isEqualToString: @"Flip"])
        [gameController rotateBoard];
    else if ([title isEqualToString: @"Move"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [moveMenu showFromBarButtonItem: sender animated: YES];
        else
            [moveMenu showInView: contentView];
    }
    else if ([title isEqualToString: @"Hint"])
        [gameController showHint];
    else if ([title isEqualToString: @"New"]) {
        [gameController startNewGame];
    }
    else {
        NSLog(@"%@", [sender title]);
    }
}


- (void)showOptionsMenu {
    //OptionsViewController *ovc;
    //ovc = [[OptionsViewController alloc] initWithBoardVCOffline:self];
//    navigationController =
//    [[UINavigationController alloc]
//     initWithRootViewController: ovc];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        optionsMenu = [[UIPopoverController alloc]
//                       initWithContentViewController: navigationController];
//        [optionsMenu presentPopoverFromBarButtonItem: optionsButton
//                            permittedArrowDirections: UIPopoverArrowDirectionAny
//                                            animated: YES];
//    }
//    else {
//        CGRect r = [[navigationController view] frame];
//        // Why do I suddenly have to use -20.0f for the Y coordinate below?
//        // 0.0f seems right, and used to work in SDK 2.x.
//        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
//        r.origin = CGPointMake(0.0f, 0.0f);
//        [[navigationController view] setFrame: r];
//        [rootView insertSubview: [navigationController view] atIndex: 0];
//        [rootView flipSubviewsLeft];
//    }
}

//- (void)optionsMenuDonePressed {
//   NSLog(@"options menu done");
//   if ([[Options sharedOptions] bookVarietyWasChanged])
//      [gameController showBookMoves];
//   if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//      [optionsMenu dismissPopoverAnimated: YES];
//      optionsMenu = nil;
//   } else {
//      [rootView flipSubviewsRight];
//      [[navigationController view] removeFromSuperview];
//   }
//}
- (void)optionsMenuDonePressed { //modified
    NSLog(@"options menu done");
    if ([[Options sharedOptions] bookVarietyWasChanged])
        [gameController showBookMoves];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[optionsMenu dismissPopoverAnimated: YES];
        optionsMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        //[[navigationController view] removeFromSuperview];
    }
    //.....
}


- (void)showLevelsMenu {
    NSLog(@"levels menu");
    LevelViewController *lvc;
    lvc = [[LevelViewController alloc] initWithBoardVCOffline: self];
    navigationController =
    [[UINavigationController alloc]
     initWithRootViewController: lvc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        levelsMenu = [[UIPopoverController alloc]
                      initWithContentViewController: navigationController];
        [levelsMenu presentPopoverFromBarButtonItem: gameButton
                           permittedArrowDirections: UIPopoverArrowDirectionAny
                                           animated: YES];
    } else {
        CGRect r = [[navigationController view] frame];
        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        // 0.0f seems right, and used to work in SDK 2.x.
        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)levelWasChanged {
    [gameController setGameLevel: [[Options sharedOptions] gameLevel]];
}


- (void)gameModeWasChanged {
    [gameController setGameMode: [[Options sharedOptions] gameMode]];
}

- (void)levelsMenuDonePressed {
    NSLog(@"options menu done");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [levelsMenu dismissPopoverAnimated: YES];
        levelsMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)editPosition {
    SetupViewController *svc =
    [[SetupViewController alloc]
     initWithBoardVCOffline: self
     fen: [[gameController game] currentFEN]];
    navigationController =
    [[UINavigationController alloc] initWithRootViewController: svc];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        popoverMenu = [[UIPopoverController alloc]
                       initWithContentViewController: navigationController];
        //[popoverMenu setPopoverContentSize: CGSizeMake(320.0f, 460.0f)];
        [popoverMenu presentPopoverFromBarButtonItem: gameButton
                            permittedArrowDirections: UIPopoverArrowDirectionAny
                                            animated: NO];
    } else {
        CGRect r = [[navigationController view] frame];
        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        // 0.0f seems right, and used to work in SDK 2.x.
        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)editPositionCancelPressed {
    NSLog(@"edit position cancel");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [popoverMenu dismissPopoverAnimated: YES];
        popoverMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)editPositionDonePressed:(NSString *)fen {
    NSLog(@"edit position done: %@", fen);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [popoverMenu dismissPopoverAnimated: YES];
        popoverMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
    [boardView hideLastMove];
    [gameController gameFromFEN: fen];
}


- (void)showSaveGameMenu { 
    GameDetailsTableController *gdtc = [[GameDetailsTableController alloc] initWithBoardVCOffline:self game: [gameController game] email: NO];
    navigationController = [[UINavigationController alloc] initWithRootViewController: gdtc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        saveMenu = [[UIPopoverController alloc] initWithContentViewController: navigationController];
        [saveMenu presentPopoverFromBarButtonItem: gameButton permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
    } else {
        CGRect r = [[navigationController view] frame];
        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        // 0.0f seems right, and used to work in SDK 2.x.
        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)saveMenuDonePressed {
    if ([[[Options sharedOptions] saveGameFile] isEqualToString: @"Clipboard"]) {
        [[UIPasteboard generalPasteboard] setString: [[gameController game] pgnString]];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"" message:@"Your game was saved to the clipboard."
                              delegate: nil
                              cancelButtonTitle: nil
                              otherButtonTitles: @"OK", nil];
        [alert show];
    } else {
        FILE *pgnFile =
        fopen([[PGN_DIRECTORY
                stringByAppendingPathComponent: [[Options sharedOptions] saveGameFile]] UTF8String],
              "a");
        if (pgnFile != NULL) {
            fprintf(pgnFile, "%s", [[[gameController game] pgnString] UTF8String]);
            fclose(pgnFile);
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [saveMenu dismissPopoverAnimated: YES];
        saveMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
    NSLog(@"save game done");
}


- (void)saveMenuCancelPressed {
    NSLog(@"save game canceled");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [saveMenu dismissPopoverAnimated: YES];
        saveMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)showLoadGameMenu {
    LoadFileListController *lflc = [[LoadFileListController alloc] initWithBoardVCOffline: self];
    navigationController =
    [[UINavigationController alloc] initWithRootViewController: lflc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        loadMenu = [[UIPopoverController alloc]
                    initWithContentViewController: navigationController];
        [loadMenu presentPopoverFromBarButtonItem: gameButton
                         permittedArrowDirections: UIPopoverArrowDirectionAny
                                         animated: YES];
    } else {
        CGRect r = [[navigationController view] frame];
        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        // 0.0f seems right, and used to work in SDK 2.x.
        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)loadMenuCancelPressed {
    NSLog(@"load game canceled");
    [[Options sharedOptions] setLoadGameFile: @""];
    [[Options sharedOptions] setLoadGameFileGameNumber: 0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [loadMenu dismissPopoverAnimated: YES];
        loadMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)loadMenuDonePressedWithGame:(NSString *)gameString {
    NSLog(@"load menu done, gameString = %@", gameString);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [loadMenu dismissPopoverAnimated: YES];
        loadMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
    [gameController gameFromPGNString: gameString
                    loadFromBeginning: YES];
    [boardView hideLastMove];
}


- (void)showEmailGameMenu {
    GameDetailsTableController *gdtc = [[GameDetailsTableController alloc] initWithBoardVCOffline: self game: [gameController game] email: YES];
    navigationController =
    [[UINavigationController alloc] initWithRootViewController: gdtc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        emailMenu = [[UIPopoverController alloc]
                     initWithContentViewController: navigationController];
        [emailMenu presentPopoverFromBarButtonItem: gameButton
                          permittedArrowDirections: UIPopoverArrowDirectionAny
                                          animated: YES];
    } else {
        CGRect r = [[navigationController view] frame];
        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        // 0.0f seems right, and used to work in SDK 2.x.
        // Update 2013-06-11: A value of 0.0f is suddenly right again in iOS 7.
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)emailMenuDonePressed {
    NSLog(@"email game done");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [emailMenu dismissPopoverAnimated: YES];
        emailMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
    [[[UIAlertView alloc] initWithTitle: @"Exit Stockfish and send e-mail?"
                                message: @""
                               delegate: self
                      cancelButtonTitle: @"Cancel"
                      otherButtonTitles: @"OK", nil]
     show];
}


- (void)emailMenuCancelPressed {
    NSLog(@"email game canceled");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [emailMenu dismissPopoverAnimated: YES];
        emailMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)showMoveListMenu {
    MoveTableViewController *mtvc = [[MoveTableViewController alloc]
                                     initWithBoardVCOffline: self
                                     game: [gameController game]];
    navigationController = [[UINavigationController alloc]
                            initWithRootViewController: mtvc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        moveListMenu = [[UIPopoverController alloc]
                        initWithContentViewController: navigationController];
        [moveListMenu presentPopoverFromBarButtonItem: moveButton
                             permittedArrowDirections: UIPopoverArrowDirectionAny
                                             animated: YES];
    } else {
        CGRect r = [[navigationController view] frame];
        r.origin = CGPointMake(0.0f, 0.0f);
        [[navigationController view] setFrame: r];
        [rootView insertSubview: [navigationController view] atIndex: 0];
        [rootView flipSubviewsLeft];
    }
}


- (void)moveListMenuDonePressed:(int)ply {
    if (ply >= 0)
        [gameController jumpToPly: ply animate: YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [moveListMenu dismissPopoverAnimated: YES];
        moveListMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)moveListMenuCancelPressed {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [moveListMenu dismissPopoverAnimated: YES];
        moveListMenu = nil;
    } else {
        [rootView flipSubviewsRight];
        [[navigationController view] removeFromSuperview];
    }
}


- (void)stopActivityIndicator {
    if (activityIndicator) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }
}


- (void)hideAnalysis {
    [analysisView setText: @""];
    [searchStatsView setText: @""];
    if ([[Options sharedOptions] showBookMoves])
        [gameController showBookMoves];
}


- (void)hideBookMoves {
    if ([[analysisView text] hasPrefix: @"  Book"])
        [analysisView setText: @""];
}


- (void)showBookMoves {
    [gameController showBookMoves];
}



- (IBAction)settingsBtnAction:(id)sender {
    [self.basevc showOptions];
}

- (IBAction)bottomBtnAction:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *neww = [UIAlertAction actionWithTitle:@"New" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
                               [self.basevc showHideAnalysis:NO];
                               self.theAnalysisView.hidden = YES;
                               [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
                               [gameController setGameMode: GAME_MODE_COMPUTER_BLACK];
                               [gameController startNewGame];
                               NSLog(@"NEW NEW NEW NEW NEW NEW NEW NEW NEW NEW ");
                           }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
                               [self.basevc saveState];
                               NSLog(@"SAVE SAVE SAVE SAVE SAVE SAVE SAVE SAVE ");
                           }];
    
    UIAlertAction *flip = [UIAlertAction actionWithTitle:@"Flip Board" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
                               [gameController rotateBoard];
                               NSLog(@"FLIP FLIP FLIP FLIP FLIP FLIP FLIP FLIP ");
                           }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {
                             }];
    
    [actionSheet addAction:neww];
    [actionSheet addAction:save];
    [actionSheet addAction:flip];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (IBAction)bottomCompBtnAction:(id)sender {
    [self toggleShowAnalysisAndMoveView];
}

- (IBAction)topBtnAction:(id)sender {
    [self.basevc saveState];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backMoveBtnAction:(id)sender {
    [gameController takeBackMove];
}

- (IBAction)fwdMoveBtnAction:(id)sender {
    [gameController replayMove];
}

-(void)newGamePlayAsWhite{
    [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_BLACK];
    [gameController setGameMode: GAME_MODE_COMPUTER_BLACK];
    [gameController startNewGame];
}

-(void)toggleShowAnalysisAndMoveView {
    BOOL b = [[Options sharedOptions]showAnalysis];
    if (b == YES) {
        [self.basevc showHideAnalysis:NO];
        self.theAnalysisView.hidden = YES;
    } else {
        [self.basevc showHideAnalysis:YES];
        self.theAnalysisView.hidden = NO;
    }
}






- (void)SubscribeToStockfishPlayOfflineNotifications:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] addObserver:subscriber
                                             selector:@selector(StockfishPlayOfflineQuit:)
                                                 name:@"StockfishPlayOfflineQuit"
                                               object:self];
}
- (void)UnsubscribeToStockfishPlayOfflineNotifications:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] removeObserver:subscriber];
}
- (void)SetGameInfo:(NSString *)info
{
    gameInfo.text = info;
}

@end

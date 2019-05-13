//
//  MainViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/13/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "MainViewController.h"
#import "AppOptions.h"
//#import "AppThemes.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet nButton *buttonPlayOffline;
@property (weak, nonatomic) IBOutlet nButton *buttonPlayOnline;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonTheme;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonAbout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonDisplay;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonSound;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarForBarButtons;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;

/// @description this is for display settings for the app
//@property (strong) nSlider *sliderDisplay;
/// @description this is for sound settings for the app
@property (strong) MPVolumeView *sliderVolumeController;
//@property (strong) nSlider *sliderVolume;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set controls and themes
    [self SetControlsAndThemes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// @description all new controls/views additions, modification to present controls/views and themes in this method
- (void)SetControlsAndThemes
{
    // set background
    //    [[AppOptions AppOptionsInstance].themes DefaultBackground:self.view];
    //[[AppOptions AppOptionsInstance].themes ThemeBackGround:self.view IsOptional:NO];
    
    // set background
    //[self.view sendSubviewToBack:self.imageViewBackground];
    self.imageViewBackground.image = [UIImage imageNamed:@"backgroundLight"];
    
    // set bottom's additional app menu bar color
    self.toolBarForBarButtons.backgroundColor = [UIColor colorWithHexString:@"#0b2744"];
    
    // set images and color for additional menu buttons
    self.barButtonAbout.image = [ImageEditing ImageByScalingImage:self.barButtonAbout.image ByValue:3];
    self.barButtonAbout.tintColor = [UIColor whiteColor];
    
    self.barButtonDisplay.image = [ImageEditing ImageByScalingImage:self.barButtonDisplay.image ByValue:3];
    self.barButtonDisplay.tintColor = [UIColor whiteColor];

    self.barButtonSound.image = [ImageEditing ImageByScalingImage:self.barButtonSound.image ByValue:3];
    self.barButtonSound.tintColor = [UIColor whiteColor];
    
    self.barButtonTheme.image = [ImageEditing ImageByScalingImage:self.barButtonTheme.image ByValue:3];
    self.barButtonTheme.tintColor = [UIColor whiteColor];
    
    
    // set display slider
//    self.sliderDisplay = [nSlider nSliderWithSliderValue:[AppOptions DisplayBrightness]
//                                      SliderMinimumValue:0.0f
//                                      SliderMaximumValue:1.0f
//                                 OptionalBackgroundColor:nil
//                                           OptionalImage:nil
//                                  OptionalImageTintColor:nil
//                               OptionalMinimumTrackImage:nil
//                      OptionalMinimumTrackImageTintColor:[UIColor colorWithHexString:@"#0b2744"]
//                               OptionalMaximumTrackImage:nil
//                      OptionalMaximumTrackImageTintColor:nil];
//    [self.sliderDisplay addTarget:self action:@selector(SliderDisplayValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // set sound slider
//    self.sliderVolumeController = [nSlider initAsMPVolumeViewWithOptionalImage:nil
//                                                          OptionalMinimumImage:nil
//                                                          OptionalMaximumImage:nil];
//    self.sliderVolume = [nSlider nSliderWithSliderValue:0.5f
//                                     SliderMinimumValue:0.0f
//                                     SliderMaximumValue:1.0f
//                                OptionalBackgroundColor:nil
//                                          OptionalImage:nil
//                                 OptionalImageTintColor:nil
//                              OptionalMinimumTrackImage:nil
//                     OptionalMinimumTrackImageTintColor:[UIColor colorWithHexString:@"#0b2744"]
//                              OptionalMaximumTrackImage:nil
//                     OptionalMaximumTrackImageTintColor:nil];
//    [self.sliderVolume addTarget:self action:@selector(SliderVolumeValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    // set play offline button theme
    [self.buttonPlayOffline SetAsDualColorButtonWithText:self.buttonPlayOffline.titleLabel.text
                                               TextColor:[UIColor colorWithHexString:@"#0b2744"]
                                            TextFontType:self.buttonPlayOffline.titleLabel.font
                                             TextScaling:10
                                           TextAlignment:NSTextAlignmentCenter
                                                   Image:[UIImage imageNamed:@"iconPlayOffline"]
                                     ImageScalingPercent:10
                                          ImageTintColor:[UIColor whiteColor]
                                         ImageOnLeftSide:YES
                                               LeftColor:[UIColor colorWithHexString:@"#0b2744"]
                                        LeftColorPercent:30
                                              RightColor:[UIColor whiteColor]
                                            CornerRadius:5
                                            Transparency:1
                                         DropShadowColor:nil
                                        DropShadowRadius:0
                                       DropShadowOpacity:0
                                        DropShadowOffset:CGSizeZero];
    
    // set play online button theme
    [self.buttonPlayOnline SetAsDualColorButtonWithText:self.buttonPlayOnline.titleLabel.text
                                              TextColor:[UIColor colorWithHexString:@"#0b2744"]
                                           TextFontType:self.buttonPlayOnline.titleLabel.font
                                            TextScaling:10
                                          TextAlignment:NSTextAlignmentCenter
                                                  Image:[UIImage imageNamed:@"iconPlayOnline"]
                                    ImageScalingPercent:10
                                         ImageTintColor:[UIColor whiteColor]
                                        ImageOnLeftSide:NO
                                              LeftColor:[UIColor whiteColor]
                                       LeftColorPercent:70
                                             RightColor:[UIColor colorWithHexString:@"#0b2744"]
                                           CornerRadius:5
                                           Transparency:1
                                        DropShadowColor:nil
                                       DropShadowRadius:0
                                      DropShadowOpacity:0
                                       DropShadowOffset:CGSizeZero];
}

- (void)SliderDisplayValueChanged:(id)sender
{
//    [AppOptions SetDisplayBrightness:((nSlider*)sender).value];
}

- (IBAction)BarButtonDisplayTapped
{
//    RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"Brightness" view:self.sliderDisplay];
//    [alert show];
}

- (void)SliderVolumeValueChanged:(id)sender
{
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [self.sliderVolumeController subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
//    [volumeViewSlider setValue:((nSlider*)sender).value animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)BarButtonSoundTapped:(id)sender
{
//    RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"Volume" view:self.sliderVolume];
//    [alert show];
}

- (IBAction)BarButtonThemeTapped:(id)sender
{
//    RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"Theme" view:nil];
//    [alert show];
}

- (IBAction)BarButtonAboutTapped:(id)sender
{
//    RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"Infinity Chess" message:(NSString*)[AppOptions GetKeyValue:@"About Infinity Chess"] messageFontSize:10.f];
//    [alert show];
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

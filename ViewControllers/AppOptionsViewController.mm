//
//  OptionsViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/17/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "AppOptionsViewController.h"
#import "AppOptions.h"
//#import "AppThemes.h"

@interface AppOptionsViewController ()

@end

@implementation AppOptionsViewController

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
    
    // set background
//    [[AppOptions AppOptionsInstance].themes OptionsBackground:self.view];
    //[[AppOptions AppOptionsInstance].themes ThemeBackGround:self.view IsOptional:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ButtonHomeClick:(id)sender
{
    // just return to main menu
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

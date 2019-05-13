//
//  RoomInfoScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 5/8/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "RoomInfoScreenViewController.h"
#import "AppOptions.h"
#import "CommonTasks.h"

@interface RoomInfoScreenViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webviewRoomInfo;

@end

@implementation RoomInfoScreenViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self SetControlsAndThemes];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *query = @"KeyName='HTMLPagesURL'";
    NSFetchRequest *request = [NSFetchRequest new];
    [request setPredicate:[NSPredicate predicateWithFormat:query]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.ServerKeyValues.columnSerialNumberName ascending:YES]]];
    NSArray *result = [self.appOnline.User.ServerKeyValues FetchRowsAgainstQuery:request];
    if (result && result.count == 1)
    {
        NSString *url = [NSString stringWithFormat:@"%@%@.html", [result[0] valueForKey:@"Value"], self.appOnline.User.RoomID];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            [self.webviewRoomInfo loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (void)SetControlsAndThemes
{
    self.view.frame = self.viewFrame;
    self.view.autoresizesSubviews = YES;
    [self.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight)];
    
    // load web vied data
    [self LoadWebViewData];
}

- (void)LoadWebViewData
{
    if (self.appOnline.User != nil)
        if (self.appOnline.User.RoomInfoAppData != nil && self.appOnline.User.RoomInfoAppData.count > 0)
        {
            NSString *title = [self GetDefaultTitle];
            NSString *html = [self GetDefaultHtml];
            
            DataTable *roomDescription = [self.appOnline.User.RoomInfoAppData objectForKey:@"RoomDescription"];
            if (roomDescription && roomDescription.NumberOfRowsInTable > 0)
            {
                if ([[roomDescription GetColumnsName] containsObject:@"Html"])
                {
                    NSData *descriptionData = [[NSData alloc] initWithBase64EncodedString:[roomDescription FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"Html"] options:0];
                    html =[[NSString alloc] initWithData:descriptionData encoding:NSUTF8StringEncoding];
                }
                if ([[roomDescription GetColumnsName] containsObject:@"Description"])
                    title = [roomDescription FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"Description"];
            }
            
            NSString *description = [NSString stringWithFormat:@"<h2>%@</h2>%@", title, html];
            [self.webviewRoomInfo loadHTMLString:description baseURL:[NSURL URLWithString:[CommonTasks InfinityChessWebsite]]];
        }
}

- (NSString*)GetDefaultTitle
{
    NSString *query = [NSString stringWithFormat:@"RoomID='%@'", self.appOnline.User.RoomID];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setPredicate:[NSPredicate predicateWithFormat:query]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
    NSArray *result = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
    return [result[0] valueForKey:@"Name"];
}

- (NSString*)GetDefaultHtml
{
    return (NSString*)[AppOptions GetKeyValue:@"Default Room Info"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

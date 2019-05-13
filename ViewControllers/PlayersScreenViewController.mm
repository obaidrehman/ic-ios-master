//
//  PlayersScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "PlayersScreenViewController.h"


@interface PlayersScreenViewController ()

@end

@implementation PlayersScreenViewController
{
    NSArray *roomUsers;
    UITableView *thisTableView;
    
    nTextField *textFieldForPrivateChat;
    nButton *buttonForPrivateChat;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    roomUsers = [[self.appOnline.User.RoomInfoAppData objectForKey:@"Users"] FetchAllRowsFromTable];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!roomUsers || (roomUsers && roomUsers.count == 0))
    {
//        RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"PlayersLess Room!" message:@"there are no players in this room!"];
//        [alert show];
        
        NSLog(@"PlayersLess Room! there are no players in this room!");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ResetRoomUsers
{
    roomUsers = [[self.appOnline.User.RoomInfoAppData objectForKey:@"Users"] FetchAllRowsFromTable];
    
    if (!roomUsers || (roomUsers && roomUsers.count == 0))
    {
        NSLog(@"PlayersLess Room!  there are no players in this room");
    }
    
    [thisTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // just a necessary step
    thisTableView = tableView;
    
    // Return the number of sections.
    if (roomUsers)
        return 1;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (roomUsers)
        return roomUsers.count;
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (roomUsers && roomUsers.count > 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [roomUsers[indexPath.row] valueForKey:@"UserName"]];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#0b2744"];
        
        switch ([[roomUsers[indexPath.row] valueForKey:@"RankID"] intValue])
        {
            case userRankKing:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconKing"] ByValue:3];
                break;
            case userRankQueen:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconQueen"] ByValue:3];
                break;
            case userRankRook:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconRook"] ByValue:3];
                break;
            case userRankBishop:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconBishop"] ByValue:3];
                break;
            case userRankKnight:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconKnight"] ByValue:3];
                break;
            case userRankPawn:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconPawn"] ByValue:3];
                break;
            case userRankNone:
            default:
                cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconGuest"] ByValue:3];
                break;
        }
        [ImageEditing ImageApplyTintColorToImageView:cell.imageView TintColor:[UIColor colorWithHexString:@"#0b2744"]];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [roomUsers[indexPath.row] valueForKey:@"CountryName"]];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSArray *items = @[
//                      [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"iconPlayerInfo"] title:@"Player Info"],
//                      [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"iconPrivateChat"] title:@"Private Chat"],
//                      ];
//    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, items.count)]];
//    gridMenu.extraInfo = indexPath;
//    gridMenu.delegate = self;
//    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex
//{
//    NSIndexPath *indexPath = (NSIndexPath*)gridMenu.extraInfo;
//
//    if ([item.title isEqualToString:@"Player Info"])
//    {
//        NSMutableString *message = [[NSMutableString alloc] init];
//
//        for (NSString *columnName in [roomUsers[indexPath.row] entity].attributesByName.allKeys)
//        {
//            if ([columnName isEqualToString:@"RankID"] ||
//                [columnName isEqualToString:@"RoleID"] ||
//                [columnName isEqualToString:@"RowIndex"] ||
//                [columnName isEqualToString:@"UserID"] ||
//                [columnName isEqualToString:@"UserStatusID"] ||
//                [columnName isEqualToString:@"UserName"]) {
//                continue;
//            }
//            [message appendFormat:@"%@:  %@\n", columnName, [roomUsers[indexPath.row] valueForKey:columnName]];
//        }
//
//        NSLog(@"%@", message);
//    }
//    else if ([item.title isEqualToString:@"Private Chat"])
//    {
//        textFieldForPrivateChat = [[nTextField alloc] init];
//        textFieldForPrivateChat.enabled = YES;
//        textFieldForPrivateChat.borderStyle = UITextBorderStyleLine;
//
//        buttonForPrivateChat = [[nButton alloc] init];
//        [buttonForPrivateChat addTarget:self action:@selector(ButtonForPrivateChatTapped:) forControlEvents:UIControlEventTouchUpInside];
//        buttonForPrivateChat.extraInfo = roomUsers[indexPath.row];
//
//
//        nView *chatView = [[nView alloc] initAsPrivateChatViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100.f, 50.f)
//                                                              TextField:textFieldForPrivateChat
//                                                          andSendButton:buttonForPrivateChat];
//
//
//        RNBlurModalView *chatAlert = [[RNBlurModalView alloc] initWithParentView:self.parentViewController.view title:item.title view:chatView];
//        textFieldForPrivateChat.extraInfo = chatAlert;
//
//        [chatAlert show];
//    }
//    else
//    {
//
//    }
//}

- (void)ButtonForPrivateChatTapped:(id)sender
{
    if (textFieldForPrivateChat && !textFieldForPrivateChat.text.isEmptyOrWhiteSpaces)
    {
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                
                [self.appOnline SendChatMessage:textFieldForPrivateChat.text
                                  ChatMessageID:[buttonForPrivateChat.extraInfo valueForKey:@"UserID"]
                                         ToUser:[buttonForPrivateChat.extraInfo valueForKey:@"UserName"]
                                     WithGameID:[CommonTasks Zero]
                                       ChatType:chatTypeAllWindows
                                    MessageType:chatMessageTypeText
                                   AudienceType:chatAudienceTypeIndividual];
                
            }];
        }
        
    }
    
    //if (textFieldForPrivateChat)
        //[(RNBlurModalView *)textFieldForPrivateChat.extraInfo hide];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 10 * 2, 50.0f)];
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    
    [label setText:@"Players"];
    
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"#0b2744"]]; //your background color...
   
    return headerView;
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

//
//  RoomsScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/21/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "RoomsScreenViewController.h"
#import "CommonTasks.h"
#import "PlayOnlineMainScreenViewController.h"
#import "AppOptions.h"
#import "MyManager.h"

@interface RoomsScreenViewController ()

@end

@implementation RoomsScreenViewController
{
    /// @description this is for rooms listing
    NSArray *rooms;

    /// @description parent room should always hold one value only, and that is the parent room id/name ok!
    NSDictionary *parentRoom;
}

/// @description use this when loading root level rooms
- (void) setRoomListingWhenUserInRootRoom
{
    parentRoom = [NSDictionary dictionaryWithObjectsAndKeys:@"Rooms", @"0", nil]; // default no room
    NSString *query = @"ParentID=nil OR ParentID=''";
    NSFetchRequest *request = [NSFetchRequest new];
    [request setPredicate:[NSPredicate predicateWithFormat:query]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
    rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
}

/// @description use this when going back to parent room listing from parentroom
- (void) setRoomListingWhenUserNavigatingBackToParentRoom
{
    // get parent room
    // get parent room's parent if any
        // if (parent found) - get all child room for that parent as list
        // else load root room list
    
    if (parentRoom && [[parentRoom allKeys][0] intValue] != 0)
    {
        // first get parent room from apponline user rooms
        NSString *query = [NSString stringWithFormat:@"RoomID='%@'", [parentRoom allKeys][0]];
        NSFetchRequest *request = [NSFetchRequest new];
        [request setPredicate:[NSPredicate predicateWithFormat:query]];
        [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
        rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
        if (rooms && rooms.count == 1) // there is only one parent room
        {
            // now get parent room for current user's room
            query = [NSString stringWithFormat:@"RoomID='%@'", [rooms[0] valueForKey:@"ParentID"]];
            request = [NSFetchRequest new];
            [request setPredicate:[NSPredicate predicateWithFormat:query]];
            [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
            rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
            if (rooms && rooms.count == 1) // there is only one parent room to parent room
            {
                // keep reference to parent room name and id, it is needed later in this class
                parentRoom = [NSDictionary dictionaryWithObjectsAndKeys:[rooms[0] valueForKey:@"Name"], [rooms[0] valueForKey:@"RoomID"], nil];
                
                // now get all child rooms for this parent room, so the list can be displayed
                query = [NSString stringWithFormat:@"ParentID='%@'", [parentRoom allKeys][0]];
                request = [NSFetchRequest new];
                [request setPredicate:[NSPredicate predicateWithFormat:query]];
                [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
                rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
            }
            else
                [self setRoomListingWhenUserInRootRoom];
        }
        else
            [self setRoomListingWhenUserInRootRoom];
    }
}

/// @description use this when going forward that is selected a room and moving to its child room listing
- (void) setRoomListingWhenUserNavigatingForthToChildRooms
{
    // get all child rooms for parent room, since parent room was already set to the selected room whose child room list was required
    
    NSString *query = [NSString stringWithFormat:@"ParentID='%@'", [parentRoom allKeys][0]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setPredicate:[NSPredicate predicateWithFormat:query]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
    rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
    if (rooms && rooms.count <= 0)
    {
        // something went wrong? there are no child rooms?
        [self setRoomListingWhenUserNavigatingBackToParentRoom];
    }
}

/// @description use this when loading room list with reference to User.RoomID
- (void) setRoomListingWhenUserRoomIDIsNotNull
{
    // get user's room
    // get user's room parent
    // get all child room list for this parent
    
    if ([self.appOnline.User.RoomID intValue] != 0)
    {
        // first get current room from apponline user rooms
        NSString *query = [NSString stringWithFormat:@"RoomID='%@'", self.appOnline.User.RoomID];
        NSFetchRequest *request = [NSFetchRequest new];
        [request setPredicate:[NSPredicate predicateWithFormat:query]];
        [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
        rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
        if (rooms && rooms.count == 1) // there is only one room with User.RoomID
        {
            // now get parent room for current user's room
            query = [NSString stringWithFormat:@"RoomID='%@'", [rooms[0] valueForKey:@"ParentID"]];
            request = [NSFetchRequest new];
            [request setPredicate:[NSPredicate predicateWithFormat:query]];
            [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
            rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
            if (rooms && rooms.count == 1) // there is only one parent room to User.RoomID
            {
                // keep reference to parent room name and id, it is needed later in this class
                parentRoom = [NSDictionary dictionaryWithObjectsAndKeys:[rooms[0] valueForKey:@"Name"], [rooms[0] valueForKey:@"RoomID"], nil];
                
                // now get all child rooms for this parent room, so the list can be displayed
                query = [NSString stringWithFormat:@"ParentID='%@'", [parentRoom allKeys][0]];
                request = [NSFetchRequest new];
                [request setPredicate:[NSPredicate predicateWithFormat:query]];
                [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
                rooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
            }
            else
                [self setRoomListingWhenUserInRootRoom];
        }
        else
            [self setRoomListingWhenUserInRootRoom];
    }
    else
        [self setRoomListingWhenUserInRootRoom];
}



- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    // note: rooms start with id 1 and onwards..
    if ([self.appOnline.User.RoomID intValue] == 0)
    {
        // fetch all root level rooms
        [self setRoomListingWhenUserInRootRoom];
    }
    else
    {
        // get room listing w.r.t User.RoomID
        [self setRoomListingWhenUserRoomIDIsNotNull];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (rooms)
        return 1;
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // return the parent room name
    return [parentRoom valueForKey:[[parentRoom allKeys] objectAtIndex:0]];
}

- (void)HeaderSectionClick:(UIGestureRecognizer*)gestureRecognizer
{
    // in this case we are navigating top level from current rooms list
    [self setRoomListingWhenUserNavigatingBackToParentRoom];
    // reload list
    [(UITableView*)gestureRecognizer.view.superview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (rooms)
        return rooms.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (rooms && rooms.count > 0)
    {
        // get a cell first
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        // assign cell a room
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [rooms[indexPath.row] valueForKey:@"Name"]];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#0b2744"];
        cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconRoom"] ByValue:3];
        [ImageEditing ImageApplyTintColorToImageView:cell.imageView TintColor:[UIColor colorWithHexString:@"#0b2744"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.accessoryView = nil;



        // if room has child room, assign the cell a diclosure indicator
        NSString *query = [NSString stringWithFormat:@"ParentID='%@'", [rooms[indexPath.row] valueForKey:@"RoomID"]];
        NSFetchRequest *request = [NSFetchRequest new];
        [request setPredicate:[NSPredicate predicateWithFormat:query]];
        [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:self.appOnline.User.Rooms.columnSerialNumberName ascending:YES]]];
        NSArray *childRooms = [self.appOnline.User.Rooms FetchRowsAgainstQuery:request];
        if (childRooms && childRooms.count > 0)
        {
//            UIImageView *cellAccessoryView = [[UIImageView alloc] initWithImage:[ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconRoom"] ByValue:5]];
//            [ImageEditing ImageApplyTintColorToImageView:cellAccessoryView TintColor:[UIColor colorWithHexString:@"#0b2744"]];
//            cell.accessoryView = cellAccessoryView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        // assign room a color if the room is user's room
        if ([[self.appOnline.User.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"RoomID"] isEqualToString:[rooms[indexPath.row] valueForKey:@"RoomID"]])
        {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#ff0000"];
            [ImageEditing ImageApplyTintColorToImageView:cell.imageView TintColor:[UIColor colorWithHexString:@"#ff0000"]];
        }
        

        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if cell has discloure indicator, i.e. room has child room, go to child room listing
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        parentRoom = [NSDictionary dictionaryWithObjectsAndKeys:[rooms[indexPath.row] valueForKey:@"Name"], [rooms[indexPath.row] valueForKey:@"RoomID"], nil];
        
        [self setRoomListingWhenUserNavigatingForthToChildRooms];
        [tableView reloadData];
    }
    else
    {
       
        [self setRoomData];
        // load new room data!
        // [[SplashScreen SplashScreenInstance] Stop];
        [[MyManager sharedManager] removeHud];
       // [[SplashScreen SplashScreenInstance] Start:@"connecting to room..."];

        // set user.roomID to the selected room this is important!!! so that we can send a packet for change room
        self.appOnline.User.RoomID = [rooms[indexPath.row] valueForKey:@"RoomID"];

        if (self.appOnline.User.Game)
        {
            for (int i = 0; i < [self.appOnline.User.Game allKeys].count; i++)
                [(DataTable*)[self.appOnline.User.Game objectForKey:[self.appOnline.User.Game allKeys][i]] RemoveTable:YES];
            self.appOnline.User.Game = nil;

            //[(PlayOnlineMainScreenViewController*)self.parentViewController.parentViewController setGameScreenController];
        }

        // if connected to server, send Get room data by id...
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];

            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                [self.appOnline SendChangeRoom];
            }];
        }
    }
}
- (void)setRoomData {
   
   // [[SplashScreen SplashScreenInstance] Stop];
    [[MyManager sharedManager] removeHud];
    //[[MyManager sharedManager] showHUDWithTransform:@"connecting to room..." forView:self.view];
//    [[SplashScreen SplashScreenInstance] Start:@"connecting to room..."];
    
    // set user.roomID to the selected room this is important!!! so that we can send a packet for change room
    self.appOnline.User.RoomID = @"9";//[rooms[indexPath.row] valueForKey:@"RoomID"];
    if (self.appOnline.User.Game)
    {
        for (int i = 0; i < [self.appOnline.User.Game allKeys].count; i++)
            [(DataTable*)[self.appOnline.User.Game objectForKey:[self.appOnline.User.Game allKeys][i]] RemoveTable:YES];
        self.appOnline.User.Game = nil;
        
       // [(PlayOnlineMainScreenViewController*)self.parentViewController.parentViewController setGameScreenController];
    }
    
    // if connected to server, send Get room data by id...
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
        
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline SendChangeRoom];
        }];
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"accessory" message:cell.textLabel.text delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"accessory" message:cell.textLabel.text];
//    [alert show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 10 * 2, 50.0f)];
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    
    [label setText:
     [parentRoom valueForKey:@"0"] ?
     [NSString stringWithFormat:@" %@", [parentRoom valueForKey:[[parentRoom allKeys] objectAtIndex:0]]] :
     [NSString stringWithFormat:@"%@ %@", [CommonTasks ReturnArrowString], [parentRoom valueForKey:[[parentRoom allKeys] objectAtIndex:0]]]];
    
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"#0b2744"]]; //your background color...
    
    if (rooms)
    {
        // add click event to section header
        UITapGestureRecognizer *headerSectionClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HeaderSectionClick:)];
        headerSectionClick.delegate = self;
        headerSectionClick.numberOfTapsRequired = 1;
        headerSectionClick.numberOfTouchesRequired = 1;
        [headerView addGestureRecognizer:headerSectionClick];
    }
    return headerView;
}
@end

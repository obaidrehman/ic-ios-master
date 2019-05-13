//
//  GamesScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 5/13/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "GamesScreenViewController.h"
#import "AppOptions.h"
#import "PlayOnlineMainScreenViewController.h"
#import "MyManager.h"
#import "NSLocale+TTEmojiFlagString.h"
#import "GameScreenTableViewCell.h"
@interface GamesScreenViewController ()
@property (nonatomic,strong) NSArray * allItems;
@end

@implementation GamesScreenViewController
{
    /// @description this is the list of games
    NSArray *games;
    UIView *gameView;
    UITableView *thisTableView;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.appOnline SubscribeToNotifications:self];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // theme?
    //self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0,50, 0)];
    
    [self initFlagArray];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
       [self RequestNewGamesList];
   
    NSLog(@"RequestNewGamesListRequestNewGamesListRequestNewGamesList");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RequestNewGamesList
{
    // if connected to server, send handshake
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending request to get games list" MessageFlagType:logMessageFlagTypeSystem];
        
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline SendGetGamesByRoomID];
        }];
    }
}

- (void)ResetGamesList
{
    
    games = [[self.appOnline.User.RoomInfoAppData objectForKey:@"Games"] FetchAllRowsFromTable];
    NSLog(@" - ----------- - - - - - - -  - -ResetGamesList",games);
    if (!games || (games && games.count == 0))
    {
//        RNBlurModalView *alert = [[RNBlurModalView alloc] initWithParentView:self.view title:@"Gamesless Room!" message:@"there are no games in this room!"];
//        [alert show];
    }
   
        [thisTableView reloadData];
        [[MyManager sharedManager] removeHud];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    thisTableView = tableView;
    
    // Return the number of sections.
    if (games)
        return 1;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (games)
        return games.count;
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"gamescountGameScreen%d",games.count);
  //  if (games && games.count > 0)
  //  {
        GameScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
            cell = [[GameScreenTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.lblWhiteUser.text = [NSString stringWithFormat:@"%@, (%@)",
                                  [games[indexPath.row] valueForKey:@"WhiteUserName"],[games[indexPath.row] valueForKey:@"WhiteRating"]];
        cell.lblBlackUser.text = [NSString stringWithFormat:@"%@, (%@)",
                                  [games[indexPath.row] valueForKey:@"BlackUserName"],[games[indexPath.row] valueForKey:@"BlackRating"]];
    cell.lblResult.text = [NSString stringWithFormat:@"%@", [games[indexPath.row] valueForKey:@"Result"]];
        NSString *country = [NSString stringWithFormat:@"%@", [games[indexPath.row] valueForKey:@"WhiteCountryName"]];
        NSString *country2 = [NSString stringWithFormat:@"%@", [games[indexPath.row] valueForKey:@"BlackCountryName"]];
        //TEST TEST
        [cell.lblBlackFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[self getFlagOfTheCountry:country2]]]];

        cell.lblWhiteUser.textColor = [UIColor colorWithRed:223.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];//[UIColor colorWithHexString:@"#0b2744"];
        cell.lblBlackUser.textColor = [UIColor colorWithRed:223.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
        tableView.backgroundColor = cell.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:60.0/255.0 blue:57.0/255.0 alpha:1.0];
        NSDictionary * item = [self allItems][indexPath.row];
        
        //UILabel *lbl = (UILabel*)[cell viewWithTag:1];
        //[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:item[@"code"]]]];
        //cell.detailTextLabel.text =
        //[NSString stringWithFormat:@"%@, \t %@",
        //                             [games[indexPath.row] valueForKey:@"TimeControl"],
        //                             [games[indexPath.row] valueForKey:@"Result"]];
        
       // TEST TEST
      //  [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[self getFlagOfTheCountry:country2]]]];
        if (country == nil || country2 == nil){
            NSLog(@"INDEX PATH FOR NIL == %ld",indexPath.row);
        }
        
//        NSLog(@"%@",country);
//        NSLog(@"%@",country2);
//       // [self getFlagOfTheCountry:country];
//        NSLog(@"%@",games[indexPath.row]);
//        NSLog(@"%@",[games[indexPath.row] valueForKey:@"TimeControl"]);
//        NSLog(@"%@",[games[indexPath.row] valueForKey:@"Result"]);
      //  cell.detailTextLabel.textColor = [UIColor grayColor];
        
//        if ([[games[indexPath.row] valueForKey:@"Result"] length] <= 6)
//            cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconFinishedGame"] ByValue:3];
//        else
//            cell.imageView.image = [ImageEditing ImageByScalingImage:[UIImage imageNamed:@"iconInprogressGame"] ByValue:3];
//        [ImageEditing ImageApplyTintColorToImageView:cell.imageView TintColor:[UIColor colorWithHexString:@"#0b2744"]];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        return cell;
  //  }
  //  return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (games)
//        return (self.viewFrame.size.height - 100) / games.count;
    return 60;
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
    
    [label setText:@"Games"];
    
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:161.0/255.0 blue:69.0/255.0 alpha:1.0]];
     //[UIColor colorWithHexString:@"#0b2744"]]; //your background color...
    
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // temp for now this need to be changed! todo?
    return @"Games";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [[SplashScreen SplashScreenInstance] Stop];
  //  [[SplashScreen SplashScreenInstance] Start:@"Connecting to game..."];
    [[MyManager sharedManager] removeHud];
    [[MyManager sharedManager] showHUDWithTransform:@"Waiting for Server Response..." forView:self.gameView];
    // if connected to server, send Get room data by id...
    NSString *gameID = self.appOnline.User.GameID = [games[indexPath.row] valueForKey:@"GameID"];
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending get data by room id..." MessageFlagType:logMessageFlagTypeSystem];
        
        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            self.appOnline.theFlag = true;
            self.appOnline.User.GameID = gameID;
            [self.appOnline SendGetGameDataByGameID];
        }];
    }
}

-(NSString *)getFlagOfTheCountry:(NSString *)country{
   // country = @"Afghanistan";
    for (int i=0; i<self.allItems.count; i++) {
        NSString *name = [NSString stringWithFormat:@"%@", [self.allItems[i] valueForKey:@"name"]];
        if ([country.lowercaseString isEqualToString:name.lowercaseString]){
            NSLog(@"%@", [self.allItems[i] valueForKey:@"code"]);
            return [NSString stringWithFormat:@"%@", [self.allItems[i] valueForKey:@"code"]];
        }
    }
    
    return  @"AU";
}


- (void)initFlagArray {
    
    self.allItems =
    @[
      @{
          @"name": @"Afghanistan",
          @"code": @"AF"
          },
      @{
          @"name": @"Aland Islands",
          @"code": @"AX"
          },
      @{
          @"name": @"Albania",
          @"code": @"AL"
          },
      @{
          @"name": @"Algeria",
          @"code": @"DZ"
          },
      @{
          @"name": @"AmericanSamoa",
          @"code": @"AS"
          },
      @{
          @"name": @"Andorra",
          @"code": @"AD"
          },
      @{
          @"name": @"Angola",
          @"code": @"AO"
          },
      @{
          @"name": @"Anguilla",
          @"code": @"AI"
          },
      @{
          @"name": @"Antarctica",
          @"code": @"AQ"
          },
      @{
          @"name": @"Antigua and Barbuda",
          @"code": @"AG"
          },
      @{
          @"name": @"Argentina",
          @"code": @"AR"
          },
      @{
          @"name": @"Armenia",
          @"code": @"AM"
          },
      @{
          @"name": @"Aruba",
          @"code": @"AW"
          },
      @{
          @"name": @"Australia",
          @"code": @"AU"
          },
      @{
          @"name": @"Austria",
          @"code": @"AT"
          },
      @{
          @"name": @"Azerbaijan",
          @"code": @"AZ"
          },
      @{
          @"name": @"Bahamas",
          @"code": @"BS"
          },
      @{
          @"name": @"Bahrain",
          @"code": @"BH"
          },
      @{
          @"name": @"Bangladesh",
          @"code": @"BD"
          },
      @{
          @"name": @"Barbados",
          @"code": @"BB"
          },
      @{
          @"name": @"Belarus",
          @"code": @"BY"
          },
      @{
          @"name": @"Belgium",
          @"code": @"BE"
          },
      @{
          @"name": @"Belize",
          @"code": @"BZ"
          },
      @{
          @"name": @"Benin",
          @"code": @"BJ"
          },
      @{
          @"name": @"Bermuda",
          @"code": @"BM"
          },
      @{
          @"name": @"Bhutan",
          @"code": @"BT"
          },
      @{
          @"name": @"Bolivia, Plurinational State of",
          @"code": @"BO"
          },
      @{
          @"name": @"Bosnia and Herzegovina",
          @"code": @"BA"
          },
      @{
          @"name": @"Botswana",
          @"code": @"BW"
          },
      @{
          @"name": @"Brazil",
          @"code": @"BR"
          },
      @{
          @"name": @"British Indian Ocean Territory",
          @"code": @"IO"
          },
      @{
          @"name": @"Brunei Darussalam",
          @"code": @"BN"
          },
      @{
          @"name": @"Bulgaria",
          @"code": @"BG"
          },
      @{
          @"name": @"Burkina Faso",
          @"code": @"BF"
          },
      @{
          @"name": @"Burundi",
          @"code": @"BI"
          },
      @{
          @"name": @"Cambodia",
          @"code": @"KH"
          },
      @{
          @"name": @"Cameroon",
          @"code": @"CM"
          },
      @{
          @"name": @"Canada",
          @"code": @"CA"
          },
      @{
          @"name": @"Cape Verde",
          @"code": @"CV"
          },
      @{
          @"name": @"Cayman Islands",
          @"code": @"KY"
          },
      @{
          @"name": @"Central African Republic",
          @"code": @"CF"
          },
      @{
          @"name": @"Chad",
          @"code": @"TD"
          },
      @{
          @"name": @"Chile",
          @"code": @"CL"
          },
      @{
          @"name": @"China",
          @"code": @"CN"
          },
      @{
          @"name": @"Christmas Island",
          @"code": @"CX"
          },
      @{
          @"name": @"Cocos (Keeling) Islands",
          @"code": @"CC"
          },
      @{
          @"name": @"Colombia",
          @"code": @"CO"
          },
      @{
          @"name": @"Comoros",
          @"code": @"KM"
          },
      @{
          @"name": @"Congo",
          @"code": @"CG"
          },
      @{
          @"name": @"Congo, The Democratic Republic of the Congo",
          @"code": @"CD"
          },
      @{
          @"name": @"Cook Islands",
          @"code": @"CK"
          },
      @{
          @"name": @"Costa Rica",
          @"code": @"CR"
          },
      @{
          @"name": @"Cote d'Ivoire",
          @"code": @"CI"
          },
      @{
          @"name": @"Croatia",
          @"code": @"HR"
          },
      @{
          @"name": @"Cuba",
          @"code": @"CU"
          },
      @{
          @"name": @"Cyprus",
          @"code": @"CY"
          },
      @{
          @"name": @"Czech Republic",
          @"code": @"CZ"
          },
      @{
          @"name": @"Denmark",
          @"code": @"DK"
          },
      @{
          @"name": @"Djibouti",
          @"code": @"DJ"
          },
      @{
          @"name": @"Dominica",
          @"code": @"DM"
          },
      @{
          @"name": @"Dominican Republic",
          @"code": @"DO"
          },
      @{
          @"name": @"Ecuador",
          @"code": @"EC"
          },
      @{
          @"name": @"Egypt",
          @"code": @"EG"
          },
      @{
          @"name": @"El Salvador",
          @"code": @"SV"
          },
      @{
          @"name": @"Equatorial Guinea",
          @"code": @"GQ"
          },
      @{
          @"name": @"Eritrea",
          @"code": @"ER"
          },
      @{
          @"name": @"Estonia",
          @"code": @"EE"
          },
      @{
          @"name": @"Ethiopia",
          @"code": @"ET"
          },
      @{
          @"name": @"Falkland Islands (Malvinas)",
          @"code": @"FK"
          },
      @{
          @"name": @"Faroe Islands",
          @"code": @"FO"
          },
      @{
          @"name": @"Fiji",
          @"code": @"FJ"
          },
      @{
          @"name": @"Finland",
          @"code": @"FI"
          },
      @{
          @"name": @"France",
          @"code": @"FR"
          },
      @{
          @"name": @"French Guiana",
          @"code": @"GF"
          },
      @{
          @"name": @"French Polynesia",
          @"code": @"PF"
          },
      @{
          @"name": @"Gabon",
          @"code": @"GA"
          },
      @{
          @"name": @"Gambia",
          @"code": @"GM"
          },
      @{
          @"name": @"Georgia",
          @"code": @"GE"
          },
      @{
          @"name": @"Germany",
          @"code": @"DE"
          },
      @{
          @"name": @"Ghana",
          @"code": @"GH"
          },
      @{
          @"name": @"Gibraltar",
          @"code": @"GI"
          },
      @{
          @"name": @"Greece",
          @"code": @"GR"
          },
      @{
          @"name": @"Greenland",
          @"code": @"GL"
          },
      @{
          @"name": @"Grenada",
          @"code": @"GD"
          },
      @{
          @"name": @"Guadeloupe",
          @"code": @"GP"
          },
      @{
          @"name": @"Guam",
          @"code": @"GU"
          },
      @{
          @"name": @"Guatemala",
          @"code": @"GT"
          },
      @{
          @"name": @"Guernsey",
          @"code": @"GG"
          },
      @{
          @"name": @"Guinea",
          @"code": @"GN"
          },
      @{
          @"name": @"Guinea-Bissau",
          @"code": @"GW"
          },
      @{
          @"name": @"Guyana",
          @"code": @"GY"
          },
      @{
          @"name": @"Haiti",
          @"code": @"HT"
          },
      @{
          @"name": @"Holy See (Vatican City State)",
          @"code": @"VA"
          },
      @{
          @"name": @"Honduras",
          @"code": @"HN"
          },
      @{
          @"name": @"Hong Kong",
          @"code": @"HK"
          },
      @{
          @"name": @"Hungary",
          @"code": @"HU"
          },
      @{
          @"name": @"Iceland",
          @"code": @"IS"
          },
      @{
          @"name": @"India",
          @"code": @"IN"
          },
      @{
          @"name": @"Indonesia",
          @"code": @"ID"
          },
      @{
          @"name": @"Iran, Islamic Republic of Persian Gulf",
          @"code": @"IR"
          },
      @{
          @"name": @"Iraq",
          @"code": @"IQ"
          },
      @{
          @"name": @"Ireland",
          @"code": @"IE"
          },
      @{
          @"name": @"Isle of Man",
          @"code": @"IM"
          },
      @{
          @"name": @"Israel",
          @"code": @"IL"
          },
      @{
          @"name": @"Italy",
          @"code": @"IT"
          },
      @{
          @"name": @"Jamaica",
          @"code": @"JM"
          },
      @{
          @"name": @"Japan",
          @"code": @"JP"
          },
      @{
          @"name": @"Jersey",
          @"code": @"JE"
          },
      @{
          @"name": @"Jordan",
          @"code": @"JO"
          },
      @{
          @"name": @"Kazakhstan",
          @"code": @"KZ"
          },
      @{
          @"name": @"Kenya",
          @"code": @"KE"
          },
      @{
          @"name": @"Kiribati",
          @"code": @"KI"
          },
      @{
          @"name": @"Korea, Democratic People's Republic of Korea",
          @"code": @"KP"
          },
      @{
          @"name": @"Korea, Republic of South Korea",
          @"code": @"KR"
          },
      @{
          @"name": @"Kuwait",
          @"code": @"KW"
          },
      @{
          @"name": @"Kyrgyzstan",
          @"code": @"KG"
          },
      @{
          @"name": @"Laos",
          @"code": @"LA"
          },
      @{
          @"name": @"Latvia",
          @"code": @"LV"
          },
      @{
          @"name": @"Lebanon",
          @"code": @"LB"
          },
      @{
          @"name": @"Lesotho",
          @"code": @"LS"
          },
      @{
          @"name": @"Liberia",
          @"code": @"LR"
          },
      @{
          @"name": @"Libyan Arab Jamahiriya",
          @"code": @"LY"
          },
      @{
          @"name": @"Liechtenstein",
          @"code": @"LI"
          },
      @{
          @"name": @"Lithuania",
          @"code": @"LT"
          },
      @{
          @"name": @"Luxembourg",
          @"code": @"LU"
          },
      @{
          @"name": @"Macao",
          @"code": @"MO"
          },
      @{
          @"name": @"Macedonia",
          @"code": @"MK"
          },
      @{
          @"name": @"Madagascar",
          @"code": @"MG"
          },
      @{
          @"name": @"Malawi",
          @"code": @"MW"
          },
      @{
          @"name": @"Malaysia",
          @"code": @"MY"
          },
      @{
          @"name": @"Maldives",
          @"code": @"MV"
          },
      @{
          @"name": @"Mali",
          @"code": @"ML"
          },
      @{
          @"name": @"Malta",
          @"code": @"MT"
          },
      @{
          @"name": @"Marshall Islands",
          @"code": @"MH"
          },
      @{
          @"name": @"Martinique",
          @"code": @"MQ"
          },
      @{
          @"name": @"Mauritania",
          @"code": @"MR"
          },
      @{
          @"name": @"Mauritius",
          @"code": @"MU"
          },
      @{
          @"name": @"Mayotte",
          @"code": @"YT"
          },
      @{
          @"name": @"Mexico",
          @"code": @"MX"
          },
      @{
          @"name": @"Micronesia, Federated States of Micronesia",
          @"code": @"FM"
          },
      @{
          @"name": @"Moldova",
          @"code": @"MD"
          },
      @{
          @"name": @"Monaco",
          @"code": @"MC"
          },
      @{
          @"name": @"Mongolia",
          @"code": @"MN"
          },
      @{
          @"name": @"Montenegro",
          @"code": @"ME"
          },
      @{
          @"name": @"Montserrat",
          @"code": @"MS"
          },
      @{
          @"name": @"Morocco",
          @"code": @"MA"
          },
      @{
          @"name": @"Mozambique",
          @"code": @"MZ"
          },
      @{
          @"name": @"Myanmar",
          @"code": @"MM"
          },
      @{
          @"name": @"Namibia",
          @"code": @"NA"
          },
      @{
          @"name": @"Nauru",
          @"code": @"NR"
          },
      @{
          @"name": @"Nepal",
          @"code": @"NP"
          },
      @{
          @"name": @"Netherlands",
          @"code": @"NL"
          },
      @{
          @"name": @"Netherlands Antilles",
          @"code": @"AN"
          },
      @{
          @"name": @"New Caledonia",
          @"code": @"NC"
          },
      @{
          @"name": @"New Zealand",
          @"code": @"NZ"
          },
      @{
          @"name": @"Nicaragua",
          @"code": @"NI"
          },
      @{
          @"name": @"Niger",
          @"code": @"NE"
          },
      @{
          @"name": @"Nigeria",
          @"code": @"NG"
          },
      @{
          @"name": @"Niue",
          @"code": @"NU"
          },
      @{
          @"name": @"Norfolk Island",
          @"code": @"NF"
          },
      @{
          @"name": @"Northern Mariana Islands",
          @"code": @"MP"
          },
      @{
          @"name": @"Norway",
          @"code": @"NO"
          },
      @{
          @"name": @"Oman",
          @"code": @"OM"
          },
      @{
          @"name": @"Pakistan",
          @"code": @"PK"
          },
      @{
          @"name": @"Palau",
          @"code": @"PW"
          },
      @{
          @"name": @"Palestinian Territory, Occupied",
          @"code": @"PS"
          },
      @{
          @"name": @"Panama",
          @"code": @"PA"
          },
      @{
          @"name": @"Papua New Guinea",
          @"code": @"PG"
          },
      @{
          @"name": @"Paraguay",
          @"code": @"PY"
          },
      @{
          @"name": @"Peru",
          @"code": @"PE"
          },
      @{
          @"name": @"Philippines",
          @"code": @"PH"
          },
      @{
          @"name": @"Pitcairn",
          @"code": @"PN"
          },
      @{
          @"name": @"Poland",
          @"code": @"PL"
          },
      @{
          @"name": @"Portugal",
          @"code": @"PT"
          },
      @{
          @"name": @"Puerto Rico",
          @"code": @"PR"
          },
      @{
          @"name": @"Qatar",
          @"code": @"QA"
          },
      @{
          @"name": @"Romania",
          @"code": @"RO"
          },
      @{
          @"name": @"Russia",
          @"code": @"RU"
          },
      @{
          @"name": @"Rwanda",
          @"code": @"RW"
          },
      @{
          @"name": @"Reunion",
          @"code": @"RE"
          },
      @{
          @"name": @"Saint Barthelemy",
          @"code": @"BL"
          },
      @{
          @"name": @"Saint Helena, Ascension and Tristan Da Cunha",
          @"code": @"SH"
          },
      @{
          @"name": @"Saint Kitts and Nevis",
          @"code": @"KN"
          },
      @{
          @"name": @"Saint Lucia",
          @"code": @"LC"
          },
      @{
          @"name": @"Saint Martin",
          @"code": @"MF"
          },
      @{
          @"name": @"Saint Pierre and Miquelon",
          @"code": @"PM"
          },
      @{
          @"name": @"Saint Vincent and the Grenadines",
          @"code": @"VC"
          },
      @{
          @"name": @"Samoa",
          @"code": @"WS"
          },
      @{
          @"name": @"San Marino",
          @"code": @"SM"
          },
      @{
          @"name": @"Sao Tome and Principe",
          @"code": @"ST"
          },
      @{
          @"name": @"Saudi Arabia",
          @"code": @"SA"
          },
      @{
          @"name": @"Senegal",
          @"code": @"SN"
          },
      @{
          @"name": @"Serbia and Montenegro",
          @"code": @"RS"
          },
      @{
          @"name": @"Seychelles",
          @"code": @"SC"
          },
      @{
          @"name": @"Sierra Leone",
          @"code": @"SL"
          },
      @{
          @"name": @"Singapore",
          @"code": @"SG"
          },
      @{
          @"name": @"Slovakia",
          @"code": @"SK"
          },
      @{
          @"name": @"Slovenia",
          @"code": @"SI"
          },
      @{
          @"name": @"Solomon Islands",
          @"code": @"SB"
          },
      @{
          @"name": @"Somalia",
          @"code": @"SO"
          },
      @{
          @"name": @"South Africa",
          @"code": @"ZA"
          },
      @{
          @"name": @"South Sudan",
          @"code": @"SS"
          },
      @{
          @"name": @"South Georgia and the South Sandwich Islands",
          @"code": @"GS"
          },
      @{
          @"name": @"Spain",
          @"code": @"ES"
          },
      @{
          @"name": @"Sri Lanka",
          @"code": @"LK"
          },
      @{
          @"name": @"Sudan",
          @"code": @"SD"
          },
      @{
          @"name": @"Suriname",
          @"code": @"SR"
          },
      @{
          @"name": @"Svalbard and Jan Mayen",
          @"code": @"SJ"
          },
      @{
          @"name": @"Swaziland",
          @"code": @"SZ"
          },
      @{
          @"name": @"Sweden",
          @"code": @"SE"
          },
      @{
          @"name": @"Switzerland",
          @"code": @"CH"
          },
      @{
          @"name": @"Syrian Arab Republic",
          @"code": @"SY"
          },
      @{
          @"name": @"Taiwan",
          @"code": @"TW"
          },
      @{
          @"name": @"Tajikistan",
          @"code": @"TJ"
          },
      @{
          @"name": @"Tanzania, United Republic of Tanzania",
          @"code": @"TZ"
          },
      @{
          @"name": @"Thailand",
          @"code": @"TH"
          },
      @{
          @"name": @"Timor-Leste",
          @"code": @"TL"
          },
      @{
          @"name": @"Togo",
          @"code": @"TG"
          },
      @{
          @"name": @"Tokelau",
          @"code": @"TK"
          },
      @{
          @"name": @"Tonga",
          @"code": @"TO"
          },
      @{
          @"name": @"Trinidad and Tobago",
          @"code": @"TT"
          },
      @{
          @"name": @"Tunisia",
          @"code": @"TN"
          },
      @{
          @"name": @"Turkey",
          @"code": @"TR"
          },
      @{
          @"name": @"Turkmenistan",
          @"code": @"TM"
          },
      @{
          @"name": @"Turks and Caicos Islands",
          @"code": @"TC"
          },
      @{
          @"name": @"Tuvalu",
          @"code": @"TV"
          },
      @{
          @"name": @"Uganda",
          @"code": @"UG"
          },
      @{
          @"name": @"Ukraine",
          @"code": @"UA"
          },
      @{
          @"name": @"United Arab Emirates",
          @"code": @"AE"
          },
      @{
          @"name": @"United Kingdom",
          @"code": @"GB"
          },
      @{
          @"name": @"United States",
          @"code": @"US"
          },
      @{
          @"name": @"Uruguay",
          @"code": @"UY"
          },
      @{
          @"name": @"Uzbekistan",
          @"code": @"UZ"
          },
      @{
          @"name": @"Vanuatu",
          @"code": @"VU"
          },
      @{
          @"name": @"Venezuela, Bolivarian Republic of Venezuela",
          @"code": @"VE"
          },
      @{
          @"name": @"Vietnam",
          @"code": @"VN"
          },
      @{
          @"name": @"Virgin Islands, British",
          @"code": @"VG"
          },
      @{
          @"name": @"Virgin Islands, U.S.",
          @"code": @"VI"
          },
      @{
          @"name": @"Wallis and Futuna",
          @"code": @"WF"
          },
      @{
          @"name": @"Yemen",
          @"code": @"YE"
          },
      @{
          @"name": @"Zambia",
          @"code": @"ZM"
          },
      @{
          @"name": @"Zimbabwe",
          @"code": @"ZW"
          }
      ];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

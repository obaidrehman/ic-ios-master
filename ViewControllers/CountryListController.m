//
//  CountryListController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 8/1/18.
//

#import "CountryListController.h"
#import "MyManager.h"
#import "NSLocale+TTEmojiFlagString.h"
#import "CountryListCell.h"


@interface CountryListController (){
    NSArray *arrCountryList;
    
}
@end

@implementation CountryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCountryList = [[MyManager sharedManager] getAllCountryList];
    NSLog(@"");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCountryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CountryListCell *countryCell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    
    if ([arrCountryList[indexPath.row] isEqualToString:_selectedCountry]){
        [countryCell.lblSelectedCountryImage setHidden:false];
    }else{
        [countryCell.lblSelectedCountryImage setHidden:true];
    }
    
    [countryCell.lblCountryFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[[MyManager sharedManager] getFlagOfTheCountry:arrCountryList[indexPath.row]]]]];
    countryCell.lblCountry.text =   arrCountryList[indexPath.row];
    return countryCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate getSelectedCountry:arrCountryList[indexPath.row]];
    NSString *countryCode = [[MyManager sharedManager] getFlagOfTheCountry:arrCountryList[indexPath.row]];
    [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:@"CountryCode"];
    [self.navigationController popViewControllerAnimated:true];
}
@end

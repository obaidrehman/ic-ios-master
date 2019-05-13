//
//  ProfileViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 7/27/18.
//

#import "ProfileViewController.h"
#import "ProfileViewCell.h"
#import "ProfileUpgradeCell.h"
#import "ProfileImageCell.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "MyManager.h"
#import "NSLocale+TTEmojiFlagString.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>

@interface ProfileViewController ()
{
    NSString *cellIndentifier;
    NSString *cellProfileUpgradeIndentifier;
    NSString *cellProfileImageIndentifier;
    NSString *cellProfileCountryIndentifier;
    NSString *cellTermsAndCondIndentifier;
    NSArray *arrTableViewData;
    BOOL isEditEnabled;
    UIImage *profileImage;
    NSURL *imgUURL;
    BOOL isCrossBuutonClicked;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValues];
    [_tableView setHidden:true];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tableView setHidden:false];
    [[MyManager sharedManager] starAnimationWithTableView:_tableView :2];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




//MARK:- Tblview delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSInteger index = indexPath.row;
    
    switch (index) {
        case inviteYourFriends:
        {
            ProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            [cell.lblTitle setText:arrTableViewData[index]];
            [cell.btnInviteYrFrnds setHidden:false];
            [cell.lblTitle setHidden:true];
            [cell.lblDetail setHidden:true];
            [cell.txtDetails setHidden:true];
            return cell;
        }
            break;
        case upgradeForUnlimited: {
            ProfileUpgradeCell *profileUpgradeCell = [tableView dequeueReusableCellWithIdentifier:cellProfileUpgradeIndentifier forIndexPath:indexPath];
            [profileUpgradeCell.lblTitle setText:arrTableViewData[index]];
            return profileUpgradeCell;
        }
            break;
            
        case country: {
            ProfileViewCell *profileCountryCell = [tableView dequeueReusableCellWithIdentifier:cellProfileCountryIndentifier forIndexPath:indexPath];
            
             [self setCountryFromId:profileCountryCell];
            return profileCountryCell;
        }
            break;
            
        case profilePic: {
            ProfileImageCell *profileImageCell = [tableView dequeueReusableCellWithIdentifier:cellProfileImageIndentifier forIndexPath:indexPath];
            [profileImageCell.lblTitle setText:arrTableViewData[index]];
            [profileImageCell.lblTitle setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6]];
            if (profileImage!=nil){
                profileImageCell.imgProfile.image = profileImage;
            }else{
            if ([[MyManager sharedManager] userImage] != nil){
                profileImageCell.imgProfile.image = [[MyManager sharedManager] userImage];
            }else{
                NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
                NSNumber *userIdNumber = [[NSNumber alloc] initWithInt: userId.integerValue];
                [[MyManager sharedManager] loadImages:userIdNumber : profileImageCell.imgProfile];
            }}
            return profileImageCell;
        }
            break;
            
        case termsAndCondition:{
            ProfileViewCell *termsAndCondCell = [tableView dequeueReusableCellWithIdentifier:cellTermsAndCondIndentifier forIndexPath:indexPath];
            NSMutableAttributedString *termsAndConditionString = [[NSMutableAttributedString alloc] initWithString:@"Your account is subject to the site Terms and Condition. if you would like to close your account, tap here. Privacy Policy"];
            
            [termsAndConditionString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
            [termsAndConditionString addAttributes:@{NSForegroundColorAttributeName:
                                                         [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8]}range:NSMakeRange(1,122)];
            
            [termsAndConditionString addAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(36,20)];
            
            [termsAndConditionString addAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(98,9)];
            
            [termsAndConditionString addAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(108,14)];
            
            termsAndCondCell.lblTermsAndCondition.attributedText = [termsAndConditionString copy];
            return termsAndCondCell;
           
        }
       
            break;
            
        default:{
            ProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            [cell.lblTitle setText:arrTableViewData[index]];
            [cell.txtDetails setHidden:!isEditEnabled];
            
            if (isEditEnabled && index == firstName){
                [cell.txtDetails becomeFirstResponder];
                
            }else if (index == lastName){
            cell.lblDetail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastName"];
            cell.txtDetails.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastName"];
            }else if (index == firstName){
                cell.lblDetail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstName"];
                cell.txtDetails.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstName"];
            }else if (index == location){
                cell.lblDetail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Location"];
                cell.txtDetails.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Location"];
            }else{
                cell.lblDetail.text = @"";
                //[cell.lblTitle setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6]];
            }
            
            
            return cell;
        }
            break;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    switch (index) {
        case country:{
             [self resignFirstResponder];
            NSString * storyboardName = @"Storyboard";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            CountryListController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CountryListController"];
            vc.selectedCountry = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"];
            vc.delegate = self;
            [self getEditedValues];
           
            [[self navigationController] pushViewController:vc animated:true];
        }
            return;
            break;
        case profilePic: {
            
            [self callImagePicker];
            //UIImage *image = profileImage.image;//[UIImage imageNamed:@"wonderwomen.jpeg"];
            //NSString *baseString = [self imageToNSString:image];
            
         //   NSLog(@"%@",baseString);
        }
            return;
            break;
        case upgradeForUnlimited:
            return;
            break;
        case inviteYourFriends:
            return;
            break;
        case termsAndCondition:
            return;
            break;
            
        default:
            [self setIsEditable];
            
            break;
    }
    
}

-(void)callImagePicker{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    profileImage = chosenImage;
    profileImage = [self imageWithImage:profileImage scaledToWidth:200]; //[self scaleToSize:CGSizeMake(150, 150) image:profileImage];
    [_tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    imgUURL = info[@"UIImagePickerControllerImageURL"];
}



-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)sendImageToServer{
    if (profileImage == nil){
        return;
    }
    
NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    NSLog(@"profileid=========%@",userId);
    NSData *lData = UIImageJPEGRepresentation(profileImage, 1.0);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://151.253.185.105:7001/api/Upload/user/PostUserImage/" parameters:@{@"file":@"file"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:lData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",userId] mimeType:@"image/jpeg"];
         //appendPartWithFileData:lData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",userId] mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      NSLog(@"%@",uploadProgress);
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [[MyManager sharedManager] setUserImage:profileImage];
                          //Update the progress view
                          
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}



-(void)pushVC:(NSString *)vcIdentifier{
    NSString * storyboardName = @"Storyboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
    [[self navigationController] pushViewController:vc animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrTableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    
    switch (index) {
        case upgradeForUnlimited:
           return  90;
            break;
            
        case termsAndCondition:
            return  70;
            break;
        default:
            return  60;
            break;
    }
}

- (void)getSelectedCountry:(NSString *)country{
    [[NSUserDefaults standardUserDefaults] setObject:country forKey:@"Country"];
  //   [[NSUserDefaults standardUserDefaults] setObject:country forKey:@"Country"];
   //  cell.txtDetails.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastName"];
    [_tableView reloadData];
    [self setIsEditable];
    
}
- (IBAction)actionEditOrCheckBtn:(UIButton *)sender {
    if (sender.tag == 0){
       
        [self setIsEditable];
        sender.tag = 1;
    }else{
        [self getEditedValues];
        [self setEditDisable];
         sender.tag = 0;
        
    }
    
}

- (IBAction)actionBackButton:(id)sender {
    if (isEditEnabled){
        isCrossBuutonClicked = true;
        [self setEditDisable];
    }else{
         [self.navigationController popViewControllerAnimated:true];
    }
   
}



-(void)getEditedValues{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
     NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
     NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:0];
    ProfileViewCell *cell1 = [_tableView cellForRowAtIndexPath:indexPath1];
    ProfileViewCell *cell2 = [_tableView cellForRowAtIndexPath:indexPath2];
    ProfileViewCell *cell3 = [_tableView cellForRowAtIndexPath:indexPath3];
    [[NSUserDefaults standardUserDefaults] setObject:cell1.txtDetails.text forKey:@"FirstName"];
    [[NSUserDefaults standardUserDefaults] setObject:cell2.txtDetails.text forKey:@"LastName"];
    [[NSUserDefaults standardUserDefaults] setObject:cell3.txtDetails.text forKey:@"Location"];
    [_tableView reloadData];
    
//    cell1.lblDetail.text = cell1.txtDetails.text;
//    cell2.lblDetail.text = cell2.txtDetails.text;
//    cell3.lblDetail.text = cell3.txtDetails.text;
  //  [_tableView reloadData];
}
//@"fa-times"@"fa-check"

//MARK:- SET VALUES METHOD
-(void)setValues{
    cellIndentifier = @"ProfileCell";
    cellProfileUpgradeIndentifier = @"ProfileUpgradeCell";
    cellProfileImageIndentifier = @"ProfileImageCell";
    cellProfileCountryIndentifier = @"ProfileCountryCell";
    cellTermsAndCondIndentifier = @"ProfileTermsCell";
    _btnEditProfile.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    _btnBack.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    [self setButtonIconImages:@"fa-pencil-square-o" :_btnEditProfile];
    [self setButtonIconImages:@"fa-arrow-left" :_btnBack];
    
    
    arrTableViewData = @[@"First Name",
                         @"Last Name",
                         @"Location",
                         @"Country",
                         @"Profile Picture",
                         @"Upgrade for Unlimited Access on Infinity Chess",
                         @"Invite Friends",
                         @"TermsAndCondition"];
    isEditEnabled = false;
     isCrossBuutonClicked = false;
    _btnEditProfile.tag = 0;
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    _lblViewControllerTitle.text = userName;
    
    
}


-(void)setIsEditable{
    isEditEnabled = true;
    [self setButtonIconImages:@"fa-check" :_btnEditProfile];
    [self setButtonIconImages:@"fa-times" :_btnBack];
    _btnEditProfile.tag = 1;
    [_tableView reloadData];
  
}


-(void)setEditDisable{
    [self setButtonIconImages:@"fa-pencil-square-o" :_btnEditProfile];
    [self setButtonIconImages:@"fa-arrow-left" :_btnBack];
    isEditEnabled = false;
    self.tableView.reloadData;
    NSString *firstName = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstName"];
    NSString *LastName = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastName"];
    NSString *countryCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"CountryCode"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dict setObject:firstName forKey:@"FirstName"];
    [dict setObject:LastName forKey:@"LastName"];
    [dict setObject:countryCode forKey:@"CountryCode"];

    if (!isCrossBuutonClicked){
     [self.appOnline updateUserProfile:dict];
    [self sendImageToServer];
    }
   
}



-(void)setButtonIconImages:(NSString *)iconCode:(UIButton *)btn{
    UIImage *icon = [UIImage imageWithIcon:iconCode
                           backgroundColor:[UIColor clearColor]
                                 iconColor:[UIColor whiteColor]
                                   andSize:CGSizeMake(20, 20)];
    [btn setImage:icon forState:normal];
}

-(void)setCountryFromId:(ProfileViewCell *)cell{
   NSString *countryCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"CountryCode"];
    countryCode = [countryCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [cell.lblTitle setText:@"Country"];
    if (countryCode != nil){
        //int *ctryIndex = countryID.integerValue;
        NSString *countryName = [[MyManager sharedManager] getCountryNameByCode:countryCode];
       // [cell.lblTitle setText:arrTableViewData[indexPath.row]];
        [cell.lblCountryFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[[MyManager sharedManager] getFlagOfTheCountry:countryName]]]];
        [cell.lblCountry setText:countryName];
        
    }else{
        
        NSString *country = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"];
       // [cell.lblTitle setText:arrTableViewData[indexPath.row]];
        [cell.lblCountryFlag setText:[NSString stringWithFormat:@"%@", [NSLocale emojiFlagForISOCountryCode:[[MyManager sharedManager] getFlagOfTheCountry:country]]]];
        [cell.lblCountry setText:country];
    }
    
}


enum{
    firstName = 0,
    lastName = 1,
    location = 2,
    country = 3,
    profilePic = 4,
    upgradeForUnlimited = 5,
    inviteYourFriends = 6,
    termsAndCondition = 7
};

@end

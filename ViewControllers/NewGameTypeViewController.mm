//
//  NewGameTypeViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 4/9/18.
//

#import "NewGameTypeViewController.h"
#import "PlayOnlineMainScreenViewController.h"
#import "TheAlerts.h"
#import "NewGameTypeButtonCell.h"
#import "MyManager.h"
#import "PlayOnlineMainScreenViewController.h"
#import "CreateChalengeController.h"
#import "NewGameTypeSimpleCell.h"
@interface NewGameTypeViewController (){
    NSArray *dataTableArray;
    NSArray *arrFontCode;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TheAlerts *theAlert;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation NewGameTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataTableArray = [NSArray arrayWithObjects:@"Open Challenges",@"Create Challenge",@"Play a Friend",@"Join a Tournament",@"Watch Games",nil];
    arrFontCode = @[@"i",@"i",@"n",@"O",@"9",@"7"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.theAlert = [[TheAlerts alloc]init];
    [self.coverView setHidden:true];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
//    if (self.appOnline.theFlag){
//        self.appOnline.theFlag = false;
//        [[MyManager sharedManager] showHUDWithTransform:@"Loading..." forView:self.view];
//        double delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            NSLog(@"Do some work");
//            [[MyManager sharedManager] removeHud];
//            PlayOnlineMainScreenViewController *playOnlineMain = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayOnlineMainScreenViewController"];
//            playOnlineMain.appOnline = self.appOnline;
//            [self.navigationController pushViewController:playOnlineMain animated:NO];
//            //[self presentViewController:gamePlayScreenVC animated:NO completion:nil];
//           // [self performSegueWithIdentifier:@"PlayOnline" sender:self];
//        });
//
//    }else{
//        [self.coverView setHidden:true];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBackButton:(id)sender {
    
  //[(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:NO];
    //[self.appOnline DeinitAppOnline:self];
    [self setVCTransition:kCATransitionReveal subType:kCATransitionFromTop childVC:self duration:0.7];
    [[self navigationController] popToRootViewControllerAnimated:true];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (games)
    //        return (self.viewFrame.size.height - 100) / games.count;
    return dataTableArray.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger row = indexPath.row;
    if (row == 0) {
        return 70;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
      NewGameTypeButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"buttoncell" forIndexPath:indexPath];
       // buttonCell.btnPlay.titleLabel.textColor = [UIColor grayColor];
       // buttonCell.btnTime.titleLabel.textColor = [UIColor grayColor];
        return buttonCell;
    }else{
    NewGameTypeSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (row == 5 || row == 2) {
            cell.lblText.text = dataTableArray[row - 1];
            cell.lblImage.text = arrFontCode[row-1];
            cell.lblText.textColor = [UIColor whiteColor];
            return cell;
        }
        
    cell.lblText.text = dataTableArray[row - 1];
    //cell.lblImage.font = [UIFont fontWithName:@"chessglyph-webfont" size:20];
   
    cell.lblImage.text = arrFontCode[row-1];
    cell.lblText.textColor = [UIColor grayColor];
        return cell;
    }
    
        
}
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        NSInteger row = indexPath.row;
        if (row == 5) {
            [self performSegueWithIdentifier:@"PlayOnline" sender:self];
        }else if (row == 2){
          [self performSegueWithIdentifier:@"createchalenge" sender:self];
        }
    }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PlayOnline"]) {
                PlayOnlineMainScreenViewController *pomsvc = (PlayOnlineMainScreenViewController*)segue.destinationViewController;
        pomsvc.appOnline = self.appOnline;
        NSLog(@"");
    }else if([segue.identifier isEqualToString:@"createchalenge"]) {
        CreateChalengeController *createChalengeVC = (CreateChalengeController*)segue.destinationViewController;
        createChalengeVC.appOnline = self.appOnline;
        NSLog(@"");
    }
}
    
@end

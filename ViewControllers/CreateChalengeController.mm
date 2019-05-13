//
//  CreateChalengeController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 5/2/18.
//

#import "CreateChalengeController.h"
#import "CreateChalengeTimeCell.h"
#import "CreateChalengeRatedCell.h"
#import "AppOnline.h"
#import "SocketSession.h"
#import "UIImage+animatedGIF.h"
#import "UIView+Toast.h"
#import "BaseVC.h"
#import "GamePlayScreenViewController.h"
#import "MyManager.h"

@interface CreateChalengeController (){
    int currentSelection ;
    bool isTappedTwice;
    bool isCustomBtnTapped;
    NSDictionary *createChalengeData;
    bool isGameScreenOpened;
    NSTimer *chalengeTimer;
    int timerCount;
}

@end

@implementation CreateChalengeController

- (void)viewDidLoad {
    [super viewDidLoad];
   //self.appOnline = [[MyManager sharedManager] againLoginAppOnline];
    currentSelection = 222;
    isTappedTwice = false;
    isCustomBtnTapped = false;
    isGameScreenOpened = false;
    createChalengeData = @{ @"time"     : @"5 min",
             @"latitude" : @"1",
         };
    timerCount = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
    CreateChalengeTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"timecell" forIndexPath:indexPath];
            if (isCustomBtnTapped){
                [timeCell.customTimeView setHidden:false];
            }else{
                [timeCell.customTimeView setHidden:true];
            }
        timeCell.delegate = self;
        return timeCell;
    }else if ([indexPath row] == 1) {
        UITableViewCell *randomCell = [tableView dequeueReusableCellWithIdentifier:@"randomusercell" forIndexPath:indexPath];
        return randomCell;
    }else if ([indexPath row] == 2) {
        CreateChalengeRatedCell *ratedCell = [tableView dequeueReusableCellWithIdentifier:@"ratedcell" forIndexPath:indexPath];
        return ratedCell;
    }else{
        UITableViewCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"typecell" forIndexPath:indexPath];
        return typeCell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)[indexPath row];
   
    if (row == 3){
        return 65;
    }
    
    if (row == 0) {
        
        if (isCustomBtnTapped) {
            return  500;
        }else{
            if (!isTappedTwice){
                return 61;
            }
            return 440;
        }
    }
   
        return 50;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CreateChalengeTimeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    int row = (int)[indexPath row];
//    if (row == 0 ) {
//        currentSelection = row;
//        isTappedTwice = !isTappedTwice;
//        isCustomBtnTapped = false;
//        [cell.customTimeView setHidden:true];
//        [tableView beginUpdates];
//        [tableView endUpdates];
//    }
//
}
- (IBAction)actionBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


//MARK:- Time Cell Delegate Methods
//on button Click
//Custom Button Action Mehod
-(void)CreateChalengeTimeCell:(UITableViewCell *)cell button1Pressed:(UIButton *)btn{
    CreateChalengeTimeCell *cell1 = (CreateChalengeTimeCell *)cell;
    isCustomBtnTapped = !isCustomBtnTapped;
   // [self.tableView beginUpdates];
  //  [self.tableView endUpdates];
    [self setBtnTimeValue:cell1];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp  animations:^{
     //  [cell1.customTimeView setHidden:!isCustomBtnTapped];
        [self.tableView beginUpdates];
        
    } completion:^(BOOL finished) {
        [cell1.customTimeView setHidden:!isCustomBtnTapped];
        [self.tableView endUpdates];
        //code for completion
    }];
    
    NSLog(@"sjhdkjshd");
}

-(void)CreateChalengeTimeCell:(UITableViewCell *)cell timeButtonPressed:(UIButton *)btn{
    CreateChalengeTimeCell *cell1 = (CreateChalengeTimeCell *)cell;
    createChalengeData = @{
                           @"time"     : cell1.btnTime.titleLabel.text,
                           @"latitude" : @"1"
                           };
    NSLog(@"DICTIONARY == %@",createChalengeData);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell1];
    int row = (int)[indexPath row];
    if (row == 0 ) {
        currentSelection = row;
        isTappedTwice = !isTappedTwice;
        isCustomBtnTapped = false;
        [cell1.customTimeView setHidden:true];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

-(void)setBtnTimeValue:(CreateChalengeTimeCell *)cell{
    if (isCustomBtnTapped){
        int myInt = [[NSNumber numberWithFloat:cell.slider.value*60] intValue];
        NSString *value = [NSString stringWithFormat:@"%i", myInt];
       // NSString *timeValue = [NSString stringWithFormat:@"%i,", myInt];
        [cell.btnSliderMinutes setTitle:value forState:normal];
    }else{
        [cell.slider setValue:0.1];
    }
}



- (IBAction)actionPlayButton:(id)sender {
   // [self ConnectToSocket];
     //if connected to server, send handshake
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending handshake!" MessageFlagType:logMessageFlagTypeSystem];

        [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
            [self.appOnline.socketSession SendHandShakeRequest];
        }];
    }

    // now send login
    if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
    {
        [CommonTasks LogMessage:@"sending login!" MessageFlagType:logMessageFlagTypeSystem];
            [self.appOnline sendCreateGameData:createChalengeData];
}
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
   // [[self navigationController] popViewControllerAnimated:NO];
    GamePlayScreenViewController *gamePlayScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePlayScreenViewController"];
    gamePlayScreenVC.appOnline = self.appOnline;
    gamePlayScreenVC.delegate = self;
    [self startTimer];
     [self.navigationController pushViewController:gamePlayScreenVC animated:NO];
}

-(void)stopTimer{
    [chalengeTimer invalidate];
    chalengeTimer = nil;
    timerCount = 0;
}

-(void)startTimer{
    [chalengeTimer invalidate];
    chalengeTimer = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        //run function methodRunAfterBackground
        chalengeTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(waitingTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:chalengeTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
}

-(void)waitingTimer{
    [self.appOnline sendCreateGameData:createChalengeData];
    timerCount = timerCount + 1;
}

- (void)chalengeCreated{
    
    [self stopTimer];
}

@end

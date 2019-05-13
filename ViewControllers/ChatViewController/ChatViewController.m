//
//  ChatViewController.m
//  InfinityChess2018
//
//  Created by Manoj Kumar on 9/5/18.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "CommonTasks.h"
#import "UIView+Toast.h"
#import "messageList.h"
#import "UIImage+FontAwesome.h"
struct messageDetails{
    __unsafe_unretained NSString *message;
     __unsafe_unretained NSNumber *recieverId;
};

@interface ChatViewController (){
   
    NSString *user1MsgCellIdentifier;
    NSString *user2MsgCellIdentifier;
    NSMutableArray *arrMessageId;
}
@end



@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // arrCellMessage = [[NSMutableArray alloc] init];
    user1MsgCellIdentifier = @"user1";
    user2MsgCellIdentifier = @"user2";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(messageResponse:)
                                                 name: @"icPacketMessageResponse"
                                               object: nil];
    UIImage *icon = [UIImage imageWithIcon:@"fa-send"
                           backgroundColor:[UIColor clearColor]
                                 iconColor:[UIColor whiteColor]
                                   andSize:CGSizeMake(20, 20)];
    [_btnSend setImage:icon forState:normal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)messageResponse:(NSNotification*)notificationSender{
    NSLog(@"");
    [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
        
//        Packet *packet = [Packet initFromDictionary:[notificationSender userInfo]];
//         messageList* msg = [[messageList alloc] init];
//        NSLog(@"%@",packet);
//        NSNumber *recieverId = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:201]];
//        NSString *message = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:202]];
//        NSNumber *messageId = [packet.PacketGetPacketCopy objectForKey:[[NSNumber alloc] initWithInt:203]];
//
//        msg.message = message;
//        msg.recieverId = _oppId;
//        msg.messageId = messageId;
//        msg.isSender = false;
//        for (int i = 0 ;i < _arrCellMessage.count ;i++){
//            messageList *arrMsgList =(messageList*)_arrCellMessage[i];
//           // if (arrMsgList.messageId == messageId)
//          //  return ;
//        }
          //  [_arrCellMessage addObject:msg];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [self tableViewScrollToBottom];
        });
        
    }];
     }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        ChatViewCell *chatUserCell1 = [tableView dequeueReusableCellWithIdentifier:user1MsgCellIdentifier forIndexPath:indexPath];
        //chatUserCell1.lblMessage.text = arrCellMessage[indexPath.row];
    
        ChatViewCell *chatUserCell2 = [tableView dequeueReusableCellWithIdentifier:user2MsgCellIdentifier forIndexPath:indexPath];
        //chatUserCell1.lblMessage.text = arrCellMessage[indexPath.row];
    
        messageList *message =(messageList*)_arrCellMessage[indexPath.row];
    if(message.isSender){
        chatUserCell1.lblMessage.text = message.message;
        return chatUserCell1;
    }else{
        chatUserCell2.lblMessage.text = message.message;
        return chatUserCell2;
    }
}

-(void)tableViewScrollToBottom{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_arrCellMessage count]-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)actionCrossButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrCellMessage.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
- (IBAction)actionSendBtn:(id)sender {
    messageList* msg = [[messageList alloc] init];
    NSString *message = _txtMessage.text;
    if (!message.isEmptyOrWhiteSpaces){
        msg.message = message;
        msg.recieverId = _oppId;
        msg.isSender = true;
        [_arrCellMessage addObject:msg];
    [self.appOnline sendMessageToOtherPlayer:_oppId :_txtMessage.text];
    _txtMessage.text = @"";
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
    
}
}

#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)notification
{
    // I'll try to make my text field 20 pixels above the top of the keyboard
    // To do this first we need to find out where the keyboard will be.
    
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    // When we move the textField up, we want to match the animation duration and curve that
    // the keyboard displays. So we get those values out now
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    
    // UIView's block-based animation methods anticipate not a UIVieAnimationCurve but a UIViewAnimationOptions.
    // We shift it according to the docs to get this curve.
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    
    // Now we set up our animation block.
    [UIView animateWithDuration:animationDuration
                          delay:0.5
                        options:animationOptions
                     animations:^{
                         // Now we just animate the text field up an amount according to the keyboard's height,
                         // as we mentioned above.
                         
                         [_txtFieldStackBtmConstraint setConstant:keyboardEndFrame.size.height];
                         if (_arrCellMessage.count > 0)
                         [self tableViewScrollToBottom];
                     }
                     completion:^(BOOL finished) {}];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         [_txtFieldStackBtmConstraint setConstant:0];
                         [self tableViewScrollToBottom];
                      
                     }
                     completion:^(BOOL finished) {}];
    
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [_txtFieldStackBtmConstraint setConstant:50];
//    return true;
//}



@end

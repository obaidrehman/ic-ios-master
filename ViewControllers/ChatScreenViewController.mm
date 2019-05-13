//
//  ChatScreenViewController.m
//  Infinity Chess iOS
//
//  Created by user on 3/24/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "ChatScreenViewController.h"
#import "CommonTasks.h"


@interface ChatScreenViewController ()

@property (weak, nonatomic) IBOutlet nTextField *textFieldChatBox;
//@property (weak, nonatomic) IBOutlet UITableView *tableViewChatWindow;
@property (weak, nonatomic) IBOutlet UIView *viewChatWindow;
@property (weak, nonatomic) IBOutlet UILabel *labelChat;
@property (weak, nonatomic) IBOutlet nButton *buttonSend;

@property (strong) RNRippleTableView *rippleView;

@end

@implementation ChatScreenViewController
{
    // these variable are used when chat window resizes due to on screen keyboard display
    CGRect originalFrame;
    CGFloat rowHeight;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.frame = self.viewFrame;
    self.viewChatWindow.frame = CGRectMake(self.viewChatWindow.bounds.origin.x, self.viewChatWindow.bounds.origin.y, self.view.frame.size.width, self.viewChatWindow.bounds.size.height);
    self.textFieldChatBox.frame = CGRectMake(self.textFieldChatBox.bounds.origin.x, self.textFieldChatBox.bounds.origin.y, self.view.frame.size.width - self.labelChat.bounds.origin.x * 3 - self.labelChat.bounds.size.width, self.textFieldChatBox.bounds.size.height);
    self.view.autoresizesSubviews = YES;
    [self.view setAutoresizingMask: (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight)];
    
    [self SetControlsAndThemes];
    
    [AppOptions SubscribeForKeyboardNotifications:self];
    [self SetChatWindow];
    
    // chats notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChatNotification:) name:@"AppOnlineChatNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    @try {
        if (self.rippleView)
        {
            // scroll to bottom
            [self ScrollToBottom];
            
            if (self.rippleView.visibleViews && self.rippleView.visibleViews.count > 0)
                [self.rippleView rippleAtOrigin:self.rippleView.visibleViews.count - 1];
        }
    }
    @catch (NSException *exception)
    {
        [CommonTasks LogMessage:exception.description MessageFlagType:logMessageFlagTypeError];
    }
    
}

- (void)SetControlsAndThemes
{
    [self.textFieldChatBox SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:[UIColor colorWithHexString:@"#0b2744"]
                                                                  TextFieldTextColor:[UIColor colorWithHexString:@"#0b2744"]
                                                              TextFieldTextAlignment:NSTextAlignmentLeft
                                                            TextFieldBackgroundColor:[UIColor clearColor]];
    self.labelChat.textColor = [UIColor colorWithHexString:@"#0b2744"];
    
    [self.buttonSend SetAsImageOnlyButtonWithImage:[UIImage imageNamed:@"iconSend"]
                                 ImageScalingValue:4
                                    ImageTintColor:[UIColor whiteColor]//[UIColor colorWithHexString:@"#0b2744"]
                                      CornerRadius:(self.buttonSend.frame.size.width / 2)
                             ButtonBackgroundColor:[UIColor colorWithHexString:@"#0b2744"]//[UIColor clearColor]
                                      Transparency:1
                                   DropShadowColor:nil
                                  DropShadowRadius:0
                                 DropShadowOpacity:0
                                  DropShadowOffset:CGSizeZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // remove the keyboard from view
    [self.textFieldChatBox resignFirstResponder];
    
    if (self.textFieldChatBox.text && !self.textFieldChatBox.text.isEmptyOrWhiteSpaces)
    {
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            NSString *chatText = self.textFieldChatBox.text;
            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                
                [self.appOnline SendChatMessage:chatText
                                  ChatMessageID:[self.appOnline.User.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"RoomID"]
                                         ToUser:[NSString Empty]
                                     WithGameID:@"0"
                                       ChatType:chatTypeAllWindows
                                    MessageType:chatMessageTypeAdminMessage
                                   AudienceType:chatAudienceTypeRoom];
                
            }];
            
        
        }
        self.textFieldChatBox.text = [NSString Empty];
    }
    
    return YES;
}
- (IBAction)ButtonSendTapped:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.textFieldChatBox.text && !self.textFieldChatBox.text.isEmptyOrWhiteSpaces)
    {
        if ([self.appOnline CheckServerConnectionStateForDataFlow:10])
        {
            NSString *chatText = self.textFieldChatBox.text;
            [CommonTasks DoAsyncTaskOnNetworkingQueue:^{
                
                [self.appOnline SendChatMessage:chatText
                                  ChatMessageID:[self.appOnline.User.UserData FetchColumnValueOfRowAtIndexFromTable:0 ColumnName:@"RoomID"]
                                         ToUser:[NSString Empty]
                                     WithGameID:@"0"
                                       ChatType:chatTypeAllWindows
                                    MessageType:chatMessageTypeAdminMessage
                                   AudienceType:chatAudienceTypeRoom];
                
            }];
            
            
        }
        self.textFieldChatBox.text = [NSString Empty];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the keyboard from view
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)SetChatWindow
{
    //self.tableViewChatWindow.separatorColor = [UIColor clearColor];
    //self.tableViewChatWindow.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableViewChatWindow.backgroundColor = [UIColor clearColor];
    self.viewChatWindow.backgroundColor = [UIColor clearColor];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.viewChatWindow.frame.origin.x,
                                                                   self.viewChatWindow.frame.origin.y,
                                                                   self.viewChatWindow.frame.size.width,
                                                                   50.f)];
    labelTitle.text = @" Chats";
    labelTitle.font = [UIFont boldSystemFontOfSize:24];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.backgroundColor = [UIColor colorWithHexString:@"#0b2744"];
    [self.viewChatWindow addSubview:labelTitle];
    
    self.rippleView = [[RNRippleTableView alloc] initWithFrame:CGRectMake(self.viewChatWindow.frame.origin.x,
                                                                          self.viewChatWindow.frame.origin.y + 50,
                                                                          self.viewChatWindow.frame.size.width,
                                                                          self.viewChatWindow.frame.size.height - 70 * 2)];// self.viewChatWindow.frame];
    self.rippleView.ripplesOnShake = YES;
    self.rippleView.rippleDuration = 1.5f;
    [self.rippleView registerContentViewClass:[RNSampleCell class]];
    self.rippleView.delegate = self;
    self.rippleView.dataSource = self;
    
    [self.viewChatWindow addSubview:self.rippleView];
}

- (NSInteger)numberOfItemsInTableView:(RNRippleTableView *)tableView
{
    if (self.appOnline.User.Chats)
        return self.appOnline.User.Chats.count;
    return 0;
}

- (UIView *)viewForTableView:(RNRippleTableView *)tableView atIndex:(NSInteger)index withReuseView:(RNSampleCell *)reuseView
{
    if (self.appOnline.User.Chats && self.appOnline.User.Chats.count > 0 && index < self.appOnline.User.Chats.count)
    {
        // assign default name and message
        NSString *senderName;
        NSString *senderMessage;
        
        // check if chat message is by a user or server
        NSRange stringNameHelper = [self.appOnline.User.Chats[index] rangeOfString:@" (To "];
        NSRange stringMessageHelper = [self.appOnline.User.Chats[index] rangeOfString:@") : "];
        if (stringNameHelper.location != NSNotFound && stringMessageHelper.location != NSNotFound)
        {
            senderName = [self.appOnline.User.Chats[index] substringWithRange:NSMakeRange(0, stringNameHelper.location)];
            senderMessage = [self.appOnline.User.Chats[index] substringWithRange:NSMakeRange(stringMessageHelper.location + stringMessageHelper.length, ((NSString*)self.appOnline.User.Chats[index]).length - (stringMessageHelper.location + stringMessageHelper.length))];
        }
        else    // this means message is by server
        {
            senderName = [NSString Empty];
            senderMessage = self.appOnline.User.Chats[index];
        }
        
        NSMutableAttributedString *chatMessage;
        if (senderName.isEmptyOrWhiteSpaces)
        {
            chatMessage = [[NSMutableAttributedString alloc] initWithString:senderMessage];
            [chatMessage addAttribute:NSForegroundColorAttributeName
                        value:[UIColor grayColor]
                        range:NSMakeRange(0, senderMessage.length)];
        }
        else
        {
            chatMessage = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@:\t%@", senderName, senderMessage]];
            [chatMessage addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithHexString:@"#0b2744"]
                                range:NSMakeRange(0, 2 + senderName.length + 1 + senderMessage.length + 1)];
            [chatMessage addAttribute:NSForegroundColorAttributeName
                                value:[UIColor grayColor]
                                range:NSMakeRange(0, 2 + senderName.length + 1)];
        }
        
        
        // theme?
        reuseView.backgroundColor = [UIColor whiteColor];// [UIColor colorWithRed:117/255.f green:184/255.f blue:174/255.f alpha:1];
        reuseView.titleLabel.attributedText = chatMessage;
        reuseView.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        reuseView.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.1f];
        reuseView.titleLabel.shadowOffset = CGSizeMake(0, -1);
        reuseView.titleLabel.numberOfLines = 0;
        reuseView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [reuseView.titleLabel sizeToFit];
        reuseView.titleLabel.textAlignment = senderName.isEmptyOrWhiteSpaces ? NSTextAlignmentCenter : [senderName isEqualToString:self.appOnline.User.UserName] ? NSTextAlignmentRight : NSTextAlignmentLeft;
        reuseView.dividerLayer.backgroundColor = [UIColor whiteColor].CGColor;
        
       return reuseView;
    }
    return nil;
}

- (CGFloat)heightForViewInTableView:(RNRippleTableView *)tableView atIndex:(NSInteger)index
{
    rowHeight = 35;
    return rowHeight;
}

- (void)tableView:(RNRippleTableView *)tableView didSelectView:(UIView *)view atIndex:(NSInteger)index {
    NSLog(@"Row %li tapped",(long)index);
}

- (void)ChatNotification:(NSNotification*)notificationSender
{
    [CommonTasks DoAsyncTaskOnMainQueue:^{

        //[self.rippleView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
        [self.rippleView reloadData];

        // scroll to bottom
        [self ScrollToBottom];
        
    }];


}

- (void)ScrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, self.rippleView.contentSize.height - self.rippleView.bounds.size.height);
    if (bottomOffset.y >= 0.0)
        [self.rippleView setContentOffset:bottomOffset animated:YES];
}

- (void)KeyboardDidShowNotification:(NSNotification*)notificationSender
{
    [AppOptions SetViewMovedUp:YES View:self.view KeyboardNotification:notificationSender ErrorValue:0];
    
    // set chat view frame to smaller size
    originalFrame = self.rippleView.frame;
    self.rippleView.frame = CGRectMake(originalFrame.origin.x,
                                       originalFrame.origin.y,
                                       originalFrame.size.width,
                                       originalFrame.size.height / 2 - rowHeight * 2);
    [self ScrollToBottom];

}

- (void)KeyboardWillHideNotification:(NSNotification*)notificationSender
{
    [AppOptions SetViewMovedUp:NO View:self.view KeyboardNotification:notificationSender ErrorValue:0];

    // set chat view frame to original size
    self.rippleView.frame = originalFrame;
    [self ScrollToBottom];
}

@end

//
//  nView.m
//  Infinity Chess iOS
//
//  Created by user on 5/30/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nView.h"

@implementation nView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initAsPrivateChatViewWithFrame:(CGRect)frame TextField:(nTextField*)textField andSendButton:(nButton *)sendButton
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        textField.frame = CGRectMake(self.frame.origin.x,
                                     self.frame.origin.y,
                                     self.frame.size.width - 50.f,
                                     30.0f);
        [textField SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:[UIColor whiteColor]
                                                          TextFieldTextColor:[UIColor whiteColor]
                                                      TextFieldTextAlignment:NSTextAlignmentLeft
                                                    TextFieldBackgroundColor:[UIColor clearColor]];
        [self addSubview:textField];
        
        sendButton.frame = CGRectMake(self.frame.size.width - 30.0f,
                                      self.frame.origin.y,
                                      30.f,
                                      30.f);
        [sendButton SetAsImageOnlyButtonWithImage:[UIImage imageNamed:@"iconSend"]
                                ImageScalingValue:4
                                   ImageTintColor:[UIColor whiteColor]
                                     CornerRadius:(sendButton.frame.size.width / 2)
                            ButtonBackgroundColor:[UIColor clearColor]
                                     Transparency:1
                                  DropShadowColor:nil
                                 DropShadowRadius:0
                                DropShadowOpacity:0
                                 DropShadowOffset:CGSizeZero];
        [self addSubview:sendButton];
    }
    return self;
}

@end

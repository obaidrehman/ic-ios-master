//
//  nTextField.m
//  Infinity Chess iOS
//
//  Created by user on 5/30/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nTextField.h"

@implementation nTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:(UIColor*)bottomBorderColor
                                               TextFieldTextColor:(UIColor*)textColor
                                           TextFieldTextAlignment:(NSTextAlignment)textAlignment
                                         TextFieldBackgroundColor:(UIColor*)backgroundColor
{
    // for this plz add border style line to UI design first!
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textAlignment = textAlignment;
    
    self.borderStyle = UITextBorderStyleLine;
    if (textColor) self.textColor = textColor;
    if (backgroundColor) self.backgroundColor = backgroundColor;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0.0f, self.layer.bounds.size.height - 1.0f, self.layer.bounds.size.width, 1.0f);
    layer.backgroundColor = bottomBorderColor.CGColor;
    layer.masksToBounds = NO;
    [self.layer addSublayer:layer];
    self.borderStyle = UITextBorderStyleNone;
}

@end

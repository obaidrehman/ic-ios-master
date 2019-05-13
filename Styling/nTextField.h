//
//  nTextField.h
//  Infinity Chess iOS
//
//  Created by user on 5/30/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nTextField : UITextField

@property (strong) NSString* tagString;
@property (strong) NSObject* extraInfo;

/// @description for this plz add border style line to UI design first!
- (void)SetAsTextFieldWithBottomBorderOnlyHavingBottomBorderColor:(UIColor*)bottomBorderColor
                                               TextFieldTextColor:(UIColor*)textColor
                                           TextFieldTextAlignment:(NSTextAlignment)textAlignment
                                         TextFieldBackgroundColor:(UIColor*)backgroundColor;

@end

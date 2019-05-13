//
//  ButtonMainMenu.h
//  Infinity Chess iOS
//
//  Created by user on 3/16/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface nButton : UIButton

@property (strong) NSString* tagString;
@property (strong) NSObject* extraInfo;

- (instancetype)initWithFrame:(CGRect)frame;

- (void) SetAsDualColorButtonWithText:(NSString*)text
                            TextColor:(UIColor*)textColor
                         TextFontType:(UIFont*)textFont
                          TextScaling:(CGFloat)textScalingPercent
                        TextAlignment:(NSTextAlignment)textAlignment
                                Image:(UIImage*)image
                  ImageScalingPercent:(CGFloat)imageScalingPercent
                       ImageTintColor:(UIColor*)imageTintColor
                      ImageOnLeftSide:(BOOL)imageOnLeftSide
                            LeftColor:(UIColor*)leftColor
                     LeftColorPercent:(CGFloat)leftColorPercent
                           RightColor:(UIColor*)rightColor
                         CornerRadius:(CGFloat)cornerRadius
                         Transparency:(CGFloat)buttonAlpha
                      DropShadowColor:(UIColor*)dropShadowColor
                     DropShadowRadius:(CGFloat)dropShadowRadius
                    DropShadowOpacity:(CGFloat)dropShadowOpacity
                     DropShadowOffset:(CGSize)dropShadowOffset;

- (void) SetAsImageOnlyButtonWithImage:(UIImage*)image
                     ImageScalingValue:(CGFloat)imageScaling
                        ImageTintColor:(UIColor*)imageTintColor
                          CornerRadius:(CGFloat)cornerRadius
                 ButtonBackgroundColor:(UIColor*)backgroundColor
                          Transparency:(CGFloat)buttonAlpha
                       DropShadowColor:(UIColor*)dropShadowColor
                      DropShadowRadius:(CGFloat)dropShadowRadius
                     DropShadowOpacity:(CGFloat)dropShadowOpacity
                      DropShadowOffset:(CGSize)dropShadowOffset;

@end

//
//  ButtonMainMenu.m
//  Infinity Chess iOS
//
//  Created by user on 3/16/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nButton.h"
#import "AppOptions.h"
//#import "AppThemes.h"
#import "CommonTasks.h"


@implementation nButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //[[AppOptions AppOptionsInstance].themes DefaultButton:self];
        //[[AppOptions AppOptionsInstance].themes ThemeButton:self];
    }
    return self;
}

- (void)SetAsDualColorButtonWithText:(NSString *)text
                           TextColor:(UIColor *)textColor
                        TextFontType:(UIFont *)textFont
                         TextScaling:(CGFloat)textScalingPercent
                       TextAlignment:(NSTextAlignment)textAlignment
                               Image:(UIImage *)image
                 ImageScalingPercent:(CGFloat)imageScalingPercent
                      ImageTintColor:(UIColor *)imageTintColor
                     ImageOnLeftSide:(BOOL)imageOnLeftSide
                           LeftColor:(UIColor *)leftColor
                    LeftColorPercent:(CGFloat)leftColorPercent
                          RightColor:(UIColor *)rightColor
                        CornerRadius:(CGFloat)cornerRadius
                        Transparency:(CGFloat)buttonAlpha
                     DropShadowColor:(UIColor *)dropShadowColor
                    DropShadowRadius:(CGFloat)dropShadowRadius
                   DropShadowOpacity:(CGFloat)dropShadowOpacity
                    DropShadowOffset:(CGSize)dropShadowOffset
{
    if (self.titleLabel.text)
        self.titleLabel.text = [NSString Empty];
    self.layer.cornerRadius = cornerRadius;
    self.backgroundColor = [UIColor clearColor];
    
    // add base layer
    if (dropShadowColor)
    {
        CALayer *baselayer = [CALayer layer];
        baselayer.frame = self.layer.bounds;
        baselayer.backgroundColor = [UIColor blackColor].CGColor;
        baselayer.shadowColor = dropShadowColor.CGColor;
        baselayer.shadowOpacity = dropShadowOpacity;
        baselayer.shadowOffset = dropShadowOffset;
        baselayer.shadowRadius = dropShadowRadius;
        baselayer.cornerRadius = cornerRadius;
        baselayer.masksToBounds = NO;
        [self.layer addSublayer:baselayer];
    }
    
    // add left layer
    CGFloat leftWidth = (self.frame.size.width / 100) * leftColorPercent;
    CALayer *leftlayer = [CALayer layer];
    leftlayer.frame = CGRectMake(self.layer.bounds.origin.x,
                                 self.layer.bounds.origin.y,
                                 leftWidth,
                                 self.layer.bounds.size.height);
    leftlayer.backgroundColor = leftColor ? leftColor.CGColor : [UIColor clearColor].CGColor;
    leftlayer.cornerRadius = self.layer.cornerRadius;
    leftlayer.masksToBounds = YES;
    
    
    // add right layer
    CGFloat rightWidth = self.frame.size.width - leftWidth;
    CALayer *rightlayer = [CALayer layer];
    rightlayer.frame = CGRectMake(self.layer.bounds.origin.x + leftWidth,
                                 self.layer.bounds.origin.y,
                                 rightWidth,
                                 self.layer.bounds.size.height);
    rightlayer.backgroundColor = rightColor ? rightColor.CGColor : [UIColor clearColor].CGColor;
    rightlayer.cornerRadius = self.layer.cornerRadius;
    rightlayer.masksToBounds = YES;
    
    // add join layer
    CALayer *joinlayer = [CALayer layer];
    if (imageOnLeftSide)
    {
        joinlayer.frame = CGRectMake(rightlayer.frame.origin.x - cornerRadius,
                                      rightlayer.frame.origin.y,
                                      rightWidth - cornerRadius,
                                      rightlayer.frame.size.height);
        joinlayer.backgroundColor = rightColor ? rightColor.CGColor : [UIColor clearColor].CGColor;
    }
    else
    {
        joinlayer.frame = CGRectMake(leftlayer.frame.origin.x + cornerRadius,
                                     leftlayer.frame.origin.y,
                                     leftWidth + cornerRadius,
                                     leftlayer.frame.size.height);
        joinlayer.backgroundColor = leftColor ? leftColor.CGColor : [UIColor clearColor].CGColor;
    }
    joinlayer.cornerRadius = 0;
    joinlayer.masksToBounds = YES;
    
    // add layers
    [self.layer addSublayer:leftlayer];
    [self.layer addSublayer:rightlayer];
    [self.layer addSublayer:joinlayer];
    
    // add text label
    UILabel *labelText = [[UILabel alloc] init];
    if (text)           labelText.text = text;
    if (textColor)      labelText.textColor = textColor;
    if (textFont)       labelText.font = textFont;
    if (textAlignment)  labelText.textAlignment = textAlignment;
    labelText.backgroundColor = [UIColor clearColor];
    labelText.numberOfLines = 1;
    labelText.frame = CGRectMake(joinlayer.frame.origin.x + textScalingPercent,
                                 joinlayer.frame.origin.y + textScalingPercent,
                                 joinlayer.frame.size.width - textScalingPercent * 2,
                                 joinlayer.frame.size.height - textScalingPercent * 2);
    [labelText setCenter:CGPointMake(joinlayer.frame.origin.x + joinlayer.frame.size.width / 2 + (imageOnLeftSide ? cornerRadius : -cornerRadius),
                                     joinlayer.frame.origin.y + joinlayer.frame.size.height / 2)];
    [self addSubview:labelText];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (image) imageView.image = image;
    if (imageTintColor) {   imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            [imageView setTintColor:imageTintColor];    }

    CGRect imageFrame = imageOnLeftSide ? leftlayer.frame : rightlayer.frame;
    CGFloat imageLength = imageOnLeftSide ? (imageFrame.size.height > imageFrame.size.width - cornerRadius ? imageFrame.size.width - cornerRadius : imageFrame.size.height) : (imageFrame.size.height > imageFrame.size.width - cornerRadius ? imageFrame.size.width - cornerRadius : imageFrame.size.height);
    imageView.frame = CGRectMake(imageFrame.origin.x + imageScalingPercent,
                                 imageFrame.origin.y + imageScalingPercent,
                                 imageLength - imageScalingPercent * 2,
                                 imageLength -  imageScalingPercent * 2);
    [imageView setCenter:CGPointMake(imageFrame.origin.x + imageFrame.size.width / 2 + (imageOnLeftSide ? 0 : cornerRadius),
                                     imageFrame.origin.y + imageFrame.size.height / 2)];
    [self addSubview:imageView];
}

- (void)SetAsImageOnlyButtonWithImage:(UIImage *)image
                    ImageScalingValue:(CGFloat)imageScaling
                       ImageTintColor:(UIColor *)imageTintColor
                         CornerRadius:(CGFloat)cornerRadius
                ButtonBackgroundColor:(UIColor *)backgroundColor
                         Transparency:(CGFloat)buttonAlpha
                      DropShadowColor:(UIColor *)dropShadowColor
                     DropShadowRadius:(CGFloat)dropShadowRadius
                    DropShadowOpacity:(CGFloat)dropShadowOpacity
                     DropShadowOffset:(CGSize)dropShadowOffset
{
    if (self.titleLabel.text)
        self.titleLabel.text = [NSString Empty];
    self.layer.cornerRadius = cornerRadius;
    self.backgroundColor = backgroundColor;
    
    // add base layer
    CALayer *baselayer = [CALayer layer];
    baselayer.frame = self.layer.bounds;
    baselayer.backgroundColor = backgroundColor.CGColor;
    baselayer.shadowColor = dropShadowColor.CGColor;
    baselayer.shadowOpacity = dropShadowOpacity;
    baselayer.shadowOffset = dropShadowOffset;
    baselayer.shadowRadius = dropShadowRadius;
    baselayer.cornerRadius = cornerRadius;
    baselayer.masksToBounds = NO;
    [self.layer addSublayer:baselayer];

    

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:baselayer.frame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = imageScaling != 1.0f ?
                    [ImageEditing ImageByScalingImage:image ByValue:imageScaling] :
                    [ImageEditing ImageByScalingImage:image
                                 ProportionallyToSize:CGSizeMake(imageView.frame.size.width,
                                                                 imageView.frame.size.height)];
    if (imageTintColor)
        [ImageEditing ImageApplyTintColorToImageView:imageView TintColor:imageTintColor];
    [self addSubview:imageView];
    
}


/*
- (void) MakeMenuButton
{
    //CALayer *layer = self.layer;
    self.layer.sublayers = nil;
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.layer.bounds;
    layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f].CGColor;//[UIColor colorWithRed:0.25f green:0.50f blue:0.86f alpha:1.0f].CGColor;
    layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.15f;
    layer.shadowOffset = CGSizeZero;
    layer.cornerRadius = 15.0f;
    layer.masksToBounds = NO;
    [self.layer addSublayer:layer];
    
//    layer = [CALayer layer];
//    layer.frame = self.layer.bounds;
//    layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f].CGColor;
//    layer.cornerRadius = 15.0f;
//    layer.masksToBounds = NO;
//    [self.layer addSublayer:layer];
    
    
//    layer = [CALayer layer];
//    layer.frame = self.layer.bounds;
//    NSString *imageName = @"play_offline.png";
//    UIGraphicsBeginImageContext(layer.frame.size); //CGSizeMake(layer.frame.size.width - 20.0f, layer.frame.size.height - 10.0f));
//    [[UIImage imageNamed:imageName] drawInRect:layer.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIColor *backGroundImage = [UIColor colorWithPatternImage:image];
//    layer.backgroundColor = backGroundImage.CGColor;
//    //layer.cornerRadius = 15.0f;
//    [self.layer addSublayer:layer];
    
//    layer = [[CALayer alloc] initWithLayer:mainlayer];
//    layer.masksToBounds = YES;
//    layer.cornerRadius = 15.0f;
//    layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.7f].CGColor;
    
    //[layer setBorderWidth:1.0f];
    //[layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor]; //[[UIColor blackColor] CGColor]];

//    self.titleLabel.layer.shadowColor = self.currentTitleColor.CGColor;
//    self.titleLabel.layer.shadowRadius = 2.0f;
//    self.titleLabel.layer.shadowOpacity = 0.9f;
//    self.titleLabel.layer.shadowOffset = CGSizeZero;
//    self.titleLabel.layer.masksToBounds = NO;

//    [self.layer addSublayer:layer];
    
    //newLayer.masksToBounds = YES;
    //layer.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f].CGColor;
    //newLayer.bounds = self.layer.bounds;
//    newLayer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
//    newLayer.shadowRadius = 4.0f;
//    newLayer.shadowOpacity = 1.0f;
//    newLayer.shadowOffset = CGSizeZero;
//    newLayer.masksToBounds = YES;
    //newLayer.bounds = self.layer.bounds;
    //newLayer.position = self.layer.position;
   // newLayer.frame = self.layer.frame;
//    newLayer.bounds = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    
    //self.layer.sublayers = nil;
    
    
//    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
}
*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

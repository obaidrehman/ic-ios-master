//
//  nMoonButtonView.m
//
//  Created by user on 5/25/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nMoonButtonView.h"
#import "CommonTasks.h"

@implementation nMoonButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)SubscribeToMoonButtonTapNotification:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] addObserver:subscriber selector:@selector(MoonButtonTapped:) name:@"MoonButtonTapped" object:nil];
}

- (void)UnSubscribeToMoonButtonTapNotification:(id)subscriber
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)SetToParentView:(UIView *)parentView
         withMoonRadius:(CGFloat)moonRadius
              MoonShape:(enum MoonShape)moonShape
               MoonType:(enum MoonType)moonType
             MoonAnchor:(enum MoonAnchor)moonAnchor
              MoonColor:(UIColor *)moonColor
          MoonGlowColor:(UIColor *)moonGlowColor
        MoonGlowAmount:(CGFloat)moonGlowAmount
                  Image:(UIImage *)image
    imageScalingPercent:(CGFloat)imageScalePercent
         ImageTintColor:(UIColor *)imageTintColor
       MoonTransparency:(CGFloat)moonAlpha
             MoonMargin:(NSArray *)topRightBottomLeftMargin
{
    // set frame
    self.frame = CGRectMake(0.0f, 0.0f, moonRadius, moonRadius);
    
    if (moonShape != squareMoon) // square shape dont need corner radius
        self.layer.cornerRadius = moonShape == roundMoon ? moonRadius / 2.0f : moonRadius;

    // add to parent view
    [parentView addSubview:self];
    
    // set inner graphics
    CALayer *moonlayer = [CALayer layer];
    moonlayer.frame = self.layer.bounds;
    moonlayer.backgroundColor = moonColor.CGColor;
    moonlayer.shadowColor = moonGlowColor.CGColor;
    moonlayer.shadowRadius = moonGlowAmount;
    moonlayer.shadowOpacity = 0.7f;
    moonlayer.shadowOffset = CGSizeZero;
    moonlayer.cornerRadius = self.layer.cornerRadius;
    moonlayer.masksToBounds = NO;
    
    
    
    if (moonType != darkMoon)
        [self.layer addSublayer:moonlayer];
    
    switch (moonAnchor)
    {
        case anchorMoonToTopLeft:
            
            if (moonType == firstQuarterMoon)
                self.frame = CGRectMake(parentView.frame.origin.x - self.frame.size.width / 2,
                                        parentView.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            else
                self.frame = CGRectMake(parentView.frame.origin.x,
                                        parentView.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            
            break;

        case anchorMoonToTopRight:
            
            if (moonType == thirdQuarterMoon)
                self.frame = CGRectMake(parentView.frame.size.width - (self.frame.size.width / 2),
                                        parentView.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            else
                self.frame = CGRectMake(parentView.frame.size.width - self.frame.size.width,
                                        parentView.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            
            break;
            
        case anchorMoonToBottomLeft:
            
            if (moonType == firstQuarterMoon)
                self.frame = CGRectMake(parentView.frame.origin.x - self.frame.size.width / 2,
                                        parentView.frame.size.height - self.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);
            else
                self.frame = CGRectMake(parentView.frame.origin.x,
                                        parentView.frame.size.height - self.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);
            
            break;
            
        case anchorMoonToBottomRight:
            
            if (moonType == thirdQuarterMoon)
                self.frame = CGRectMake(parentView.frame.size.width - self.frame.size.width / 2,
                                        parentView.frame.size.height - self.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);
            else
                self.frame = CGRectMake(parentView.frame.size.width - self.frame.size.width,
                                        parentView.frame.size.height - self.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);

            break;
    }
    
    if (topRightBottomLeftMargin)
    {
        self.frame = CGRectMake(self.frame.origin.x + [topRightBottomLeftMargin[3] floatValue] - [topRightBottomLeftMargin[1] floatValue],
                                self.frame.origin.y + [topRightBottomLeftMargin[0] floatValue] - [topRightBottomLeftMargin[2] floatValue],
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (image)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((moonRadius / 100) * imageScalePercent,
                                     (moonRadius / 100) * imageScalePercent,
                                     moonRadius - ((moonRadius / 100) * imageScalePercent) * 2,
                                     moonRadius - ((moonRadius / 100) * imageScalePercent) * 2);
        if (imageTintColor)
        {
            imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [imageView setTintColor:imageTintColor];
        }
        [self addSubview:imageView];
    }
    
    // set moon button transparency
    self.alpha = moonAlpha;
    

    
    // add tap event to moon button
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(nMoonButtonTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}



- (void)nMoonButtonTapped:(UITapGestureRecognizer*)sender
{
    [CommonTasks LogMessage:@"moon button tapped!" MessageFlagType:logMessageFlagTypeSystem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoonButtonTapped" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:sender, @"sender", nil]];
}

- (void) MoonButtonTapped:(NSNotification*)notificationSender
{
    // this is implemented by the subscriber
}

@end

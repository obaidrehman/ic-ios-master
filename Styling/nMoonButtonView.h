//
//  nMoonButtonView.h
//
//  Created by Nabeeg Mukhtar on 5/25/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MoonType
{
    darkMoon,           // hollow, empty
    fullMoon,           // complete circle
    firstQuarterMoon,   // left half
    thirdQuarterMoon,   // right half
};

enum MoonAnchor
{
    anchorMoonToTopLeft,
    anchorMoonToTopRight,
    anchorMoonToBottomLeft,
    anchorMoonToBottomRight,
};

enum MoonShape
{
    roundMoon,
    squareMoon,
    rhombusMoon,
};

@interface nMoonButtonView : UIView

@property (strong) NSString* tagString;
@property (strong) NSObject* extraInfo;

/// @description this lets a class subscribe to moon button tapped event
///
/// the event is "-(void)MoonButtonTapped:(NSNotification*)notificationSender"
///
/// notificationSender > userInfo contains a dictionary with key @"sender" and value of "UITapGestureRecognizer*"
- (void) SubscribeToMoonButtonTapNotification:(id)subscriber;

/// @description this unsubscribe from the moon tapped event
- (void) UnSubscribeToMoonButtonTapNotification:(id)subscriber;

/// @description this sets a moon button to a view with the params specified
/// @param parentView this is the view which will hold the moon button
/// @param moonRadius the radius of the moon
/// @param moonShape the shape of the moon values are "roundMoon", "squareMoon", "rhombusMoon"
/// @param moonType the type of the moon values are "darkMoon", "fullMoon", "firstQuarterMoon", "thirdQuarterMoon"
/// @param moonAnchor the anchoring to parent view values are "anchorMoonToTopLeft", "anchorMoonToTopRight", "anchorMoonToBottomLeft", "anchorMoonToBottomRight"
/// @param moonColor this is the color of the moon
/// @param moonGlowColor this is the glow color of the moon
/// @param moonGlowAmount this is the glow amount for the moon
/// @param image this is the image on the moon button
/// @param imageScalePercent this is the scaling percent for the image
/// @param imageTintColor this is the tint color for the image
/// @param moonAlpha this is the transparency of the moon button
/// @param topRightBottomLeftMargin this is the margin of the moon button, should be specifed as @[ @(0), @(0), @(0), @(0) ]
- (void) SetToParentView:(UIView*)parentView

          withMoonRadius:(CGFloat)moonRadius
               MoonShape:(enum MoonShape)moonShape
                MoonType:(enum MoonType)moonType
              MoonAnchor:(enum MoonAnchor)moonAnchor
               MoonColor:(UIColor*)moonColor
           MoonGlowColor:(UIColor*)moonGlowColor
         MoonGlowAmount:(CGFloat)moonGlowAmount

                   Image:(UIImage*)image
     imageScalingPercent:(CGFloat)imageScalePercent
          ImageTintColor:(UIColor*)imageTintColor

        MoonTransparency:(CGFloat)moonAlpha
              MoonMargin:(NSArray*)topRightBottomLeftMargin;

@end

//
//  nImageTextButtonElegant.h
//  Infinity Chess iOS
//
//  Created by user on 23/06/2015.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOptions.h"
#import "CommonTasks.h"

IB_DESIGNABLE

@interface nImageTextButtonElegant : UIButton

@property IBInspectable CGFloat buttonCornerRadius;
@property IBInspectable CGFloat contentPadding;
@property IBInspectable NSString* imageName;
@property IBInspectable BOOL imageOnLeftSide;
@property IBInspectable CGFloat imageScalingValue;

@end

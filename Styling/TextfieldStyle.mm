//
//  TextfieldStyle.m
//  Infinity Chess iOS
//
//  Created by user on 3/18/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "TextfieldStyle.h"
#import "AppOptions.h"
//#import "AppThemes.h"

@implementation TextfieldStyle

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
//        [[AppOptions AppOptionsInstance].themes DefaultTextField:self];
        //[[AppOptions AppOptionsInstance].themes ThemeTextField:self];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

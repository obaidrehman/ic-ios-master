//
//  nBackgroundViewElegant.m
//  Infinity Chess iOS
//
//  Created by user on 23/06/2015.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nBackgroundViewElegant.h"

@implementation nBackgroundViewElegant


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIImage *image = [UIImage imageNamed:@"backgroundElegant"];
    [image drawInRect:rect];
}


@end

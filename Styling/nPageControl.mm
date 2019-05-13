//
//  nPageControl.m
//  Infinity Chess iOS
//
//  Created by user on 29/06/2015.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "nPageControl.h"

@implementation nPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        if ([dot isKindOfClass:[UIView class]])
        {
            //if ([self.subviews count] == 1)
                dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, ((UIImage*)self.activeImage[i]).size.width, ((UIImage*)self.activeImage[i]).size.height);
//            else
//            {
//                CGFloat spacing = (self.frame.size.width - 10) / [self.subviews count];
//                dot.frame = CGRectMake(5 + spacing * i, dot.frame.origin.y, ((UIImage*)self.activeImage[i]).size.width, ((UIImage*)self.activeImage[i]).size.height);
//                dot.center = CGPointMake(spacing * i, 10);
//            }
            
            if (i == self.currentPage)
                dot.backgroundColor = [UIColor colorWithPatternImage:(UIImage*)self.activeImage[i]];
            else
                dot.backgroundColor = [UIColor colorWithPatternImage:(UIImage*)self.inactiveImage[i]];
        }
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end

//
//  nPageControl.h
//  Infinity Chess iOS
//
//  Created by user on 29/06/2015.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nPageControl : UIPageControl

@property NSMutableArray *activeImage;
@property NSMutableArray *inactiveImage;

-(void)updateDots;

@end

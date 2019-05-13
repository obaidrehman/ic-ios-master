//
//  SubMenuTableCell.h
//  Infinity Chess iOS
//
//  Created by user on 3/23/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubMenuTableCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

- (id)initWithStyle:(UITableViewCellStyle)style Frame:(CGRect)cellFrame Data:(NSArray*)data;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
-(void)layoutSubviews;


@end

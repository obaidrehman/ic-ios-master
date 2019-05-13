//
//  SubMenuTableCell.m
//  Infinity Chess iOS
//
//  Created by user on 3/23/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "SubMenuTableCell.h"

@implementation SubMenuTableCell
{
    NSArray *dataArray;
    UITableView *subMenuTableView;
}

- (id)initWithStyle:(UITableViewCellStyle)style Frame:(CGRect)cellFrame Data:(NSArray*)data
{
    self = [super initWithStyle:style reuseIdentifier:@"cell1"];
    if (self) {
        // Initialization code
        self.frame = cellFrame;//CGRectMake(0, 0, 300, 50);

        subMenuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]; //create tableview a
        
        //subMenuTableView.tag = 100;
        subMenuTableView.delegate = self;
        subMenuTableView.dataSource = self;
        [self addSubview:subMenuTableView]; // add it cell
        
        dataArray = data;
        
        subMenuTableView.frame = CGRectMake(cellFrame.origin.x + cellFrame.size.width * 5 / 100,
                                            cellFrame.origin.y + cellFrame.size.height * 5 / 100,
                                            cellFrame.size.width - cellFrame.size.width * 10 / 100,
                                            cellFrame.size.height - cellFrame.size.height * 10 / 100);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //UITableView *subMenuTableView =(UITableView *) [self viewWithTag:100];
    
//    subMenuTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5,    self.bounds.size.height-5);//set the frames for tableview
    
}

//manage datasource and  delegate for submenu tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

@end

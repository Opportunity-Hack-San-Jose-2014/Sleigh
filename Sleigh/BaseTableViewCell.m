//
//  BaseTableViewCell.m
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)setCellTitle:(NSString *)title andData:(NSString *)data
{
	self.titleString = title;
	self.dataString = data;
}

@end

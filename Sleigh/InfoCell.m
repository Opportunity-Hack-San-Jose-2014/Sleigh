//
//  InfoCell.m
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell ()

@property(weak, nonatomic) IBOutlet UILabel *cellTitle;
@property(weak, nonatomic) IBOutlet UILabel *cellData;

@end

@implementation InfoCell

- (void)setCellTitle:(NSString *)title andData:(NSString *)data
{
	[super setCellTitle:title andData:data];

	self.cellTitle.text = self.titleString;
	self.cellData.text = self.dataString;

}

@end

//
//  ImageCell.m
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageCell.h"

@interface ImageCell ()

@property(weak, nonatomic) IBOutlet UIImageView *itemImageView;

@end

@implementation ImageCell

- (void)setCellTitle:(NSString *)title andData:(NSString *)data
{
	[super setCellTitle:title andData:data];
	[self.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.dataString]];
}

@end

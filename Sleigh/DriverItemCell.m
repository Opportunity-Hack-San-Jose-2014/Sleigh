//
//  DriverItemCell.m
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DriverItemCell.h"
#import "UIImageView+WebCache.h"
#import "DonatedItem.h"

@implementation DriverItemCell

- (void)setCellWithItem:(DonatedItem *)item
{
	[self setImageWithImageURL:item.itemImageUrl];

	self.cellTitleLabel.text = item.itemAddress;
	self.cellDetailLabel.text = item.itemAvailabilitySchedule;
}

- (void)setImageWithImageURL:(NSString *)urlString
{
	[self.cellImageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
	{
		if (image && cacheType == SDImageCacheTypeNone)
		{
			self.cellImageView.alpha = 0.0;

			[UIView animateWithDuration:0.5
							 animations:^
							 {
								 self.cellImageView.alpha = 1.0;
							 }];
		}
	}];
}

@end

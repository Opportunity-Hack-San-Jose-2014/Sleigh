//
//  DonatedItemCell.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DonatedItemCell.h"
#import "DonatedItem.h"
#import "UIImageView+WebCache.h"

@interface DonatedItemCell ()

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DonatedItemCell

- (void)setCellWithItem:(DonatedItem *)item
{

}

- (void)setImageView:(UIImageView *)imageView withImageURL:(NSString *)urlString
{
	[imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
	{
		if (image)
		{
			imageView.alpha = 0.0;

			[UIView animateWithDuration:0.5
							 animations:^
							 {
								 imageView.alpha = 1.0;
							 }];
		}
	}];
}

@end

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
	[self setImageWithImageURL:item.itemImageUrl];
    self.dateLabel.text= [NSDateFormatter localizedStringFromDate:item.itemListingDate
														dateStyle:NSDateFormatterMediumStyle
														timeStyle:NSDateFormatterNoStyle];
}

- (void)setImageWithImageURL:(NSString *)urlString
{
	urlString = @"http://middleearthnews.com/wp-content/uploads/2014/04/The-Lego-Movie.jpg";
	[self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
	{
		if (image)
		{
			self.imageView.alpha = 0.0;

			[UIView animateWithDuration:0.5
							 animations:^
							 {
								 self.imageView.alpha = 1.0;
							 }];
		}
	}];
}

@end

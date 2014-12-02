//
//  DriverItemCell.h
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DonatedItem;

@interface DriverItemCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *cellDetailLabel;
@property(weak, nonatomic) IBOutlet UIImageView *cellImageView;

- (void)setCellWithItem:(DonatedItem *)item;
@end

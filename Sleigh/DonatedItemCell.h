//
//  DonatedItemCell.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DonatedItem;

@interface DonatedItemCell : UICollectionViewCell

- (void)setCellWithItem:(DonatedItem *)item;
@end

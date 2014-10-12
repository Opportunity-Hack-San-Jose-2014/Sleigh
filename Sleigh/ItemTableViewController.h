//
//  ItemScrollViewController.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonatedItem.h"

typedef enum : int
{
	ViewItemContextDonor = 0,
	ViewItemContextDriver
} ViewItemContext;

#define kViewItemIdentifier @"viewItem"

@interface ItemTableViewController : UIViewController

@property(nonatomic, strong) DonatedItem *donatedItem;
@property(nonatomic) int *itemContext;

@end

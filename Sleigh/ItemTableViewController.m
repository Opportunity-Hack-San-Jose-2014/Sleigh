//
//  ItemScrollViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "ItemTableViewController.h"
#import "UIView+Additions.h"
#import "ImageCell.h"
#import "InfoCell.h"

#define kCellClass @"cellClass"

#define kCellData @"cellData"

#define kCellTitle @"cellTitle"

@interface ItemTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *donorButtonView;
@property(weak, nonatomic) IBOutlet UIView *driverButtonsView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *itemDetailCellsToDisplay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomInset;
@end

@implementation ItemTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
	[self.navigationItem setLeftBarButtonItem:closeButton animated:YES];

	[self setupItemDetailCells];

    if (self.itemContext == ViewItemContextDonor)
    {
        self.driverButtonsView.hidden = YES;
		self.tableViewBottomInset.constant = self.donorButtonView.height;
    }
    else if (self.itemContext == ViewItemContextDriver)
    {
        self.donorButtonView.hidden = YES;
		self.tableViewBottomInset.constant = self.driverButtonsView.height;
    }
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)callPhone:(id)sender
{
	NSString *phoneDeepLink = [NSString stringWithFormat:@"tel:%@", self.donatedItem.itemPhoneNumber];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneDeepLink]];
}

#pragma mark - Table View Cells

- (void)setupItemDetailCells
{
	NSArray *displayableCellConfigs = [self displayableCellConfigs];
	NSMutableArray *cellsToDisplay = [NSMutableArray new];

	for (NSDictionary *cellConfig in displayableCellConfigs)
	{
		UITableViewCell *cell = [self setupCellForTableView:cellConfig];
		[cellsToDisplay addObject:cell];
	}

	self.itemDetailCellsToDisplay = [cellsToDisplay copy];
}

- (UITableViewCell *)setupCellForTableView:(NSDictionary *)cellConfig
{
	NSString *className = NSStringFromClass([cellConfig objectForKey:kCellClass]);
	UINib *nib = [UINib nibWithNibName:className bundle:self.nibBundle];
	[self.tableView registerNib:nib forCellReuseIdentifier:className];

	BaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:className];
	cell.width = self.tableView.width - self.tableView.contentInset.left - self.tableView.contentInset.right;
	[cell setNeedsLayout];

	[cell setCellTitle:[cellConfig objectForKey:kCellTitle] andData:[cellConfig objectForKey:kCellData]];

	return cell;
}

- (NSArray *)displayableCellConfigs
{
	NSDictionary *image = @{
			kCellClass : [ImageCell class],
			kCellData  : self.donatedItem.itemImageUrl
	};
	NSDictionary *code = @{
			kCellClass : [InfoCell class],
			kCellTitle : @"Item Code/Description",
			kCellData  : self.donatedItem.itemCode
	};
	NSDictionary *address = @{
			kCellClass : [InfoCell class],
			kCellTitle : @"Pickup Address",
			kCellData  : self.donatedItem.itemAddress
	};
	NSDictionary *availability = @{
			kCellClass : [InfoCell class],
			kCellTitle : @"Pickup Availability",
			kCellData  : self.donatedItem.itemAvailabilitySchedule
	};
	NSDictionary *status = @{
			kCellClass : [InfoCell class],
			kCellTitle : @"Item Status",
			kCellData  : [self.donatedItem currentStatusString]
	};
	return @[image, code, address, availability, status];
}

#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.itemDetailCellsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.itemDetailCellsToDisplay objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.itemDetailCellsToDisplay objectAtIndex:indexPath.row];
	return cell.height;

}


@end

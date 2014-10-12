//
//  DriverDashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DriverDashboardViewController.h"
#import "UserDataManager.h"
#import "ItemTableViewController.h"
#import "UIView+Additions.h"

@interface DriverDashboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DriverDashboardViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kViewItemIdentifier])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		DonatedItem *donatedItem = [[[UserDataManager sharedInstance] allDonorItems] objectAtIndex:indexPath.item];

		ItemTableViewController *viewController = [[(UINavigationController *) segue.destinationViewController childViewControllers] firstObject];
		viewController.donatedItem = donatedItem;
		viewController.itemContext = ViewItemContextDriver;
	}
}

#pragma mark - TableView

- (void)reloadData
{
	[UIView transitionWithView:self.tableView
					  duration:0.4
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^(void)
					{
						[self.tableView reloadData];
					} completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[[UserDataManager sharedInstance] allDriverItems] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[[UserDataManager sharedInstance] allDriverItems] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"DriverItemCell";

	DonatedItem *donatedItem = [[[[UserDataManager sharedInstance] allDriverItems] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell.width = self.tableView.width - self.tableView.contentInset.left - self.tableView.contentInset.right;

	[cell.imageView sd_setImageWithURL:[NSURL URLWithString:donatedItem.itemImageUrl]];

	cell.textLabel.text = donatedItem.itemAddress;
	cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
	cell.textLabel.numberOfLines = 2;

	cell.detailTextLabel.text = donatedItem.itemAvailabilitySchedule;
	cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
	cell.detailTextLabel.textColor = [UIColor darkGrayColor];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kViewItemIdentifier sender:self];
}

@end

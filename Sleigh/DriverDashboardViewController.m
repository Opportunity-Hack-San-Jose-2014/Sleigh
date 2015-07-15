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
#import "DriverItemCell.h"

@interface DriverDashboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation DriverDashboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self setupTableView];

	[self setupRefreshControl];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadData];
}

- (void)setupTableView
{
	NSString *className = NSStringFromClass([DriverItemCell class]);
	UINib *nib = [UINib nibWithNibName:className bundle:self.nibBundle];
	[self.tableView registerNib:nib forCellReuseIdentifier:className];
	[self.tableView setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setTintColor:[UIColor colorWithRed:0.055 green:0 blue:0.549 alpha:1]]; /*#0e008c*/}

- (void)setupRefreshControl
{
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:[UserDataManager sharedInstance]
							action:@selector(refreshCachedItems)
				  forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:self.refreshControl];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kItemsDownloadedFromServerNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kViewItemIdentifier])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		DonatedItem *donatedItem = [[[[UserDataManager sharedInstance] allDriverItems] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

		ItemTableViewController *viewController = [[(UINavigationController *) segue.destinationViewController childViewControllers] firstObject];
		viewController.donatedItem = donatedItem;
		viewController.itemContext = (int *) ViewItemContextDriver;
	}
}

#pragma mark - TableView

- (void)reloadData
{
	[self.refreshControl endRefreshing];

	[UIView transitionWithView:self.view
					  duration:0.4
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^(void)
					{
						[self updateOverlayVisibility];
						[self.tableView reloadData];
					} completion:nil];
}

- (void)updateOverlayVisibility
{
	NSArray *driverItems = [[UserDataManager sharedInstance] allDriverItems];
	NSUInteger count = [[driverItems objectAtIndex:0] count];
	count += [[driverItems objectAtIndex:1] count];
	self.overlayView.alpha = (count == 0);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	// Background color
	view.tintColor = [UIColor colorWithRed:140 / 255.0f green:49 / 255.0f blue:109 / 255.0f alpha:1.0f];
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
	[header.textLabel setTextColor:[UIColor whiteColor]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return (section == 0) ? @"Current Items" : @"Delivered Items";
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

	DriverItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.width = self.tableView.width - self.tableView.contentInset.left - self.tableView.contentInset.right;

	DonatedItem *donatedItem = [[[[UserDataManager sharedInstance] allDriverItems] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	[cell setCellWithItem:donatedItem];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kViewItemIdentifier sender:self];
}

@end

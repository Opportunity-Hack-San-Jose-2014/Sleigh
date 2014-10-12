//
//  DonorDashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DonorDashboardViewController.h"
#import "UserDataManager.h"
#import "DonatedItem.h"
#import "DonatedItemCell.h"
#import "ItemTableViewController.h"

#define kAnimationDuration 0.4

#define kViewItemIdentifier @"viewItem"

@interface DonorDashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DonorDashboardViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kViewItemIdentifier])
	{
		NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
		DonatedItem *donatedItem = [[[UserDataManager sharedInstance] allUserItems] objectAtIndex:indexPath.item];

		ItemTableViewController *viewController = [[(UINavigationController *) segue.destinationViewController childViewControllers] firstObject];
		viewController.donatedItem = donatedItem;
	}
}

- (void)reloadData
{
	[UIView transitionWithView:self.collectionView
					  duration:kAnimationDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^(void)
					{
						[self.collectionView reloadData];
					} completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[[UserDataManager sharedInstance] allUserItems] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DonatedItem *donatedItem = [[[UserDataManager sharedInstance] allUserItems] objectAtIndex:indexPath.item];

	DonatedItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DonatedItemCell class]) forIndexPath:indexPath];
	[cell setCellWithItem:donatedItem];

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kViewItemIdentifier sender:self];
}

@end

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

@interface DonorDashboardViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(weak, nonatomic) IBOutlet UIView *overlayView;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation DonorDashboardViewController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kItemsDownloadedFromServerNotification object:nil];



}

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
		DonatedItem *donatedItem = [[[UserDataManager sharedInstance] allDonorItems] objectAtIndex:indexPath.item];

		ItemTableViewController *viewController = [[(UINavigationController *) segue.destinationViewController childViewControllers] firstObject];
		viewController.donatedItem = donatedItem;
		viewController.itemContext = (int *) ViewItemContextDonor;
	}
}

- (void)reloadData
{
	[UIView transitionWithView:self.view
					  duration:0.4
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^(void)
					{
						[self.collectionView reloadData];
						self.overlayView.alpha = ([[[UserDataManager sharedInstance] allDonorItems] count] == 0);
					} completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[[UserDataManager sharedInstance] allDonorItems] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DonatedItem *donatedItem = [[[UserDataManager sharedInstance] allDonorItems] objectAtIndex:indexPath.item];

	DonatedItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DonatedItemCell class]) forIndexPath:indexPath];
	[cell setCellWithItem:donatedItem];

	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kViewItemIdentifier sender:self];
}

@end

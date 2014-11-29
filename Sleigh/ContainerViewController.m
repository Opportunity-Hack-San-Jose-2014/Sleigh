//
//  ContainerViewController.m
//  EmbeddedSwapping
//
//  Created by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.
//  Heavily inspired by http://orderoo.wordpress.com/2012/02/23/container-view-controllers-in-the-storyboard/
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@property(strong, nonatomic) NSMutableDictionary *segueViewControllers;
@property(assign, nonatomic) BOOL transitionInProgress;

@property(strong, nonatomic) NSString *currentSegueIdentifier;
@end

@implementation ContainerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.transitionInProgress = NO;
	self.segueViewControllers = [NSMutableDictionary new];
	self.currentSegueIdentifier = [self segueIdentifierForIndex:0];

	[self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	// Instead of creating new VCs on each segue we want to hang on to existing instances if we have it.
	if ([self.segueViewControllers objectForKey:segue.identifier] == nil)
		[self.segueViewControllers setValue:segue.destinationViewController forKey:segue.identifier];

	// If we're going to the first view controller & this is the very first time we're loading
	if ([segue.identifier isEqualToString:self.currentSegueIdentifier] && [self.childViewControllers count] == 0)
	{
		[self addChildViewController:segue.destinationViewController];

		UIView *destinationView = ((UIViewController *) segue.destinationViewController).view;
		destinationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		destinationView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

		[self.view addSubview:destinationView];
		[segue.destinationViewController didMoveToParentViewController:self];
	}
	else
	{
		UIViewController *currentViewController = [self.segueViewControllers objectForKey:self.currentSegueIdentifier];
		[self swapFromViewController:currentViewController toViewController:segue.destinationViewController];
	}
}

#pragma mark - Public Methods

- (void)cycleToNextViewController
{
	NSString *nextIndex = [[self.currentSegueIdentifier componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
														componentsJoinedByString:@""];

	[self swapToViewControllerAtIndex:[nextIndex intValue]];
}

- (void)swapToViewControllerAtIndex:(NSInteger)index
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (self.transitionInProgress == NO)
	{
		self.transitionInProgress = YES;

		NSString *identifierForIndex = [self segueIdentifierForIndex:index];
		UIViewController *destinationViewController = [self.segueViewControllers objectForKey:identifierForIndex];

		if (destinationViewController != nil)
		{
			UIViewController *currentViewController = [self.segueViewControllers objectForKey:self.currentSegueIdentifier];
			[self swapFromViewController:currentViewController toViewController:destinationViewController];
		}
		else
			[self performSegueWithIdentifier:identifierForIndex sender:nil];

		self.currentSegueIdentifier = identifierForIndex;
	}
}

#pragma mark - Helpers

- (NSString *)segueIdentifierForIndex:(NSInteger)index
{
	return [NSString stringWithFormat:@"SegueIdentifierIndex%li", (long)index];
}

- (void)swapFromViewController:(UIViewController *)currentViewController toViewController:(UIViewController *)destinationViewController
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	destinationViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

	[currentViewController willMoveToParentViewController:nil];
	[self addChildViewController:destinationViewController];

	[self transitionFromViewController:currentViewController
					  toViewController:destinationViewController
							  duration:0.35
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:nil
							completion:^(BOOL finished)
							{
								[currentViewController removeFromParentViewController];
								[destinationViewController didMoveToParentViewController:self];

								self.transitionInProgress = NO;
							}];
}

@end

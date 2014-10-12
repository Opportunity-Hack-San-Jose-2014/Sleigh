//
//  DashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DashboardViewController.h"
#import "ContainerViewController.h"

@interface DashboardViewController ()

@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, strong) ContainerViewController *containerViewController;
@end

@implementation DashboardViewController

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
	[self.containerViewController swapViewControllers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"embedContainer"])
	{
		self.containerViewController = segue.destinationViewController;
	}
}

@end

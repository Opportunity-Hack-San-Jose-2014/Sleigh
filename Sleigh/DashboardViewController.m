//
//  DashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DashboardViewController.h"
#import "ContainerViewController.h"
#import "UserDataManager.h"

@interface DashboardViewController ()

@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic, strong) ContainerViewController *containerViewController;
@end

@implementation DashboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(logoutUser:)];
	self.navigationItem.leftBarButtonItem = backButton;

}

- (void)logoutUser:(id)sender
{
	[[UserDataManager sharedInstance] logoutUser];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

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

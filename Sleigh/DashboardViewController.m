//
//  DashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@property(weak, nonatomic) IBOutlet UIButton *driverButton;
@property(weak, nonatomic) IBOutlet UIButton *donorButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeight;

@end

@implementation DashboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

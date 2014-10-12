//
//  AppDelegate.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "AppDelegate.h"
#import "RGB.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	[[UILabel appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18.0]];
	[[UITextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]];

	[[UISegmentedControl appearance] setTitleTextAttributes:@{
			 NSForegroundColorAttributeName : [UIColor whiteColor],
			 NSFontAttributeName            : [UIFont fontWithName:@"AvenirNext-Bold" size:16.0]
	 }
												   forState:UIControlStateSelected];
	[[UISegmentedControl appearance] setTitleTextAttributes:@{
			 NSForegroundColorAttributeName : RGB(0, 122, 255),
			 NSFontAttributeName            : [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
	 }
												   forState:UIControlStateNormal];

//	[self.window setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];

    [Parse setApplicationId:@"LdJQPv5TdX8f7W93mAO8FkpcEqe55ciGomTOH4es"
                  clientKey:@"jQtxcBGGCwiYzZLFiB7tTLBt5uEE4jRPZPNfTRz4"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];


	return YES;
}

@end

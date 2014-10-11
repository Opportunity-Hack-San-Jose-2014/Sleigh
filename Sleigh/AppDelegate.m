//
//  AppDelegate.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UILabel appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18.0]];
	[[UITextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]];

	[self.window setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];

	return YES;
}

@end

//
//  UIDevice+Additions.m
//
//  Created by Bittu Ahlawat on 6/8/12.
//  Copyright (c) 2012 eBay. All rights reserved.
//

#import "UIDevice+Additions.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

BOOL isDeviceSimulator(void)
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
	return NO;
#endif
}

BOOL isDevicePad(void)
{
	BOOL result = NO;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
		result = YES;
	return result;
}

BOOL isDevicePhone(void)
{
	BOOL result = NO;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		result = YES;
	return result;
}

BOOL isDeviceLandscape(void)
{
	return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

BOOL isDevicePortrait(void)
{
	return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

BOOL isDeviceEqualOrAboveIOS7(void)
{
	BOOL result = NO;

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
		result = YES;

	return result;
}

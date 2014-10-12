//
//  DonatedItem.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DonatedItem.h"

@implementation DonatedItem

- (instancetype)initDonatedItemWithDescription:(NSString *)descriptionCode address:(NSString *)address schedule:(NSString *)schedule phoneNumber:(NSString *)phoneNumber
{
	self = [self init];
	if (self)
	{
		self.itemCode = descriptionCode;
		self.itemAddress = address;
		self.itemAvailabilitySchedule = schedule;
		self.itemPhoneNumber = phoneNumber;

		self.itemImageUrl = @"http://middleearthnews.com/wp-content/uploads/2014/04/The-Lego-Movie.jpg";

		self.itemListingDate = [NSDate date];
		self.itemStatusCode = ItemStatusPickupReady;
	}
	return self;
}

- (void)updateItemStatusWithIndex:(int)index
{
	self.itemStatusCode = index;
}

- (NSString *)currentStatusString
{
	return [[DonatedItem statusStrings] objectAtIndex:self.itemStatusCode];
}

+ (NSArray *)statusStrings
{
	static NSArray *_statusStrings;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
	{
		_statusStrings = @[
				@"Ready for Pickup",
				@"Driver en Route",
				@"Item picked up",
				@"Item at Warehouse",
				@"Delivered"
		];
	});
	return _statusStrings;
}

@end

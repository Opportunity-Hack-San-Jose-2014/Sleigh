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

		self.itemListingDate = [NSDate date];
		self.itemStatusCode = ItemStatusPickupReady;
	}
	return self;
}

- (NSString *)currentStatusString
{
	switch (self.itemStatusCode)
	{
		case ItemStatusPickupReady:
			return @"Ready for Pickup";
		case ItemStatusDriverEnRoute:
			return @"Driver en Route";
		case ItemStatusPickedUp:
			return @"Item picked up";
		case ItemStatusWarehouse:
			return @"Item at Warehouse";
		case ItemStatusDelivered:
			return @"Ready for Pickup";
		default:
			return @"";
	}
}

@end

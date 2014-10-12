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

		self.itemStatusCode = ItemStatusPickupReady;
	}
	return self;
}

@end

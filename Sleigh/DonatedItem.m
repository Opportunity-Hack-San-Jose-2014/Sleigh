//
//  DonatedItem.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <Parse/PFObject+Subclass.h>
#import <CoreLocation/CoreLocation.h>
#import "DonatedItem.h"

@implementation DonatedItem

@dynamic itemCode;
@dynamic itemAddress;
@dynamic itemGeopoint;
@dynamic itemPhoneNumber;
@dynamic itemImage;
@dynamic itemAvailabilitySchedule;
@dynamic itemListingDate;
@dynamic itemStatusCode;
@dynamic itemDriverId;
@dynamic itemDonorId;

+ (void)load
{
	[self registerSubclass];
}

+ (NSString *)parseClassName
{
	return NSStringFromClass([self class]);
}

- (instancetype)initDonatedItemWithDescription:(NSString *)descriptionCode address:(CLPlacemark *)placemark schedule:(NSString *)schedule phoneNumber:(NSString *)phoneNumber itemImage:(PFFile *)image
{
	self = [self init];
	if (self)
	{
		self.itemCode = descriptionCode;
		self.itemAvailabilitySchedule = schedule;
		self.itemPhoneNumber = phoneNumber;

		[self setItemLocation:placemark];

		self.itemImage = image;

		self.itemListingDate = [NSDate date];
		self.itemStatusCode = ItemStatusPickupReady;

		// Set ACL permissions for added security
		PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
		[postACL setPublicReadAccess:YES];
		[self setACL:postACL];

		self.itemDonorId = [PFUser currentUser];
	}
	return self;
}

- (void)setItemLocation:(CLPlacemark *)placemark
{
	self.itemAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:placemark.location.coordinate.latitude
											   longitude:placemark.location.coordinate.longitude];
	self.itemGeopoint = point;
}

- (void)updateItemStatusWithIndex:(int)index
{
	self.itemStatusCode = index;
	if (self.itemStatusCode == 0)
	{
		self.itemDriverId = Nil;
	}
	else
	{
		self.itemDriverId = [PFUser currentUser];
	}
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

//
//  DonatedItem.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
	ItemStatusPickupReady = 0,
	ItemStatusDriverEnRoute,
	ItemStatusPickedUp,
	ItemStatusWarehouse,
	ItemStatusDelivered
} ItemStatus;

@interface DonatedItem : NSObject

@property(nonatomic, strong) NSString *itemCode;
@property(nonatomic, strong) NSString *itemAddress;
@property(nonatomic, strong) NSString *itemPhoneNumber;
@property(nonatomic, strong) NSString *itemImageUrl;
@property(nonatomic, strong) NSString *itemAvailabilitySchedule;
@property (nonatomic, strong) NSDate *itemListingDate;

@property(nonatomic) ItemStatus itemStatusCode;

@property(nonatomic, strong) NSNumber *donorId;
@property(nonatomic, strong) NSNumber *driverId;

- (instancetype)initDonatedItemWithDescription:(NSString *)descriptionCode address:(NSString *)address schedule:(NSString *)schedule phoneNumber:(NSString *)phoneNumber;
@end

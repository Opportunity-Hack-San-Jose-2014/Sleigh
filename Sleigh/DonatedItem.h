//
//  DonatedItem.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef enum : NSUInteger
{
	ItemStatusPickupReady = 0,
	ItemStatusDriverEnRoute,
	ItemStatusPickedUp,
	ItemStatusWarehouse,
	ItemStatusDelivered
} ItemStatus;

@interface DonatedItem : PFObject <PFSubclassing>

@property(retain) NSString *itemCode;
@property(retain) NSString *itemAddress;
@property(retain) NSString *itemPhoneNumber;
@property(retain) NSString *itemAvailabilitySchedule;
@property(retain) NSDate *itemListingDate;
@property(retain) PFFile *itemImage;

@property int itemStatusCode;

@property(retain) PFUser *itemDriverId;
@property(retain) PFUser *itemDonorId;

+ (NSString *)parseClassName;

- (instancetype)initDonatedItemWithDescription:(NSString *)descriptionCode address:(NSString *)address schedule:(NSString *)schedule phoneNumber:(NSString *)phoneNumber itemImage:(PFFile *)image;

+ (NSArray *)statusStrings;

- (void)updateItemStatusWithIndex:(int)index;

- (NSString *)currentStatusString;
@end

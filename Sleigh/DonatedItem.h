//
//  DonatedItem.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DonatedItem : NSObject

@property(nonatomic, strong) NSString *itemCode;
@property(nonatomic, strong) NSString *itemImageUrl;
@property(nonatomic, strong) NSString *itemAvailabilitySchedule;
@property(nonatomic, strong) NSNumber *itemStatusCode;

@property(nonatomic, strong) NSNumber *donorId;
@property(nonatomic, strong) NSNumber *driverId;

@end

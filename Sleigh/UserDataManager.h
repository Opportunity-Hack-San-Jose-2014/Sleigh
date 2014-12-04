//
//  UserDataManager.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kItemsDownloadedFromServerNotification @"itemsDownloadedFromServerNotification"
#define kAccountNotActivatedErrorText @"Account is not Activated"

@class DonatedItem;

@interface UserDataManager : NSObject

+ (UserDataManager *)sharedInstance;

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(NSError *))completionBlock;

- (void)logoutUser;

- (BOOL)isUserDriver;

- (void)deleteItem:(DonatedItem *)item;

- (void)saveDonatedItemToDatabase:(DonatedItem *)item withCompletionBlock:(void (^)(NSError *))completionBlock;

- (void)updateDonatedItem:(DonatedItem *)item statusCode:(int)status withCompletionBlock:(void (^)(NSError *))completionBlock;

- (NSArray *)allDriverItems;

- (NSArray *)allDonorItems;

- (NSArray *)allItemsAvailableForPickup;
@end

//
//  UserDataManager.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAccountNotActivatedError @"Account is not Activated"

@class DonatedItem;

@interface UserDataManager : NSObject

+ (UserDataManager *)sharedInstance;

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(NSError *))completionBlock;

- (void)logoutUser;

- (void)saveDonatedItemToDatabase:(DonatedItem *)item withCompletionBlock:(void (^)(NSError *))completionBlock;

- (void)updateDonatedItem:(DonatedItem *)item statusCode:(int)status withCompletionBlock:(void (^)(NSError *))completionBlock;

//- (void)allDonorItemsWithCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock;
//
//- (void)allDriverItemsWithCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock;

- (NSArray *)allDriverItems;

- (NSArray *)allDonorItems;

- (void)deleteItem:(DonatedItem *)item;
@end

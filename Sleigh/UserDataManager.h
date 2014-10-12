//
//  UserDataManager.h
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DonatedItem;

@interface UserDataManager : NSObject

+ (UserDataManager *)sharedInstance;

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)logoutUser;

- (void)queryServerForAllUserItemsWithCompletionBlock:(void (^)(NSArray *items))completionBlock;

- (void)saveDonatedItemToDatabase:(DonatedItem *)item withCompletionBlock:(void (^)(BOOL success))completionBlock;
@end

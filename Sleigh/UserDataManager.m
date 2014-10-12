//
//  UserDataManager.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "UserDataManager.h"
#import "DonatedItem.h"

@interface UserDataManager ()

@property(nonatomic, copy) NSString *username;
@property(nonatomic, strong) NSMutableArray *userItems;
@end

@implementation UserDataManager

+ (instancetype)sharedInstance
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^
	{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

#pragma mark - User Management

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(BOOL success))completionBlock
{
	self.userItems = [NSMutableArray new];

	self.username = username;
	//log user in
	BOOL isSuccessful = YES;
	completionBlock(isSuccessful);
}

- (void)logoutUser
{
	self.username = nil;
}

#pragma mark - Server Queries

- (void)queryServerForAllUserItemsWithCompletionBlock:(void (^)(NSArray *items))completionBlock
{
	//grab all items for user id
	completionBlock(self.userItems);
}

- (void)saveDonatedItemToDatabase:(DonatedItem *)item withCompletionBlock:(void (^)(BOOL success))completionBlock
{
	//save async to server
	BOOL isSuccessful = YES;

	if (isSuccessful)
	{
		for (int i = 0; i < 8; i++)
		{
			[self.userItems addObject:item];
		}
	}

	completionBlock(isSuccessful);
}

#pragma mark - Item Management

- (NSArray *)allUserItems
{
	return self.userItems;
}

@end

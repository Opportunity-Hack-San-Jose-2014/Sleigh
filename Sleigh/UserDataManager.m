//
//  UserDataManager.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <Parse/Parse.h>
#import "UserDataManager.h"
#import "DonatedItem.h"

#define kItemsInProgress @"ItemsInProgress"

#define kItemsAvailable @"ItemsAvailable"

@interface UserDataManager ()

@property(nonatomic, strong) NSMutableArray *userItems;
@property(nonatomic) BOOL isDemo;
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

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.isDemo = YES;
	}
	return self;
}

#pragma mark - User Management

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(NSError *error))completionBlock
{
	[PFUser logInWithUsernameInBackground:username password:password
									block:^(PFUser *user, NSError *error)
									{
										if (user)
										{
											self.userItems = [NSMutableArray new];
										}
										completionBlock(error);
									}];
}

- (void)logoutUser
{
	[PFUser logOut];
}

- (void)addMultipleDemoItemCopies:(DonatedItem *)item
{
	for (int i = 0; i < 8; ++i)
	{
		DonatedItem *newDonation = [[DonatedItem alloc] initDonatedItemWithDescription:item.itemCode
																			   address:item.itemAddress
																			  schedule:item.itemAvailabilitySchedule
																		   phoneNumber:item.itemPhoneNumber];
		[self.userItems addObject:newDonation];
	}
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
		if (self.isDemo)
			[self addMultipleDemoItemCopies:item];
		else
			[self.userItems addObject:item];
	}

	completionBlock(isSuccessful);
}

- (void)updateDonatedItem:(DonatedItem *)item statusCode:(int)status withCompletionBlock:(void (^)(BOOL success))completionBlock
{
	//save async to server
	BOOL isSuccessful = YES;

	if (isSuccessful)
		[item updateItemStatusWithIndex:status];
	completionBlock(isSuccessful);
}

#pragma mark - Item Management

- (NSArray *)allDonorItems
{
	return self.userItems;
}

- (NSArray *)allDriverItems
{
	return @[
			[NSArray new],
			self.userItems
	];
}

@end

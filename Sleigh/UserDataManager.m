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
	[PFUser logInWithUsernameInBackground:username
								 password:password
									block:^(PFUser *user, NSError *error)
									{
										if (user && [user objectForKey:@"isActivated"])
										{
											self.userItems = [NSMutableArray new];
											[self queryServerForAllUserItemsWithCompletionBlock:^(NSArray *objects, NSError *error)
											{
												self.userItems = [objects mutableCopy];
												[[NSNotificationCenter defaultCenter] postNotificationName:kItemsDownloadedFromServerNotification object:self];
											}];
											completionBlock(nil);
										}
										else
										{
											if (error == nil)
												error = [NSError errorWithDomain:@"ParseActivation" code:1 userInfo:@{NSLocalizedDescriptionKey : kAccountNotActivatedErrorText}];
											completionBlock(error);
										}
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

- (void)queryServerForAllUserItemsWithCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock
{
	PFQuery *query = [DonatedItem query];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		completionBlock(objects, error);
	}];
}

- (void)saveDonatedItemToDatabase:(DonatedItem *)item withCompletionBlock:(void (^)(NSError *error))completionBlock
{
	[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (succeeded)
			[self.userItems addObject:item];
		completionBlock(error);
	}];
}

- (void)updateDonatedItem:(DonatedItem *)item statusCode:(int)status withCompletionBlock:(void (^)(NSError *error))completionBlock
{
	[item updateItemStatusWithIndex:status];
	[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		completionBlock(error);
	}];
}

- (void)deleteItem:(DonatedItem *)item
{
	[item deleteInBackground];
}

#pragma mark - Item Management

//- (void)allDonorItemsWithCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock
//{
//	PFQuery *query = [DonatedItem query];
//	[query whereKey:@"itemDonorId" equalTo:[PFUser currentUser]];
//
//	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//	{
//		completionBlock(objects, error);
//	}];
//}
//
//- (void)allDriverItemsWithCompletionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock
//{
//	PFQuery *query = [DonatedItem query];
//
//	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//	{
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemDriverId == %@", [PFUser currentUser]];
//		NSArray *pickupItems = [objects filteredArrayUsingPredicate:predicate];
//
//		NSMutableArray *availableItems = [objects mutableCopy];
//		[availableItems removeObjectsInArray:pickupItems];
//
//		completionBlock(@[pickupItems, availableItems], error);
//	}];
//}

- (NSArray *)allDriverItems
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemDriverId.objectId == %@", [PFUser currentUser].objectId];
	NSArray *pickupItems = [self.userItems filteredArrayUsingPredicate:predicate];

	NSMutableArray *availableItems = [self.userItems mutableCopy];
	[availableItems removeObjectsInArray:pickupItems];

	return @[pickupItems, availableItems];
}

- (NSArray *)allDonorItems
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemDonorId.objectId == %@", [PFUser currentUser].objectId];
	NSArray *donorItems = [self.userItems filteredArrayUsingPredicate:predicate];

	return donorItems;
}

@end

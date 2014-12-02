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

- (void)loginUserWithName:(NSString *)username andPassword:(NSString *)password withCompletionBlock:(void (^)(NSError *error))completionBlock
{
	[PFUser logInWithUsernameInBackground:username
								 password:password
									block:^(PFUser *user, NSError *error)
									{
										if (user && [[user objectForKey:@"isActivated"] boolValue])
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

- (BOOL)isUserDriver
{
	return [[[PFUser currentUser] objectForKey:@"isDriver"] boolValue];
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
	[self.userItems removeObject:item];
	[[NSNotificationCenter defaultCenter] postNotificationName:kItemsDownloadedFromServerNotification object:self];
}

#pragma mark - Item Management

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

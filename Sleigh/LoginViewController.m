//
//  LoginViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "LoginViewController.h"
#import "UserDataManager.h"
#import "UIDevice+Additions.h"

@interface LoginViewController ()

@property(weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self demoDataIfSimulator];
}

- (IBAction)loginButtonTapped:(id)sender
{
	NSString *username = self.usernameTextField.text;
	NSString *password = self.passwordTextField.text;

	if (username.length > 0 && password.length > 0)
		[self loginUser:username withPassword:password];
	else
	{
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
															  message:@"Please enter your user credentials."
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];

		[myAlertView show];
	}
}

- (void)loginUser:(NSString *)username withPassword:(NSString *)password
{
	[[UserDataManager sharedInstance] loginUserWithName:username
											andPassword:password
									withCompletionBlock:^(NSError *error)
									{
										if (!error)
											[self performSegueWithIdentifier:@"loginSuccessful" sender:self];
										else
										{
											NSString *errorMessage;
											if ([[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:kAccountNotActivatedErrorText])
												errorMessage = kAccountNotActivatedErrorText;
											else
												errorMessage = @"User credentials incorrect, please try again.";

											UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
																								  message:errorMessage
																								 delegate:nil
																						cancelButtonTitle:@"OK"
																						otherButtonTitles:nil];
											[myAlertView show];
										}
									}];
}

- (void)demoDataIfSimulator
{
	if (isDeviceSimulator())
		[self performSelector:@selector(demoData) withObject:nil afterDelay:1];
}

- (void)demoData
{
	self.usernameTextField.text = @"driver_account";
	self.passwordTextField.text = @"admin";
}

@end

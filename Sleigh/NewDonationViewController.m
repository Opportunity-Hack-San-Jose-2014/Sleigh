//
//  NewDonationViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "NewDonationViewController.h"
#import "UserDataManager.h"
#import "DonatedItem.h"

@interface NewDonationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *itemCodeTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAddressTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAvailabilityTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemPhoneNumberTextField;

@end

@implementation NewDonationViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
	[self.view addGestureRecognizer:tapGestureRecognizer];

	[self performSelector:@selector(demoData) withObject:nil afterDelay:1];
}

- (void)demoData
{
	[self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://middleearthnews.com/wp-content/uploads/2014/04/The-Lego-Movie.jpg"]];
	self.itemCodeTextField.text = @"123456";
	self.itemAddressTextField.text = @"123 Address Avenue San Jose, CA 95125";
	self.itemAvailabilityTextField.text = @"M-F 5-6pm";
	self.itemPhoneNumberTextField.text = @"408 693 1234";
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)submitButtonTapped:(id)sender
{
	NSString *schedule = self.itemAvailabilityTextField.text;
	NSString *address = self.itemAddressTextField.text;
	NSString *code = self.itemCodeTextField.text;
	NSString *phoneNumber = self.itemPhoneNumberTextField.text;
	if (schedule.length > 0 && address.length > 0 && code.length > 0 && phoneNumber.length > 0)
	{
		DonatedItem *newDonation = [[DonatedItem alloc] initDonatedItemWithDescription:code
																			   address:address
																			  schedule:schedule
																		   phoneNumber:phoneNumber];

		[[UserDataManager sharedInstance] saveDonatedItemToDatabase:newDonation withCompletionBlock:^(BOOL success)
		{
			if (success)
				[self.navigationController popViewControllerAnimated:YES];
			else
			{
				UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
																	  message:@"Unable to save item, please try again."
																	 delegate:nil
															cancelButtonTitle:@"OK"
															otherButtonTitles:nil];

				[myAlertView show];
			}
		}];
	}
	else
	{
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
															  message:@"Please answer all text fields."
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];

		[myAlertView show];
	}
}

#pragma mark - Keyboard methods

- (void)resignAllResponders
{
	[self.itemAddressTextField resignFirstResponder];
	[self.itemCodeTextField resignFirstResponder];
	[self.itemAvailabilityTextField resignFirstResponder];
	[self.itemPhoneNumberTextField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	NSDictionary *keyboardInfo = [notification userInfo];
	NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

	self.view.frame = CGRectMake(0, -keyboardFrameBeginRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - Image Picker Controller delegate methods

- (void)showCameraController
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;

	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//	self.imageView.image = chosenImage;

	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

@end

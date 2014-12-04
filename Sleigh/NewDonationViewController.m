//
//  NewDonationViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "NewDonationViewController.h"
#import "UserDataManager.h"
#import "DonatedItem.h"
#import "MBProgressHUD.h"
#import "UIView+Additions.h"

@interface NewDonationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *itemCodeTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAddressTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAvailabilityTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemPhoneNumberTextField;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NewDonationViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

	UITapGestureRecognizer *cancelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
	[self.view addGestureRecognizer:cancelTapGesture];

	UITapGestureRecognizer *cameraTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCameraController)];
	[self.imageView addGestureRecognizer:cameraTapGesture];

	//[self performSelector:@selector(demoData) withObject:nil afterDelay:1];
}

- (void)demoData
{
//	[self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://ecx.images-amazon.com/images/I/41MCTMPZVML.jpg"]];
	self.itemCodeTextField.text = @"123456";
	self.itemAddressTextField.text = @"1234 Hicks Avenue San Jose, CA 95125";
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
		MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		progressHUD.labelText = @"Validating Address";

		CLGeocoder *geocoder = [CLGeocoder new];
		[geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
		{
			[MBProgressHUD hideHUDForView:self.view animated:YES];

			self.currentAddressPlacemarks = placemarks;
			
			if (error == nil)
			{
				NSMutableArray *addresses = [NSMutableArray new];
				for (CLPlacemark *placemark in placemarks)
					[addresses addObject:ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];

				self.currentAddressStrings = [NSArray arrayWithArray:addresses];
				if ([placemarks count] > 1)
				{
					UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please confirm your address"
																			 delegate:self
																	cancelButtonTitle:@"Cancel"
															   destructiveButtonTitle:nil
																	otherButtonTitles:[addresses componentsJoinedByString:@","], nil];
					[actionSheet showInView:self.view];
				}
				else
					[self saveNewItemWithId:code address:[placemarks objectAtIndex:0] schedule:schedule phoneNumber:phoneNumber itemImage:self.imageView.image];
			}
			else
				[self displayErrorAlertWithMessage:@"The address you entered is not valid."];

		}];

	}
	else
		[self displayErrorAlertWithMessage:@"Please answer all text fields."];
}

- (void)saveNewItemWithId:(NSString *)code address:(CLPlacemark *)placemark schedule:(NSString *)schedule phoneNumber:(NSString *)phoneNumber itemImage:(UIImage *)image
{
	MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	progressHUD.labelText = @"Saving Item";

	NSData *imageData = UIImageJPEGRepresentation(image, 0.6f);
	PFFile *imageFile = [PFFile fileWithName:@"itemImage.jpg" data:imageData];

	DonatedItem *newDonation = [[DonatedItem alloc] initDonatedItemWithDescription:code address:placemark schedule:schedule phoneNumber:phoneNumber itemImage:imageFile];

	[[UserDataManager sharedInstance] saveDonatedItemToDatabase:newDonation withCompletionBlock:^(NSError *error)
	{
		[MBProgressHUD hideHUDForView:self.view animated:YES];

		if (error == nil)
			[self.navigationController popViewControllerAnimated:YES];
		else
			[self displayErrorAlertWithMessage:@"Unable to save item, please try again."];
	}];
}

- (void)displayErrorAlertWithMessage:(NSString *)message
{
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
														  message:message
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];

	[myAlertView show];
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		NSString *address = [actionSheet buttonTitleAtIndex:buttonIndex];

		self.itemAddressTextField.text = address;

		NSUInteger index = [self.currentAddressStrings indexOfObject:address];
		CLPlacemark *placemark = [self.currentAddressPlacemarks objectAtIndex:index];

		[self saveNewItemWithId:self.itemCodeTextField.text
						address:placemark
					   schedule:self.itemAvailabilityTextField.text
					phoneNumber:self.itemPhoneNumberTextField.text
					  itemImage:self.imageView.image];
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

	self.scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardFrameBeginRect.size.height);

	if (self.scrollView.contentSize.height > self.scrollView.height)
	{
		CGPoint offset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.height);
		[self.scrollView setContentOffset:offset animated:YES];
	}
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	[self.scrollView setFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
}

#pragma mark - Image Picker Controller delegate methods

- (void)showCameraController
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;

	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
	self.imageView.image = chosenImage;

	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

@end

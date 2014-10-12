//
//  NewDonationViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 10/11/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "NewDonationViewController.h"

@interface NewDonationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *itemCodeTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAddressTextField;
@property(weak, nonatomic) IBOutlet UITextField *itemAvailabilityTextField;

@end

@implementation NewDonationViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
	[self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)submitButtonTapped:(id)sender
{
	// pretend async save happens here
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Keyboard methods

- (void)resignAllResponders
{
	[self.itemAddressTextField resignFirstResponder];
	[self.itemCodeTextField resignFirstResponder];
	[self.itemAvailabilityTextField resignFirstResponder];
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

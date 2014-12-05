//
//  MapDashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 11/29/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "MapDashboardViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "UserDataManager.h"
#import "DonatedItem.h"
#import "ItemTableViewController.h"
#import "DonatedItemAnnotation.h"

@interface MapDashboardViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapDashboardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;

	if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
		[self.locationManager requestWhenInUseAuthorization];
	else
		[self.locationManager startUpdatingLocation];

	NSArray *itemsAvailable = [[UserDataManager sharedInstance] allItemsAvailableForPickup];
	for (DonatedItem *item in itemsAvailable)
		[self setMapViewPointForItem:item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kViewItemIdentifier] && [sender isKindOfClass:[DonatedItemAnnotation class]])
	{
		DonatedItemAnnotation *itemAnnotation = (DonatedItemAnnotation *) sender;

		ItemTableViewController *viewController = [[(UINavigationController *) segue.destinationViewController childViewControllers] firstObject];
		viewController.donatedItem = itemAnnotation.item;
		viewController.itemContext = (int *) ViewItemContextDriver;
	}
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	[self.mapView setCenterCoordinate:userLocation.location.coordinate zoomLevel:12 animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[DonatedItemAnnotation class]])
	{
		MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
		DonatedItemAnnotation *itemAnnotation = (DonatedItemAnnotation *) annotation;

		if (annotationView == nil)
			annotationView = itemAnnotation.annotationView;
		else
			annotationView.annotation = itemAnnotation;

		return annotationView;
	}
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	DonatedItemAnnotation *itemAnnotation = (DonatedItemAnnotation *) view.annotation;

	[self performSegueWithIdentifier:kViewItemIdentifier sender:itemAnnotation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
	if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
			authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
		[manager startUpdatingLocation];
}

- (void)setMapViewPointForItem:(DonatedItem *)item
{
	DonatedItemAnnotation *annotation = [[DonatedItemAnnotation alloc] initWithDonatedItem:item];

	[self.mapView addAnnotation:annotation];
}

@end

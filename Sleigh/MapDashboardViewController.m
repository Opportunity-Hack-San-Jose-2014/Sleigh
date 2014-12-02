//
//  MapDashboardViewController.m
//  Sleigh
//
//  Created by Mike Maietta on 11/29/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "MapDashboardViewController.h"
#import "MKMapView+ZoomLevel.h"

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
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	[self.mapView setCenterCoordinate:userLocation.location.coordinate zoomLevel:12 animated:YES];

	[self setMapViewPointDemoNearPoint:userLocation.location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
	if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
			authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
		[manager startUpdatingLocation];
}

- (void)setMapViewPointDemoNearPoint:(CLLocationCoordinate2D)coordinate
{
	MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
	myAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude * 1.0001, coordinate.longitude * 1.0001);
	myAnnotation.title = @"Some geopoint";
	myAnnotation.subtitle = @"Please pickup my item!";

	[self.mapView addAnnotation:myAnnotation];
}

@end

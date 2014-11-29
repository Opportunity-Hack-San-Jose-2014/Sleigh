//
//  MKMapView+ZoomLevel.h
//  Sleigh
//
//  Created by Mike Maietta on 11/29/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

@property(assign, nonatomic) NSUInteger zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
				  zoomLevel:(NSUInteger)zoomLevel
				   animated:(BOOL)animated;

@end

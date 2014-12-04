//
//  DonatedItemAnnotation.m
//  Sleigh
//
//  Created by Mike Maietta on 12/4/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import "DonatedItemAnnotation.h"
#import "DonatedItem.h"

NSString *const reuseIdentifier = @"locationAnnotation";

@implementation DonatedItemAnnotation

- (MKAnnotationView *)annotationView
{

	MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:reuseIdentifier];
	annotationView.canShowCallout = YES;
	annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

	return annotationView;
}

- (instancetype)initWithDonatedItem:(DonatedItem *)item
{
	self = [self init];
	if (self)
	{
		_item = item;
		_coordinate = CLLocationCoordinate2DMake(item.itemGeopoint.latitude, item.itemGeopoint.longitude);
		_title = item.itemCode;
		_subtitle = item.itemAvailabilitySchedule;
	}
	return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

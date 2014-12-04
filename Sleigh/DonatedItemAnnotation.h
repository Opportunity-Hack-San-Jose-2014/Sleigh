//
//  DonatedItemAnnotation.h
//  Sleigh
//
//  Created by Mike Maietta on 12/4/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <MapKit/MapKit.h>

@class DonatedItem;

extern NSString *const reuseIdentifier;

@interface DonatedItemAnnotation : NSObject <MKAnnotation>

@property(nonatomic, strong) DonatedItem *item;

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *subtitle;

- (MKAnnotationView *)annotationView;

- (instancetype)initWithDonatedItem:(DonatedItem *)item;

@end

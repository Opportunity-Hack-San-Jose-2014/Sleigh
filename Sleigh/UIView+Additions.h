//
//  UIView+Additions.h
//
//  Created by Bittu Ahlawat on 4/22/12.
//  Copyright (c) 2012 eBay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SubviewBlock)(UIView *view);

typedef void (^SuperviewBlock)(UIView *superview);

@interface UIView (Additions)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint origin;

+ (id)emptyView;

+ (id)emptyViewFromXibNamed:(NSString *)xibName;

+ (id)emptyViewInBundle:(NSBundle *)bundle;

+ (id)emptyViewFromXibNamed:(NSString *)xibName inBundle:(NSBundle *)bundle;

- (UIImage *)bnrImageContents;

- (UIView *)findFirstResponder;

- (void)removeAllSubviews;

- (void)removeAllSubviewsExceptKindOfClass:(Class)aClass;

- (void)runBlockOnAllSubviews:(SubviewBlock)block;

- (void)runBlockOnAllSuperviews:(SuperviewBlock)block;

- (void)enableAllControlsInViewHierarchy;

- (void)disableAllControlsInViewHierarchy;

- (UIView *)findSuperViewOfClass:(Class)class;
@end

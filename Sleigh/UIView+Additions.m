//
//  UIView+Additions.m
//
//  Created by Bittu Ahlawat on 4/22/12.
//  Copyright (c) 2012 eBay Inc. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

@dynamic x, y, width, height;

+ (id)emptyView
{
	return [self emptyViewFromXibNamed:NSStringFromClass([self class])];
}

+ (id)emptyViewInBundle:(NSBundle *)bundle
{
	return [self emptyViewFromXibNamed:NSStringFromClass([self class]) inBundle:bundle];
}

+ (id)emptyViewFromXibNamed:(NSString *)xibName
{
	return [self emptyViewFromXibNamed:xibName inBundle:[NSBundle mainBundle]];
}

+ (id)emptyViewFromXibNamed:(NSString *)xibName inBundle:(NSBundle *)bundle
{
	NSArray *xibs = [bundle loadNibNamed:xibName owner:self options:nil];
	for (id object in xibs)
		if ([object isKindOfClass:[self class]])
			return object;
	return nil;
}

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (CGFloat)bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (CGFloat)right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)height
{
	return self.size.height;
}

- (CGFloat)width
{
	return CGRectGetWidth(self.frame);
//    return self.frame.size.width;
}

- (CGFloat)x
{
	return self.frame.origin.x;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (CGPoint)origin
{
	return self.frame.origin;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setX:(CGFloat)x
{
	[self setFrame:CGRectMake(x, self.y, self.width, self.height)];
}

- (void)setY:(CGFloat)y
{
	[self setFrame:CGRectMake(self.x, y, self.width, self.height)];
}

- (void)setWidth:(CGFloat)width
{
	[self setFrame:CGRectMake(self.x, self.y, width, self.height)];
}

- (void)setHeight:(CGFloat)height
{
	[self setFrame:CGRectMake(self.x, self.y, self.width, height)];
}

- (void)setSize:(CGSize)size
{
	[self setFrame:CGRectMake(self.x, self.y, size.width, size.height)];
}

- (void)setOrigin:(CGPoint)origin
{
	[self setFrame:CGRectMake(origin.x, origin.y, self.width, self.height)];
}

- (void)setTop:(CGFloat)top
{
	[self setY:top];
}

- (void)setBottom:(CGFloat)bottom
{
	CGFloat y = bottom - self.height;
	[self setY:y];
}

- (void)setLeft:(CGFloat)left
{
	[self setX:left];
}

- (void)setRight:(CGFloat)right
{
	CGFloat x = right - self.width;
	[self setX:x];
}

- (UIImage *)bnrImageContents
{
	CGSize mySize = [self bounds].size;
	UIGraphicsBeginImageContextWithOptions(mySize, NO, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIView *)findFirstResponder
{
	if (self.isFirstResponder)
	{
		return self;
	}

	for (UIView *subView in self.subviews)
	{
		UIView *firstResponder = [subView findFirstResponder];

		if (firstResponder != nil)
		{
			return firstResponder;
		}
	}

	return nil;
}

- (void)removeAllSubviews
{

	NSArray *viewsToRemove = [self subviews];
	for (UIView *v in viewsToRemove)
	{
		[v removeFromSuperview];
	}
}

- (void)removeAllSubviewsExceptKindOfClass:(Class)aClass
{
	NSArray *viewsToRemove = [self subviews];
	for (UIView *v in viewsToRemove)
	{
		if (![v isKindOfClass:aClass])
			[v removeFromSuperview];
	}
}

- (void)runBlockOnAllSubviews:(SubviewBlock)block
{
	block(self);
	for (UIView *view in [self subviews])
	{
		[view runBlockOnAllSubviews:block];
	}
}

- (void)runBlockOnAllSuperviews:(SuperviewBlock)block
{
	block(self);
	if (self.superview)
	{
		[self.superview runBlockOnAllSuperviews:block];
	}
}

- (void)enableAllControlsInViewHierarchy
{
	[self runBlockOnAllSubviews:^(UIView *view)
	{

		if ([view isKindOfClass:[UIControl class]])
		{
			[(UIControl *) view setEnabled:YES];
		}
		else if ([view isKindOfClass:[UITextView class]])
		{
			[(UITextView *) view setEditable:YES];
		}
	}];
}

- (void)disableAllControlsInViewHierarchy
{
	[self runBlockOnAllSubviews:^(UIView *view)
	{

		if ([view isKindOfClass:[UIControl class]])
		{
			[(UIControl *) view setEnabled:NO];
		}
		else if ([view isKindOfClass:[UITextView class]])
		{
			[(UITextView *) view setEditable:NO];
		}
	}];
}

- (UIView *)findSuperViewOfClass:(Class)class
{
	UIView *superView = self;
	do
	{
		superView = [superView superview];
	}
	while (superView && ![superView isKindOfClass:class]);

	return superView;
}
@end

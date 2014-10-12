//  Created by Bittu Ahlawat on 9/24/12.
//  Copyright (c) 2012 eBay. All rights reserved.

#import <UIKit/UIKit.h>

static inline UIColor *RGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
	return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

static inline UIColor *RGB(CGFloat red, CGFloat green, CGFloat blue)
{
	return RGBA(red, green, blue, 1.0f);
}

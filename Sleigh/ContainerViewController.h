//
//  ContainerViewController.h
//  EmbeddedSwapping
//
//  Created by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

- (void)swapViewControllers;

- (void)cycleToNextViewController;

- (void)swapToViewControllerAtIndex:(NSInteger)index;
@end

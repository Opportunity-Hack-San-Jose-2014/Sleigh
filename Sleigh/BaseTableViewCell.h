//
//  BaseTableViewCell.h
//  Sleigh
//
//  Created by Mike Maietta on 10/12/14.
//  Copyright (c) 2014 Wolfpack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic, strong) NSString *titleString;
@property(nonatomic, strong) NSString *dataString;

- (void)setCellTitle:(NSString *)title andData:(NSString *)data;
@end

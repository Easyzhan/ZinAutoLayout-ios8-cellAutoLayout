//
//  UITableView+ZinLayoutCell.h
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZinLayoutCell)

- (CGFloat)zin_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration;

@end

@interface UITableView (ZinTemplateLayoutCellHeightCaching)


- (CGFloat)zin_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;
@end

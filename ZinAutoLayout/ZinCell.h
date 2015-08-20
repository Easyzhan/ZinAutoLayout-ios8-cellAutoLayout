//
//  ZinCell.h
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"
@interface ZinCell : UITableViewCell
/**
 *  通过一个tableview来创建cell
 */
//+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ModelEntity *entity;
@end

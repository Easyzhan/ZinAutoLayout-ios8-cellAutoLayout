//
//  ZinCell.m
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import "ZinCell.h"

@interface ZinCell()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
@implementation ZinCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}
//+(instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"cell";
//    ZinCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if(cell ==nil)
//    {
//        //从xib中加载cell
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZinCell" owner:nil options:nil] lastObject];
//        
//    }
//    
//    return cell;
//}


- (void)setEntity:(ModelEntity *)entity
{
    _entity = entity;
    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    self.contentImageView.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;
}
@end

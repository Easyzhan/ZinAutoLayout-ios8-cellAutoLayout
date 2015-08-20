//
//  ModelEntity.h
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelEntity : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imageName;
@end

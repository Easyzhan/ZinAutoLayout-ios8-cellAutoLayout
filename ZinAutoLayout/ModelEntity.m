//
//  ModelEntity.m
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import "ModelEntity.h"

@implementation ModelEntity
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        self.title = dictionary[@"title"];
        self.content = dictionary[@"content"];
        self.username = dictionary[@"username"];
        self.time = dictionary[@"time"];
        self.imageName = dictionary[@"imageName"];
    }
    return self;
}
@end

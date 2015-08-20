//
//  zinController.m
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//
#import "ZinCell.h"
#import "ModelEntity.h"
//#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+ZinLayoutCell.h"
#import "zinController.h"

@interface zinController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSArray *feedEntities;
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation zinController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.rowHeight = 200;
    self.cellHeightCacheEnabled = YES;
    [self buildTestDataThen:^{
        [self.tableView reloadData];
    }];
}

- (void)buildTestDataThen:(void (^)(void))then
{
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"feed"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[ModelEntity alloc] initWithDictionary:obj]];
        }];
        self.feedEntities = entities;
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedEntities.count;
//    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    ZinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZinCell" forIndexPath:indexPath];
    
    //2.给cell传递模型数据
    cell.entity = self.feedEntities[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeightCacheEnabled) {
        return [tableView zin_heightForCellWithIdentifier:@"ZinCell" cacheByIndexPath:indexPath configuration:^(ZinCell *cell) {
            cell.entity = self.feedEntities[indexPath.row];
        }];
    } else {
        return [tableView zin_heightForCellWithIdentifier:@"ZinCell" configuration:^(ZinCell *cell) {
            cell.entity = self.feedEntities[indexPath.row];
        }];
    }
}


@end

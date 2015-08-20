//
//  UITableView+ZinLayoutCell.m
//  ZinAutoLayout
//
//  Created by Dragon's zin on 15-5-12.
//  Copyright (c) 2015年 zhan神. All rights reserved.
//

#import "UITableView+ZinLayoutCell.h"
#import <objc/runtime.h>
@implementation UITableView (ZinLayoutCell)

- (id)zin_templateCellForReuseIdentifier:(NSString *)identifier;
{
    NSAssert(identifier.length > 0, @"Expects a valid identifier - %@", identifier);
    
    NSMutableDictionary *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithIdentifier:identifier];
        templateCellsByIdentifiers[identifier] = templateCell;
    }
    
    return templateCell;
}
- (CGFloat)zin_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration
{
    // Fetch a cached template cell for `identifier`.
    UITableViewCell *cell = [self zin_templateCellForReuseIdentifier:identifier];
    
    // Reset to initial height as first created, otherwise the cell's height wouldn't retract if it
    // had larger height before it gets reused.
    cell.contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.rowHeight);
    
    // Manually calls to ensure consistent behavior with actual cells (that are displayed on screen).
    [cell prepareForReuse];
    
    // Customize and provide content for our template cell.
    if (configuration) {
        configuration(cell);
    }
    
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:cell.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:CGRectGetWidth(self.frame)];
    [cell.contentView addConstraint:tempWidthConstraint];
    
    // Auto layout does its math
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [cell.contentView removeConstraint:tempWidthConstraint];
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingSize.height;
}

@end

@implementation UITableView (ZinTemplateLayoutCellHeightCaching)
// The entry point where we could trigger automatically cache invalidation. This hacking
// doesn't belong to UITableView itself, so it's better to use a c++ constructor instead of "+load".
// It will be called after all classes have mapped and loaded into runtime.
__attribute__((constructor)) static void ZinTemplateLayoutCellHeightCacheInvalidationEntryPoint()
{
    // Swizzle a private method in a private class "UISectionRowData", we try to assemble this
    // selector instead of using the whole literal string, which may be more safer when submit
    // to App Store.
    NSString *privateSelectorString = [@"refreshWithSection:" stringByAppendingString:@"tableView:tableViewRowData:"];
    SEL originalSelector = NSSelectorFromString(privateSelectorString);
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"UISectionRowData"), originalSelector);
    if (!originalMethod) {
        return;
    }
    void (*originalIMP)(id, SEL, NSUInteger, id, id) = (typeof(originalIMP))method_getImplementation(originalMethod);
    void (^swizzledBlock)(id, NSUInteger, id, id) = ^(id self, NSUInteger section, UITableView *tableView, id rowData) {
        
        // Invalidate height caches first
        [tableView zin_invalidateHeightCaches];
        
        // Call original implementation
        originalIMP(self, originalSelector, section, tableView, rowData);
    };
    method_setImplementation(originalMethod, imp_implementationWithBlock(swizzledBlock));
}
- (NSMutableDictionary *)zin_cellHeightCachesByIndexPath
{
    NSMutableDictionary *cachesByIndexPath = objc_getAssociatedObject(self, _cmd);
    if (!cachesByIndexPath) {
        cachesByIndexPath = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, cachesByIndexPath, OBJC_ASSOCIATION_RETAIN);
    }
    return cachesByIndexPath;
}

- (void)zin_invalidateHeightCaches
{
    if (self.zin_cellHeightCachesByIndexPath.count > 0) {
        [self.zin_cellHeightCachesByIndexPath removeAllObjects];
    }
}

- (CGFloat)zin_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration
{
    NSString *keyForIndexPath = [NSString stringWithFormat:@"%@:%@", @(indexPath.section), @(indexPath.row)];
    if (self.zin_cellHeightCachesByIndexPath[keyForIndexPath]) {
#if CGFLOAT_IS_DOUBLE
        return [self.zin_cellHeightCachesByIndexPath[keyForIndexPath] doubleValue];
#else
        return [self.zin_cellHeightCachesByIndexPath[keyForIndexPath] floatValue];
#endif
    }
    
    CGFloat height = [self zin_heightForCellWithIdentifier:identifier configuration:configuration];
    self.zin_cellHeightCachesByIndexPath[keyForIndexPath] = @(height);
    
    return height;
}
@end

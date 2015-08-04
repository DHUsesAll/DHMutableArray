//
//  DHMutableArray.h
//  CustomMutableArrayDemo
//
//  Created by DreamHack on 15-7-24.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHMutableArray : NSObject

+ (DHMutableArray *)array;
+ (DHMutableArray *)arrayWithNSArray:(NSArray *)array;


- (NSInteger)count;

// 增
- (void)addObject:(id)object;
- (void)insertObject:(id)object atIndex:(NSInteger)index;
- (void)addObjectsFromArray:(DHMutableArray *)array;
// 删
- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)removeObjectsFromArray:(DHMutableArray *)array;
- (void)removeAllObjects;
- (void)removeLastObject;

// 改
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void)exchangeObjectAtIndex:(NSInteger)index withObjectAtIndex:(NSUInteger)idx2;
// 查
- (id)firstObject;
- (id)lastObject;
- (id)objectAtIndex:(NSInteger)index;






@end

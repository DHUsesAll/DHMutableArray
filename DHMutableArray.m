//
//  DHMutableArray.m
//  CustomMutableArrayDemo
//
//  Created by DreamHack on 15-7-24.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHMutableArray.h"

#define DH_NULL NULL

typedef struct  ObjectStruct_{

    void * obj;
    struct ObjectStruct_ * next;

} ObjectStruct;


size_t objSize_ = sizeof(ObjectStruct);

@interface DHMutableArray ()
{
    ObjectStruct * header_;
    ObjectStruct * tail_;
}


- (void)createHeader;
- (ObjectStruct *)nodeAtIndex:(NSInteger)index;

@end

@implementation DHMutableArray

#pragma mark - override
- (void)dealloc
{
    for (ObjectStruct * node = header_; node != DH_NULL; node = node->next) {
        
        ObjectStruct * tempNode = node->next;
        free(node);
        header_ = tempNode;
    }
    [super dealloc];
}

- (NSString *)description
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.count; i++) {
        [array addObject:[self objectAtIndex:i]];
    }
    
    return [array description];
}

#pragma mark - initialize
+ (DHMutableArray *)array
{
    DHMutableArray * array = [[[self alloc] init] autorelease];
    [array createHeader];
    return array;
}

+ (DHMutableArray *)arrayWithNSArray:(NSArray *)array
{
    DHMutableArray * selfArray = [[[self alloc] init] autorelease];
    [selfArray createHeader];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [selfArray addObject:obj];
        
    }];
    return selfArray;
}

#pragma mark - 接口方法
- (NSInteger)count
{
    NSInteger count = 0;
    for (ObjectStruct * node = header_->next; node != DH_NULL; node = node->next) {
        count++;
    }
    
    return count;
}

// 增
- (void)addObject:(id)object
{
    [object retain];
    ObjectStruct * node = malloc(objSize_);
    node->next = DH_NULL;
    node->obj = (__bridge void *)(object);
    
    tail_->next = node;
    tail_ = node;
}


- (void)insertObject:(id)object atIndex:(NSInteger)index
{
    [object retain];
    if (index >= [self count]) {
        [self addObject:object];
        
        return;
    }
    
    ObjectStruct * p = header_;
    
    for (int i = 0; i < index; i++) {
        p = p->next;
    }
    
    ObjectStruct * q = p->next;
    
    ObjectStruct * node = malloc(objSize_);
    node->obj = (__bridge void *)(object);
    node->next = q;
    p->next = node;
}


- (void)addObjectsFromArray:(DHMutableArray *)array
{
    for (int i = 0; i < [array count]; i++) {
        
        id obj = [array objectAtIndex:i];
        [obj retain];
        [self addObject:obj];
        
    }
}
// 删
- (void)removeObject:(id)object
{
    ObjectStruct * removeObject = DH_NULL;
    for (removeObject = header_; removeObject->next->obj != (__bridge void *)object; removeObject = removeObject->next) {
        if (removeObject == DH_NULL) {
            return;
        }
    }
    [object release];
    if (object == (__bridge id)(tail_->obj)) {
        removeObject->next = DH_NULL;
        free(tail_);
        tail_ = removeObject;
        return;
    }
    
    ObjectStruct * removeNext = removeObject->next;
    removeObject->next = removeNext->next;
    free(removeNext);
    
}



- (void)removeObjectAtIndex:(NSInteger)index
{
    if (index >= [self count]) {
        [self removeLastObject];
        return;
    }
    [[self objectAtIndex:index] release];
    ObjectStruct * node = header_;
    for (int i = 0; i < index; i++) {
        node = node->next;
    }
    ObjectStruct * nodeNext = node->next;
    node->next = nodeNext->next;
    free(nodeNext);
}

- (void)removeLastObject
{
    [self removeObject:(__bridge id)tail_->obj];
}


- (void)removeObjectsFromArray:(DHMutableArray *)array
{
    for (int i = 0; i < [array count]; i++) {
        id obj = [array objectAtIndex:i];
        [obj release];
        [self removeObject:obj];
    }
}

- (void)removeAllObjects
{
    if ([self count] == 0) {
        return;
    }
    for (ObjectStruct * node = header_->next; node != DH_NULL; node = node->next) {
        id obj = (__bridge id)(node->obj);
        [obj release];
        header_->next = node->next;
        free(node);
        
    }
}
// 改
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject
{
    [[self objectAtIndex:index] release];
    ObjectStruct * node = [self nodeAtIndex:index];
    node->obj = (__bridge void *)(anObject);
    [anObject retain];
    
}

- (void)exchangeObjectAtIndex:(NSInteger)index withObjectAtIndex:(NSUInteger)idx2
{
    ObjectStruct * node1 = [self nodeAtIndex:index];
    ObjectStruct * node2 = [self nodeAtIndex:idx2];
    void * temp = node1->obj;
    node1->obj = node2->obj;
    node2->obj = temp;
}

// 查
- (id)firstObject
{
    if (header_->next == DH_NULL) {
        return nil;
    }
    return (__bridge id)header_->next->obj;
}

- (id)lastObject
{
    if (header_->next == DH_NULL) {
        return nil;
    }
    return (__bridge id)tail_->obj;
}

- (id)objectAtIndex:(NSInteger)index
{
    NSAssert(index < [self count], @"数组越界");
    
    ObjectStruct * node = [self nodeAtIndex:index];
    
    return (__bridge id)node->obj;
}




#pragma mark - 私有方法
- (void)createHeader
{
    header_ = malloc(objSize_);
    header_->obj = DH_NULL;
    header_->next = DH_NULL;
    tail_ = header_;
}

- (ObjectStruct *)nodeAtIndex:(NSInteger)index
{
    if (index >= [self count]-1) {
        return tail_;
    }
    ObjectStruct * node = header_->next;
    for (int i = 0; i < index; i++) {
        node = node->next;
    }
    
    return node;
}

@end









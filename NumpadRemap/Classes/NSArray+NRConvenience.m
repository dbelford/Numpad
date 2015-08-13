//
//  NSArray+NSArray_NRConvenience.m
//  NumpadRemap
//
//  Created by David Belford on 3/20/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NSArray+NRConvenience.h"

@implementation NSArray (NRConvenience)

- (id)objectBeforeIndex:(NSUInteger)index {
    
    if (index == 0) {
        //Index is first object; no previous object.
        return nil;
    }

    return [self objectAtIndex:index - 1];
}

- (id)objectAfterIndex:(NSUInteger)index {
    if (self.count - 1 == index) {
        //Index is last object; no next object.
        return nil;
    }
    return [self objectAtIndex:index + 1];
}

@end

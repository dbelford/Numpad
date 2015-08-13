//
//  NSArray+NSArray_NRConvenience.h
//  NumpadRemap
//
//  Created by David Belford on 3/20/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NRConvenience)

- (id)objectBeforeIndex:(NSUInteger)index;
- (id)objectAfterIndex:(NSUInteger)index;

@end

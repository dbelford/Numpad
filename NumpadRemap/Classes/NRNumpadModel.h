//
//  NRNumpadModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASShortcut;

typedef NS_ENUM(NSInteger, NRNumpadKeyOrdering) {
    NRNumpadKeyOrderingNumeric,
    NRNumpadKeyOrderingVisual
};


@interface NRNumpadModel : NSObject

@property (nonatomic, strong) NSMutableDictionary /*<MASShortcut *>*/ *shortcuts;


- (void)launchApplicationAtIndex:(NSInteger)index;

+ (BOOL)isNumpadNumber:(unsigned short)keyCode;
+ (BOOL)isKeyboardNumber:(unsigned short)keyCode;
+ (NSInteger)indexForKeyCode:(unsigned short)keyCode usingOrdering:(NRNumpadKeyOrdering)ordering;

@end

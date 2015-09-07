//
//  NRNumpadModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRPreferences.h"

@class MASShortcut;



@interface NRNumpadModel : NSObject

@property (nonatomic, strong) NSMutableDictionary /*<MASShortcut *>*/ *shortcuts;
@property (nonatomic, assign) NRNumpadKeyOrdering ordering;


- (void)launchApplication:(NSRunningApplication *)app;
- (void)launchApplicationAtIndex:(NSInteger)index;

+ (BOOL)isNumpadNumber:(unsigned short)keyCode;
+ (BOOL)isKeyboardNumber:(unsigned short)keyCode;
+ (NSArray *)orderedNumpadANSIKeysForOrdering:(NRNumpadKeyOrdering)ordering;
+ (NSInteger)indexForKeyCode:(unsigned short)keyCode usingOrdering:(NRNumpadKeyOrdering)ordering;

@end

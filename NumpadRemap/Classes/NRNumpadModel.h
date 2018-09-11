//
//  NRNumpadModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRPreferences.h"
#import "NRNumpadShortcutModel.h"

@class MASShortcut;



@interface NRNumpadModel : NSObject

@property (nonatomic, strong) NSArray<NRNumpadShortcutModel *> *shortcuts;
@property (nonatomic, assign) NRNumpadKeyOrdering ordering;
//@property (nonatomic, assign) NRNumpadKeyboardType type;
@property (nonatomic, assign) Boolean hideNumpadNumbers;


- (void)launchApplication:(NSRunningApplication *)app;
- (void)launchApplicationAtIndex:(NSInteger)index;
- (BOOL)launchApplicationForKeycode:(NSUInteger)keyCode;

+ (BOOL)isNumpadNumber:(unsigned short)keyCode;
+ (BOOL)isKeyboardNumber:(unsigned short)keyCode;
+ (NSArray *)orderedNumpadANSIKeysForOrdering:(NRNumpadKeyOrdering)ordering;
+ (NSInteger)indexForKeyCode:(unsigned short)keyCode usingOrdering:(NRNumpadKeyOrdering)ordering;

@end

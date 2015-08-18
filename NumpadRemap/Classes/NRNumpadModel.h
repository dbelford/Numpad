//
//  NRNumpadModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASShortcut;

@interface NRNumpadModel : NSObject

@property (nonatomic, strong) NSMutableDictionary /*<MASShortcut *>*/ *shortcuts;


- (void)launchApplicationAtIndex:(NSInteger)index;


// Make sure model is up to date.
//- (void)update;

@end

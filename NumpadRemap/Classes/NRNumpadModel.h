//
//  NRNumpadModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRNumpadModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *numpadKeys;

// Make sure model is up to date.
- (void)update;

@end

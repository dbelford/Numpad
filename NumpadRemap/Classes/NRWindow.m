//
//  NRWindow.m
//  NumpadRemap
//
//  Created by David Belford on 9/3/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRWindow.h"

@implementation NRWindow


//- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
//    
//    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
//    if (self) {
//        self.backgroundColor = [NSColor clearColor];
//        self.opaque = NO;
//    }
//    
//    return self;
//}
//
//- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
//    
//    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
//    if (self) {
//        self.backgroundColor = [NSColor clearColor];
//        self.opaque = NO;
//    }
//    
//    return self;
//}

- (void)close {
    
    [super close];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

@end

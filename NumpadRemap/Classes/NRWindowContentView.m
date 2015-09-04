//
//  NRWindowContentView.m
//  
//
//  Created by David Belford on 3/19/14.
//
//

#import "NRWindowContentView.h"
#import <Appkit/Appkit.h>
#import <Carbon/Carbon.h>

@implementation NRWindowContentView

//- (BOOL)mouseDownCanMoveWindow {
//    return YES;
//}

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == kVK_Escape) {
        [[NSApplication sharedApplication] hide:nil];
    } else {
        [super keyDown:theEvent];
    }
}

@end

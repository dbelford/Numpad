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
#import <Masonry/Masonry.h>

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

- (void)updateConstraints {
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).insets(NSEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [super updateConstraints];
}

@end

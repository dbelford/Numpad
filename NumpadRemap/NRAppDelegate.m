//
//  NRAppDelegate.m
//  NumpadRemap
//
//  Created by David Belford on 3/13/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRAppDelegate.h"

@implementation NRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    [self.window setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
//        // Custom drawing code!
//    }];
    self.window.backgroundColor = [NSColor whiteColor];
    self.window.titleBarStartColor = [NSColor whiteColor];
    self.window.titleBarEndColor = [NSColor whiteColor];
    self.window.inactiveTitleBarStartColor = [NSColor whiteColor];
    self.window.inactiveTitleBarEndColor = [NSColor whiteColor];
    self.window.showsBaselineSeparator = NO;
    self.window.movableByWindowBackground = YES;
    self.window.nextResponder = self; // TODO: Use WindowController instead of shortcircuit responder chain
    

    
    [self.window setInitialFirstResponder:self.numpadSettingsController.view];

}

#pragma mark - Application Lifecycle

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    [self.window makeKeyAndOrderFront:self];
    
    CGRect f = self.window.frame;
    CGRect s = self.window.screen.frame;
    f.origin.x = (s.size.width - f.size.width) / 2;
    f.origin.y = (s.size.height - f.size.height) / 2;
    
    [self.window setFrameOrigin:f.origin];
    
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [[NSApplication sharedApplication] hide:self];
}

#pragma mark - Etc.

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
}

- (IBAction)printLayout:(id)sender {
    NSLog(@"%@", [self.window.contentView performSelector:@selector(_subtreeDescription)]);
}

- (IBAction)printConstraints:(id)sender {
    [self.window visualizeConstraints:@[]];
//    [self.window visualizeConstraints:self.numpadSettingsController.view.constraints];
}

- (IBAction)printWhatever:(id)sender {
    
}

@end

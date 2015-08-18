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
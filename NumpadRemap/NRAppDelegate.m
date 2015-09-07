//
//  NRAppDelegate.m
//  NumpadRemap
//
//  Created by David Belford on 3/13/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRAppDelegate.h"
#import <DABKit/DABKit.h>
#import "NRGeneralPreferencesViewController.h"
#import <MASPreferences/MASPreferencesWindowController.h>
#import <MASShortcut/Shortcut.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NRPreferencesWindowController.h"

@interface NRAppDelegate ()

@property (nonatomic, strong) MASPreferencesWindowController *preferencesWindowController;

@end

@implementation NRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    [self.window setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
//        // Custom drawing code!
//    }];
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.backgroundColor = [NSColor whiteColor];
//    self.window.titleBarStartColor = [NSColor whiteColor];
//    self.window.titleBarEndColor = [NSColor whiteColor];
//    self.window.inactiveTitleBarStartColor = [NSColor whiteColor];
//    self.window.inactiveTitleBarEndColor = [NSColor whiteColor];
//    self.window.showsBaselineSeparator = NO;
    self.window.movableByWindowBackground = YES;
    self.window.nextResponder = self; // TODO: Use WindowController instead of shortcircuit responder chain
    self.window.collectionBehavior = NSWindowCollectionBehaviorMoveToActiveSpace | NSWindowCollectionBehaviorTransient;
//    self.window.miniaturizable = NO;
//    self.window.miniaturizable

    [[NSApplication sharedApplication] setPresentationOptions:NSApplicationPresentationDisableHideApplication];

    
    [self.window setInitialFirstResponder:self.numpadSettingsController.view];
    
    self.window.delegate = self;
    
    
    @weakify(self);
    [RACObserve([NRPreferences sharedInstance], keyHeight) subscribeNext:^(NSNumber *heightClass) {
        @strongify(self);
        switch (heightClass.integerValue) {
            case NRNumpadKeyHeightSmall:
                [self.window setContentSize:NSMakeSize(320, 320)];
                break;
            case NRNumpadKeyHeightMedium:
                [self.window setContentSize:NSMakeSize(480, 480)];
                break;
            case NRNumpadKeyHeightLarge:
                [self.window setContentSize:NSMakeSize(640, 640)];
                break;
            default:
//                [self.window setContentSize:NSMakeSize(600, 600)];
                break;
        }
        if ([NRPreferences sharedInstance].centerNumpad) {
            [self.window centerWindowInScreen:self.window.screen];
        }
    }];
    
    [NSUserDefaults resetStandardUserDefaults];

    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:kAppActivationShortcutKey
     toAction:^{
         // Let me know if you find a better or a more convenient API.
         @strongify(self);
         [self.numpadSettingsController.numpadModel launchApplication:[NSRunningApplication currentApplication]];
     }];
    
}

- (BOOL)windowShouldClose:(id)sender {
    
    [[NSApplication sharedApplication] hide:nil];
    
    return NO;
}

#pragma mark - Application Lifecycle

- (void)applicationWillBecomeActive:(NSNotification *)notification {

    if ([NRPreferences sharedInstance].centerNumpad) {
        [self.window centerWindowInScreen:[NSScreen mouseScreen]];
    }
    
    [self.window makeKeyAndOrderFront:self];

}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [[NSApplication sharedApplication] hide:self];
}

#pragma mark - Preferences

- (MASPreferencesWindowController *)preferencesWindowController {
    if (_preferencesWindowController == nil) {
        NSArray *vcs = @[[[NRGeneralPreferencesViewController alloc] init]];
        MASPreferencesWindowController *wc = [[NRPreferencesWindowController alloc] initWithViewControllers:vcs title:@"Preferences"];
        [wc.window setInitialFirstResponder:wc.window.contentView];
        _preferencesWindowController = wc;
    }
    return _preferencesWindowController;
}

- (IBAction)showPreferencesWindow:(id)sender {
    [self.preferencesWindowController showWindow:sender];
    [self.preferencesWindowController.window makeKeyWindow];
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

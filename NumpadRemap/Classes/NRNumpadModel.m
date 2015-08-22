//
//  NRNumpadModel.m
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadModel.h"
#import "NRNumpadShortcutModel.h"
#import <MASShortcut/Shortcut.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <DABActiveApplications/DABActiveApplications.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRNumpadModel ()

@property (nonatomic, assign) int lastProcessIdentifier;
@property (nonatomic, strong) DABActiveApplicationsMonitor *monitor;

@end

@implementation NRNumpadModel

- (id)init {
    
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup Numpad

- (void)setup {
    self.monitor = [[DABActiveApplicationsMonitor alloc] init];
    
    RAC(self, shortcuts) = [RACObserve(self.monitor, orderedRunningApplications) map:^ NSMutableDictionary *(NSArray *orderedApps) {
        
        // TODO: Don't use unregisterAllShortcuts but just unregister the keys, or register the shortcuts in the viewModel and have the action sensitive to that context
        
        [[MASShortcutMonitor sharedMonitor] unregisterAllShortcuts];
        
        [[MASShortcutMonitor sharedMonitor] registerShortcut:[MASShortcut shortcutWithKeyCode:kVK_F4 modifierFlags:NSCommandKeyMask] withAction:^{
            [self launchApplication:[NSRunningApplication currentApplication]];
        }];
        
        
        NSMutableDictionary *keys = [NSMutableDictionary dictionary];
        for (int i = kVK_ANSI_Keypad0; i <= kVK_ANSI_Keypad9; i++) {
            if (i == kVK_F20) { continue; }
            
            //Configure Variables
            int keypadNum = i - kVK_ANSI_Keypad0;
            NRNumpadShortcutModel *shortcut = [NRNumpadShortcutModel shortcutWithKeyCode:i modifierFlags:NSCommandKeyMask];
            
            if (orderedApps.count) {

               //Configure Shortcut
                NSRunningApplication *app = orderedApps[MIN(keypadNum, orderedApps.count - 1 )];
                
                shortcut.applicationBundleIdentifier = app.bundleIdentifier;
                shortcut.processIdentifier = app.processIdentifier;

                [[MASShortcutMonitor sharedMonitor] registerShortcut:shortcut withAction:^{
                    [self launchApplication:app];
                }];
            }

            
            //Assign Shortcut to Key
            keys[@(i)] = shortcut;
        }
        return keys;
    }];
}

- (void)launchApplicationAtIndex:(NSInteger)index {
    NSRunningApplication *app = self.monitor.orderedRunningApplications[index];
    [self launchApplication:app];
}

- (void)launchApplication:(NSRunningApplication *)app {
    BOOL appAlreadyActive = app.processIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;
    
    if (appAlreadyActive) {
        [self launchApplicationWithProcessIdentifier:self.lastProcessIdentifier];
    } else {
        self.lastProcessIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;
        [self launchApplicationWithProcessIdentifier:app.processIdentifier];
    }
}

- (void)launchApplicationWithProcessIdentifier:(int)processIdentifier {
    if (processIdentifier == -1) { return; }
    //Faster application fronting
    ProcessSerialNumber pn = {};
    GetProcessForPID(processIdentifier, &pn);
    SetFrontProcessWithOptions(&pn, kSetFrontProcessFrontWindowOnly);
    
    //Slower, but not deprecated, application fronting
    //[[NSRunningApplication runningApplicationWithProcessIdentifier:processIdentifier] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void)launchApp:(NSString *)bundleIdentifier {
    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:bundleIdentifier
                                                         options:0
                                  additionalEventParamDescriptor:nil
                                                launchIdentifier:NULL];
}

#pragma mark - Key Ordering

#pragma mark Handle Keyboard Numbers

+ (NSArray *)orderedKeyboardNumbersForOrdering:(NRNumpadKeyOrdering)ordering {
    
    static NSArray *visualOrdering;
    static NSArray *numericOrdering;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        visualOrdering = @[@(kVK_ANSI_7),
                            @(kVK_ANSI_8),
                            @(kVK_ANSI_9),
                            @(kVK_ANSI_4),
                            @(kVK_ANSI_5),
                            @(kVK_ANSI_6),
                            @(kVK_ANSI_1),
                            @(kVK_ANSI_2),
                            @(kVK_ANSI_3),
                            @(kVK_ANSI_0)];
        numericOrdering = @[@(kVK_ANSI_0),
                            @(kVK_ANSI_1),
                            @(kVK_ANSI_2),
                            @(kVK_ANSI_3),
                            @(kVK_ANSI_4),
                            @(kVK_ANSI_5),
                            @(kVK_ANSI_6),
                            @(kVK_ANSI_7),
                            @(kVK_ANSI_8),
                            @(kVK_ANSI_9)];
    });
    
    if (ordering == NRNumpadKeyOrderingVisual) {
        return visualOrdering;
    }
    if (ordering == NRNumpadKeyOrderingNumeric) {
        return numericOrdering;
    }
    
    return nil;
}



+ (BOOL)isKeyboardNumber:(unsigned short)keyCode {
    if (keyCode >= kVK_ANSI_1 && keyCode <= kVK_ANSI_0) {
        if (keyCode != kVK_ANSI_Minus || keyCode != kVK_ANSI_Equal) {
            return YES;
        }
    }
    return NO;
}

#pragma mark Handle Numpad

+ (NSArray *)orderedNumpadANSIKeysForOrdering:(NRNumpadKeyOrdering)ordering {
    static NSArray *visualOrdering;
    static NSArray *numericOrdering;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        visualOrdering = @[@(kVK_ANSI_Keypad7),
                            @(kVK_ANSI_Keypad8),
                            @(kVK_ANSI_Keypad9),
                            @(kVK_ANSI_Keypad4),
                            @(kVK_ANSI_Keypad5),
                            @(kVK_ANSI_Keypad6),
                            @(kVK_ANSI_Keypad1),
                            @(kVK_ANSI_Keypad2),
                            @(kVK_ANSI_Keypad3),
                            @(kVK_ANSI_Keypad0)];
        numericOrdering = @[@(kVK_ANSI_Keypad0),
                            @(kVK_ANSI_Keypad1),
                            @(kVK_ANSI_Keypad2),
                            @(kVK_ANSI_Keypad3),
                            @(kVK_ANSI_Keypad4),
                            @(kVK_ANSI_Keypad5),
                            @(kVK_ANSI_Keypad6),
                            @(kVK_ANSI_Keypad7),
                            @(kVK_ANSI_Keypad8),
                            @(kVK_ANSI_Keypad9)];
    });
    
    if (ordering == NRNumpadKeyOrderingVisual) {
        return visualOrdering;
    }
    if (ordering == NRNumpadKeyOrderingNumeric) {
        return numericOrdering;
    }
    
    return nil;
}

+ (BOOL)isNumpadNumber:(unsigned short)keyCode {
    if (keyCode >= kVK_ANSI_Keypad0 && keyCode <= kVK_ANSI_Keypad9) {
        if (keyCode != kVK_F20) {
            return YES;
        }
    }
    return NO;
}

#pragma mark Index

+ (NSInteger)indexForKeyCode:(unsigned short)keyCode usingOrdering:(NRNumpadKeyOrdering)ordering {
    
    if([NRNumpadModel isKeyboardNumber:keyCode]) {
        return [[NRNumpadModel orderedKeyboardNumbersForOrdering:ordering] indexOfObject:@(keyCode)];
    } else if ([NRNumpadModel isNumpadNumber:keyCode]) {
        return [[NRNumpadModel orderedNumpadANSIKeysForOrdering:ordering] indexOfObject:@(keyCode)];
    } else {
        return NSNotFound;
    }
}

@end

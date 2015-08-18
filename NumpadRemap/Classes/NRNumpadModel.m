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
//    [self makeKeys];
//    [self makeHandlers];
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
//                    [self launchApplicationWithProcessIdentifier:shortcut.processIdentifier];

//                        NSRunningApplication *app = orderedApps[MIN(keypadNum, orderedApps.count - 1 )];
//                        BOOL appAlreadyActive = app.bundleIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//
//                        if (appAlreadyActive) {
//                            [self launchApp:self.lastAppIdentifier];
//                        } else {
//                            self.lastAppIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//                            [self launchApp:app.bundleIdentifier];
//                        }
//                        
//                        
//                        NSLog(@"Pressed a global handler at %d", keypadNum);
                    
                    
                }];
            }

            
            //Assign Shortcut to Key
            keys[@(i)] = shortcut;
        }
        return keys;
    }];
}

//- (void)makeKeys {
//    
//    self.numpadKeys = [NSMutableDictionary dictionary];
//    for (int i = kVK_ANSI_Keypad0; i <= kVK_ANSI_Keypad9; i++) {
//        if (i == kVK_F20) { continue; }
//        self.numpadKeys[@(i)] = [NRNumpadShortcutModel shortcutWithKeyCode:i modifierFlags:NSCommandKeyMask];
//    }
//}

//- (void)makeHandlers {
//    [self.numpadKeys each:^(NSNumber *key, NRNumpadShortcutModel *shortcut) {
//        
//        int keypadNum = key.intValue - kVK_ANSI_Keypad0;
//        __weak NRNumpadModel *weakSelf = self;
//        
//        
//        [[MASShortcutMonitor sharedMonitor] registerShortcut:self.numpadKeys[key] withAction:^{
//            
//            
//            NSArray *runningApps = [[[NSWorkspace sharedWorkspace] runningApplications] reject:^ BOOL (NSRunningApplication *app){
//                return app.activationPolicy != NSApplicationActivationPolicyRegular;
//            }];
//            
//            NSRunningApplication *app = runningApps[MIN(keypadNum, runningApps.count - 1 )];
//            BOOL appAlreadyActive = app.bundleIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//            
//            if (appAlreadyActive) {
//                [weakSelf launchApp:weakSelf.lastAppIdentifier];
//            } else {
//                weakSelf.lastAppIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//                [weakSelf launchApp:app.bundleIdentifier];
//            }
//            
//            
//            NSLog(@"Pressed a global handler at %d", keypadNum);
//
//        }];
//        
////        [MASShortcut addGlobalHotkeyMonitorWithShortcut:self.numpadKeys[key] handler:^(void){
////        
////        }];
//        
//    }];
//}

- (void)launchApplicationAtIndex:(NSInteger)index {
    NSRunningApplication *app = self.monitor.orderedRunningApplications[index];
    [self launchApplication:app];
}

- (void)launchApplication:(NSRunningApplication *)app {
    BOOL appAlreadyActive = app.processIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;
    
    if (appAlreadyActive) {
//        [self launchApp:self.lastAppIdentifier];
        [self launchApplicationWithProcessIdentifier:self.lastProcessIdentifier];
    } else {
        self.lastProcessIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;

//        self.lastAppIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//        [self launchApp:app.bundleIdentifier];
        [self launchApplicationWithProcessIdentifier:app.processIdentifier];
    }
}

- (void)launchApplicationWithProcessIdentifier:(int)processIdentifier {
//    NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:processIdentifier];
//    [self launchApp:app.bundleIdentifier];
    
    [[NSRunningApplication runningApplicationWithProcessIdentifier:processIdentifier] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

- (void)launchApp:(NSString *)bundleIdentifier {
    [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:bundleIdentifier
                                                         options:0
                                  additionalEventParamDescriptor:nil
                                                launchIdentifier:NULL];
}



#pragma mark - Update Numpad Model

//- (void)update {
//    [self updateAppIconImages];
//}
//
//- (void)updateAppIconImages {
//    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
//    runningApps = [runningApps reject:^ BOOL (NSRunningApplication *app){
//        return app.activationPolicy != NSApplicationActivationPolicyRegular;
//    }];
//    
//    for (int i = 0; i < runningApps.count; i++) {
//        
//        NRNumpadShortcutModel *shortcut = self.shortcuts[@(kVK_ANSI_Keypad0 + i)];
//        NSRunningApplication *app = runningApps[i];
//        shortcut.image = app.icon;
//    }
//}

@end

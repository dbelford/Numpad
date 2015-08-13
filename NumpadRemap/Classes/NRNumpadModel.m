//
//  NRNumpadModel.m
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadModel.h"
#import "NRNumpadShortcutModel.h"
#import <MASShortcut/MASShortcut+Monitoring.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface NRNumpadModel ()

@property (nonatomic, strong) NSString *lastAppIdentifier;

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
    [self makeKeys];
    [self makeHandlers];
}

- (void)makeKeys {
    
    self.numpadKeys = [NSMutableDictionary dictionary];
    for (int i = kVK_ANSI_Keypad0; i <= kVK_ANSI_Keypad9; i++) {
        if (i == kVK_F20) { continue; }
        self.numpadKeys[@(i)] = [NRNumpadShortcutModel shortcutWithKeyCode:i modifierFlags:NSCommandKeyMask];
    }
}

- (void)makeHandlers {
    [self.numpadKeys each:^(NSNumber *key, NRNumpadShortcutModel *shortcut) {
        
        int keypadNum = key.intValue - kVK_ANSI_Keypad0;
        __weak NRNumpadModel *weakSelf = self;
        
        [MASShortcut addGlobalHotkeyMonitorWithShortcut:self.numpadKeys[key] handler:^(void){
            
            NSArray *runningApps = [[[NSWorkspace sharedWorkspace] runningApplications] reject:^ BOOL (NSRunningApplication *app){
                return app.activationPolicy != NSApplicationActivationPolicyRegular;
            }];
            
            NSRunningApplication *app = runningApps[MIN(keypadNum, runningApps.count - 1 )];
            
            if (app.bundleIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier) {
                [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:weakSelf.lastAppIdentifier
                                                                     options:0
                                              additionalEventParamDescriptor:nil
                                                            launchIdentifier:NULL];
            } else {
                weakSelf.lastAppIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
                [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:app.bundleIdentifier
                                                                     options:0
                                              additionalEventParamDescriptor:nil
                                                            launchIdentifier:NULL];
                
            }
            
            
            NSLog(@"Pressed a global handler at %d", keypadNum);
        }];
        
    }];
//    
//    for (__block int i = kVK_ANSI_Keypad0; i <= kVK_ANSI_Keypad9; i++) {
//        int keypadNum = i - kVK_ANSI_Keypad0;
//        
//        
//        __weak NRNumpadModel *weakSelf = self;
//        
//        [MASShortcut addGlobalHotkeyMonitorWithShortcut:self.numpadKeys[@(i)] handler:^(void){
//            
//            NSArray *runningApps = [[[NSWorkspace sharedWorkspace] runningApplications] reject:^ BOOL (NSRunningApplication *app){
//                return app.activationPolicy != NSApplicationActivationPolicyRegular;
//            }];
//            
//            NSRunningApplication *app = runningApps[MIN(keypadNum, runningApps.count - 1 )];
//            
//            if (app.bundleIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier) {
//                [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:weakSelf.lastAppIdentifier
//                                                                     options:0
//                                              additionalEventParamDescriptor:nil
//                                                            launchIdentifier:NULL];
//            } else {
//                weakSelf.lastAppIdentifier = [NSWorkspace sharedWorkspace].frontmostApplication.bundleIdentifier;
//                [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:app.bundleIdentifier
//                                                                     options:0
//                                              additionalEventParamDescriptor:nil
//                                                            launchIdentifier:NULL];
//
//            }
//            
//            
//            NSLog(@"Pressed a global handler at %d", keypadNum);
//        }];
//    }
}



#pragma mark - Update Numpad Model

- (void)update {
    [self updateAppIconImages];
}

- (void)updateAppIconImages {
    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
    runningApps = [runningApps reject:^ BOOL (NSRunningApplication *app){
        return app.activationPolicy != NSApplicationActivationPolicyRegular;
    }];
    
    for (int i = 0; i < runningApps.count; i++) {
        
        NRNumpadShortcutModel *shortcut = self.numpadKeys[@(kVK_ANSI_Keypad0 + i)];
        NSRunningApplication *app = runningApps[i];
        shortcut.image = app.icon;
    }
}

@end

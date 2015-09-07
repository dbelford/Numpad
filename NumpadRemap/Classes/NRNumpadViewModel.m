//
//  NRNumpadViewModel.m
//  NumpadRemap
//
//  Created by David Belford on 8/14/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRNumpadViewModel.h"
#import <Carbon/Carbon.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NRNumpadModel.h"
#import "NRNumpadShortcutModel.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import "NRPreferences.h"

//kVK_ANSI_KeypadMultiply       = 0x43,
//kVK_ANSI_KeypadPlus           = 0x45,
//kVK_ANSI_KeypadClear          = 0x47,
//kVK_ANSI_KeypadDivide         = 0x4B,
//kVK_ANSI_KeypadEnter          = 0x4C,
//kVK_ANSI_KeypadMinus          = 0x4E,
//kVK_ANSI_KeypadEquals         = 0x51,
//kVK_ANSI_Keypad0              = 0x52,
//kVK_ANSI_Keypad1              = 0x53,
//kVK_ANSI_Keypad2              = 0x54,
//kVK_ANSI_Keypad3              = 0x55,
//kVK_ANSI_Keypad4              = 0x56,
//kVK_ANSI_Keypad5              = 0x57,
//kVK_ANSI_Keypad6              = 0x58,
//kVK_ANSI_Keypad7              = 0x59,
//kVK_ANSI_Keypad8              = 0x5B,
//kVK_ANSI_Keypad9              = 0x5C


@implementation NRNumpadViewModel

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        RAC(self, numpadKeys) = [RACObserve(self, model.shortcuts) map:^NSArray *(NSArray *shortCuts) {
            return [shortCuts map:^id(NRNumpadShortcutModel *shortcut) {
                return [NRNumpadViewModel keyViewModelForShortcut:shortcut andIdentifier:shortcut.keyCodeString.intValue];
            }];
        }];
        
        self.keycodeActivatedSignal = [RACSubject subject];
    }
    
    return self;
}

+ (NRNumpadKeyViewModel *)keyViewModelForShortcut:(NRNumpadShortcutModel *)shortcut andIdentifier:(int)identifier {
    
    NRNumpadKeyViewModel *vm = [[NRNumpadKeyViewModel alloc] init];
    vm.shortcut = shortcut;
    vm.identifier = @(identifier).stringValue;
    return vm;
}

- (IBAction)pressedKeyForKeycode:(NSUInteger)keycode {
    [self.keycodeActivatedSignal sendNext:@(keycode)];
}

@end

@implementation NRNumpadKeyViewModel

- (NSString *)keyName {
    return self.shortcut.keyCodeString;
}

- (NSString *)applicationBundleIdentifier {
    return self.shortcut.applicationBundleIdentifier ? self.shortcut.applicationBundleIdentifier : @"";
}

- (NSImage *)image {
    NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:self.shortcut.processIdentifier];
    return app.icon;
}

- (NSString *)displayName {
    return self.shortcut.keyName;
}

@end

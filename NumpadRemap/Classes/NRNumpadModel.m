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
        
        self.ordering = NRNumpadKeyOrderingNumeric;
        
        
        [self setup];
        
    }
    
    return self;
}

#pragma mark - Setup Numpad

- (void)setup {
    self.monitor = [[DABActiveApplicationsMonitor alloc] init];
    
    @weakify(self);
    [RACObserve([NRPreferences sharedInstance], keyOrdering) subscribeNext:^(NSNumber *ordering) {
        @strongify(self);
        self.ordering = ordering.integerValue;
    }];
    
    RAC(self, shortcuts) = [RACSignal combineLatest:@[RACObserve(self.monitor, orderedRunningApplications), RACObserve(self, ordering)] reduce:^NSArray *(NSArray *orderedApps, NSNumber *ordering){
        
        NSArray *orderedKeys = [NRNumpadModel orderedNumpadANSIKeysForOrdering:ordering.integerValue];
        
        return [orderedKeys map:^NRNumpadShortcutModel *(NSNumber *key) {
            //Configure Variables
            NRNumpadShortcutModel *shortcut = [NRNumpadShortcutModel shortcutWithKeyCode:key.unsignedShortValue modifierFlags:NSCommandKeyMask];
            
            if (orderedApps.count) {
              NSUInteger idx = [orderedKeys indexOfObject:key];
              if ( idx < orderedApps.count  ) {
                //Configure Shortcut
                NSRunningApplication *app = orderedApps[idx];

                shortcut.applicationBundleIdentifier = app.bundleIdentifier;
                shortcut.processIdentifier = app.processIdentifier;
              }
                
            }
            return shortcut;
        }];
    }];
}

- (void)launchApplicationAtIndex:(NSInteger)index {
  if (index < self.monitor.orderedRunningApplications.count) {
    NSRunningApplication *app = self.monitor.orderedRunningApplications[index];
    [self launchApplication:app];
  }
}

- (void)launchApplication:(NSRunningApplication *)app {
    BOOL appAlreadyActive = app.processIdentifier == [NSWorkspace sharedWorkspace].frontmostApplication.processIdentifier;
    
    if (appAlreadyActive) {
        [[NSApplication sharedApplication] hide:self]; //Hiding app in delegate willResign is too slow
        [self launchApplicationAtIndex:0];
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

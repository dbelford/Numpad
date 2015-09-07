//
//  NRPreferences.m
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRPreferences.h"
#import <MASShortcut/Shortcut.h>

// Pick a preference key to store the shortcut between launches
NSString *const kAppActivationShortcutKey = @"randomKey";

@implementation NRPreferences

@dynamic hasSeenIntro;
//@dynamic launchAtLogin;
@dynamic keyHeight;
@dynamic keyOrdering;
@dynamic centerNumpad;
@dynamic hideNumpadNumbers;
@dynamic firstVersionInstalled;
@dynamic latestVersionInstalled;
@dynamic appActivationKey;

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    
    NSString *version =
    [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    // This is a fresh install. Set default preferences.
    if (!self.firstVersionInstalled) {
        self.firstVersionInstalled = version;
        [self loadFirstLaunchPreferences];
        
        // Post this after the initializer finishes to give others to listen
        // to this on construction.
        //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
        //    [c postNotificationName:MPDidDetectFreshInstallationNotification
        //                     object:self];
        //}];
    }
    [self loadDefaultUserDefaults];
    self.latestVersionInstalled = version;
    return self;
}

- (void)resetPreferences {
    [self loadFirstLaunchPreferences];
}

- (void)loadFirstLaunchPreferences {
    self.hasSeenIntro = NO;
    self.launchAtLogin = YES;
    self.keyHeight = NRNumpadKeyHeightMedium;
    self.keyOrdering = NRNumpadKeyOrderingNumeric;
    self.centerNumpad = YES;
    self.hideNumpadNumbers = NO;

    [[MASShortcutBinder sharedBinder] registerDefaultShortcuts:@{ kAppActivationShortcutKey : [MASShortcut shortcutWithKeyCode:kVK_ANSI_KeypadClear modifierFlags:0]}];
}

- (void)loadDefaultUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (![defaults objectForKey:@"editorMaximumWidth"])
//        self.editorMaximumWidth = 1000.0;
//    if (![defaults objectForKey:@"editorAutoIncrementNumberedLists"])
//        self.editorAutoIncrementNumberedLists = YES;
//    if (![defaults objectForKey:@"editorInsertPrefixInBlock"])
//        self.editorInsertPrefixInBlock = YES;
}

#pragma handle Launch at Login
// License is BSD
// From: https://gist.github.com/joerick/73670eba228c177bceb3

- (BOOL)launchAtLogin {
    LSSharedFileListItemRef loginItem = [self loginItem];
    BOOL result = loginItem ? YES : NO;
    
    if (loginItem) {
        CFRelease(loginItem);
    }
    
    return result;
}

- (void)setLaunchAtLogin:(BOOL)launchAtLogin {
    if (launchAtLogin == self.launchAtLogin) {
        return;
    }
    
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (launchAtLogin) {
        CFURLRef appUrl = (__bridge CFURLRef)[[NSBundle mainBundle] bundleURL];
        LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL,
                                                                        NULL, appUrl, NULL, NULL);
        if (itemRef) CFRelease(itemRef);
    } else {
        LSSharedFileListItemRef loginItem = [self loginItem];
        
        LSSharedFileListItemRemove(loginItemsRef, loginItem);
        if (loginItem != nil) CFRelease(loginItem);
    }
    
    if (loginItemsRef) CFRelease(loginItemsRef);
}

#pragma mark Private

- (LSSharedFileListItemRef)loginItem {
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (!loginItemsRef) {
        return NULL;
    }
    
    NSArray *loginItems = CFBridgingRelease(LSSharedFileListCopySnapshot(loginItemsRef, nil));
    
    LSSharedFileListItemRef result = NULL;
    
    for (id item in loginItems) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        CFURLRef itemURLRef;
        
        if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
            NSURL *itemURL = (__bridge NSURL *)itemURLRef;
            
            if ([itemURL isEqual:bundleURL]) {
                result = itemRef;
                break;
            }
        }
    }
    
    if (result != nil) {
        CFRetain(result);
    }
    
    CFRelease(loginItemsRef);
    
    return result;
}

@end

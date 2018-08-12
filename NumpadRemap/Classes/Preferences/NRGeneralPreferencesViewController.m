//
//  NRGeneralPreferencesViewController.m
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRGeneralPreferencesViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRGeneralPreferencesViewController ()

@end

@implementation NRGeneralPreferencesViewController

//@synthesize viewIdentifier;

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.shortcutView.shortcutValidator = [[NRShortcutValidator alloc] init];
    self.shortcutView.associatedUserDefaultsKey = kAppActivationShortcutKey;
    
}

- (NSString *)viewIdentifier {
  return @"General";
}

- (NSString *)identifier {
    return @"General";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"General", @"Preference pane title.");
}



@end


@implementation NRShortcutValidator

- (BOOL)isShortcutValid: (MASShortcut*) shortcut {
    
    if (shortcut.keyCode == kVK_ANSI_KeypadClear) {
        return YES;
    } else {
        return [super isShortcutValid:shortcut];
    }
}

@end

//
//  NRGeneralPreferencesViewController.m
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRGeneralPreferencesViewController.h"

@interface NRGeneralPreferencesViewController ()

@end

@implementation NRGeneralPreferencesViewController

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

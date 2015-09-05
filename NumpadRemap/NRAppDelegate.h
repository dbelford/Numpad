//
//  NRAppDelegate.h
//  NumpadRemap
//
//  Created by David Belford on 3/13/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <INAppStoreWindow/INAppStoreWindow.h>
#import "NRNumpadSettingsController.h"

@interface NRAppDelegate : NSResponder <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NRNumpadSettingsController *numpadSettingsController;

- (IBAction)printLayout:(id)sender;
- (IBAction)printConstraints:(id)sender;

- (IBAction)showPreferencesWindow:(id)sender;

@end

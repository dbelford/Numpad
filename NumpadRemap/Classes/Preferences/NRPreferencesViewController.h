//
//  NRPreferencesViewController.h
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NRPreferences.h"

@interface NRPreferencesViewController : NSViewController

@property (nonatomic, readonly) NRPreferences *preferences;

- (id)init;
- (IBAction)restoreDefaults:(id)sender;

@end

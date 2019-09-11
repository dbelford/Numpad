//
//  NRGeneralPreferencesViewController.h
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRPreferencesViewController.h"
#import <MASPreferences/MASPreferencesViewController.h>
#import <MASShortcut/Shortcut.h>
// #import "NRNumpadModel.h"

@interface NRGeneralPreferencesViewController : NRPreferencesViewController <MASPreferencesViewController>

@property (nonatomic, strong) IBOutlet MASShortcutView *shortcutView;
//@property (nonatomic, strong) NSMatrix *sizeMatrix;

@end

@interface NRShortcutValidator : MASShortcutValidator

@end

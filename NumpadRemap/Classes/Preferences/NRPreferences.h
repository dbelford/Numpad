//
//  NRPreferences.h
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import <PAPreferences/PAPreferences.h>

typedef NS_ENUM(NSInteger, NRNumpadKeyOrdering) {
    NRNumpadKeyOrderingNumeric,
    NRNumpadKeyOrderingVisual,
    NRNumpadKeyOrderingFullNumpad
};

typedef NS_ENUM(NSInteger, NRKeyboardType) {
  NRKeyboardTypeUnknown,
  NRKeyboardTypeKeypadNumbers,
  NRKeyboardTypeFullNumpad,
  NRKeyboardType10Keyless,
  NRKeyboardTypeFullKeyboard
};

typedef NS_ENUM(NSInteger, NRNumpadKeyHeight) {
    NRNumpadKeyHeightSmall,
    NRNumpadKeyHeightMedium,
    NRNumpadKeyHeightLarge
};

extern NSString *const kAppActivationShortcutKey;

@interface NRPreferences : PAPreferences

@property (assign) BOOL hasSeenIntro;
@property (assign) BOOL launchAtLogin;
@property (assign) BOOL centerNumpad;
@property (assign) BOOL hideNumpadNumbers;
@property (assign) BOOL hideOnDeactivate;
@property (assign) NRNumpadKeyHeight keyHeight;
@property (assign) NRNumpadKeyOrdering keyOrdering;
@property (assign) NRKeyboardType keyboardType;

@property (assign) NSString *firstVersionInstalled;
@property (assign) NSString *latestVersionInstalled;

@property (assign) NSDictionary *appActivationKey;

- (void)resetPreferences;

@end

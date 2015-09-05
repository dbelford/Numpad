//
//  NRPreferences.h
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import <PAPreferences/PAPreferences.h>

@interface NRPreferences : PAPreferences

@property (assign) BOOL hasSeenIntro;
@property (assign) BOOL launchAtLogin;
@property (assign) NSInteger iconSize;

@property (assign) NSString *firstVersionInstalled;
@property (assign) NSString *latestVersionInstalled;

- (void)resetPreferences;

@end

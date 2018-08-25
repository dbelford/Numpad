//
//  NRNumpadKeyViewModel.m
//  Numpad
//
//  Created by David Belford on 8/20/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

#import "NRNumpadKeyViewModel.h"

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

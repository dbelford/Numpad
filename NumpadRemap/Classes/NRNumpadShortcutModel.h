//
//  NRNumpadShortcutModel.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MASShortcut/MASShortcut.h>

@interface NRNumpadShortcutModel : MASShortcut

@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *applicationBundleIdentifier;

@end

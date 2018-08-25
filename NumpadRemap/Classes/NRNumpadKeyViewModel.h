//
//  NRNumpadKeyViewModel.h
//  Numpad
//
//  Created by David Belford on 8/20/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRNumpadShortcutModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface NRNumpadKeyViewModel : NSObject

@property (nonatomic, strong) NRNumpadShortcutModel *shortcut;
@property (nonatomic, strong) NSString *identifier; //key.stringValue for ordering keys

@property (nonatomic, readonly) NSString *keyName; //MASShortcut.keyCodeString
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *applicationBundleIdentifier;
@property (nonatomic, readonly) NSImage *image;
@property (nonatomic, assign) Boolean hideNumpadNumbers;

@end

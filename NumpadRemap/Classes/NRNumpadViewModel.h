//
//  NRNumpadViewModel.h
//  NumpadRemap
//
//  Created by David Belford on 8/14/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRNumpadModel.h"
#import "NRNumpadShortcutModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRNumpadViewModel : NSObject

@property (nonatomic, strong) NRNumpadModel *model;

@property (nonatomic, strong) NSMutableDictionary /* NRNumpadKeyViewModel * */ *numpadKeys;
@property (nonatomic, strong) NSArray /* NSImage *  */ *keyImages;
@property (nonatomic, strong) NSArray /* NSString * */ *displayNames;
@property (nonatomic, strong) NSArray /* NSString * */ *keyNames;

@property (nonatomic, strong) RACSubject *keyPressedSignal;


- (IBAction)pressedKeyAtIndex:(NSInteger)index;

@end

@interface NRNumpadKeyViewModel : NSObject

@property (nonatomic, strong) NRNumpadShortcutModel *shortcut;
@property (nonatomic, strong) NSString *identifier; //key.stringValue for ordering keys

@property (nonatomic, readonly) NSString *keyName; //MASShortcut.keyCodeString
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *applicationBundleIdentifier;
@property (nonatomic, readonly) NSImage *image;

@end
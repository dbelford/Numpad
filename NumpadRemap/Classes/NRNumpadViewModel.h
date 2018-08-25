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

@class NRNumpadKeyViewModel;

@interface NRNumpadViewModel : NSObject

@property (nonatomic, strong) IBOutlet NRNumpadModel *model;

@property (nonatomic, strong) NSArray<NRNumpadKeyViewModel *> *numpadKeys;
@property (nonatomic, strong) NSArray<NSImage *>  *keyImages;
@property (nonatomic, strong) NSArray<NSString *> *displayNames;
@property (nonatomic, strong) NSArray<NSString *> *keyNames;

@property (nonatomic, strong) RACSubject *keycodeActivatedSignal;
@property (nonatomic, assign) Boolean hideNumpadNumbers;

- (IBAction)pressedKeyForKeycode:(NSUInteger)keycode;
- (instancetype)initWithModel:(NRNumpadModel *)model;

@end



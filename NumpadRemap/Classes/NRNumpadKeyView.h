//
//  NRNumpadKeyView.h
//  NumpadRemap
//
//  Created by David Belford on 3/17/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Butter/Butter.h>
#import "NRNumpadViewModel.h"
#import "NRNumpadKeyViewModel.h"

@class NumpadKeyViewModel;

@interface NRNumpadKeyView : BTRControl <NSDraggingSource, NSDraggingDestination>


@property (nonatomic, strong) NumpadKeyViewModel *viewModel;
@property (nonatomic, strong) NSImage *iconImage;
@property (nonatomic, strong) NSImageView *iconImageView;
@property (nonatomic, strong) BTRLabel *keyLabel;

@end

//
//  NRNumpadView.h
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Butter/Butter.h>
//#import "NRNumpadViewModel.h"
//#import "ShortcutMappingModel.h

@class NumpadViewModel;

IB_DESIGNABLE
@interface NRNumpadView : BTRView

@property (nonatomic, strong) IBOutlet NumpadViewModel *viewModel;

@end

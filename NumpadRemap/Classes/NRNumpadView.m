//
//  NRNumpadView.m
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadView.h"
#import <Carbon/Carbon.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSArray+NRConvenience.h"
#import "NRNumpadKeyView.h"
#import "Numpad-Swift.h"

@interface NRNumpadView ()

@property (nonatomic, strong) NSArray<NRNumpadKeyView *> *keyViews;

@end

@implementation NRNumpadView

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        NSArray *keyOrder = @[@(kVK_ANSI_Keypad7),
                              @(kVK_ANSI_Keypad8),
                              @(kVK_ANSI_Keypad9),
                              @(kVK_ANSI_Keypad4),
                              @(kVK_ANSI_Keypad5),
                              @(kVK_ANSI_Keypad6),
                              @(kVK_ANSI_Keypad1),
                              @(kVK_ANSI_Keypad2),
                              @(kVK_ANSI_Keypad3),
                              @(kVK_ANSI_Keypad0)
                              ];

        @weakify(self)
        RAC(self, keyViews) = [RACObserve(self, viewModel.numpadKeys) map:^NSArray *(NSArray *keyViewModels) {
            
            @strongify(self)
            
            // Make Views
            NSArray *views = [keyViewModels map: ^NSView *(NRNumpadKeyViewModel *keyViewModel) {
                NRNumpadKeyView *view = [[NRNumpadKeyView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)];
                view.iconImageView.image = keyViewModel.image;
                view.keyLabel.stringValue = keyViewModel.keyName;
                view.identifier = @(keyViewModel.shortcut.keyCode).stringValue;
                [view addTarget:self action:@selector(pressedAppButton:) forControlEvents:BTRControlEventMouseUpInside];
            
                RAC(view.keyLabel,hidden) = RACObserve([NRPreferences sharedInstance], hideNumpadNumbers);
                return view;
            }];
            
            // Order Views
            views = [views sortedArrayWithOptions:0 usingComparator:^NSComparisonResult (NRNumpadKeyView *view1, NRNumpadKeyView *view2) {
                NSInteger v1 = view1.identifier.integerValue;
                NSInteger v2 = view2.identifier.integerValue;
                
                NSUInteger v1Ordered = [keyOrder indexOfObject:@(v1)];
                NSUInteger v2Ordered = [keyOrder indexOfObject:@(v2)];
                
                return v1Ordered < v2Ordered ? NSOrderedAscending : NSOrderedDescending;
            }];
            
            // Display Views
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [views each:^(NSView *view) {
                [self addSubview:view];
            }];
            self.needsUpdateConstraints = YES;
            
            // Save Views
            return views;
        }];
      

        self.wantsLayer = YES;
    }
    return self;
}

- (void)pressedAppButton:(NRNumpadKeyView *)sender {
//    [self.viewModel pressedKeyForKeycode:sender.identifier.integerValue];
  [self.viewModel pressedKeyForKeycodeWithKeycode:sender.identifier.integerValue];
}

- (void)updateConstraints {
    
    [super updateConstraints];
    [self layoutKeys];

}

//- (void)awakeFromNib {
//  
//}

- (NSView *)viewAt:(NSIndexPath *)indexPath {
    
    NSUInteger i = [indexPath indexAtPosition:0];
    NSUInteger j = [indexPath indexAtPosition:1];
    NSUInteger indexToUse = i + j*3;
    
    if (i > 100 || j > 100) {
        return nil;
    }
    
    return [self.keyViews objectAtIndex:indexToUse];
}

- (NSView *)viewAbove:(NSIndexPath *)indexPath {
    
    NSUInteger i = [indexPath indexAtPosition:0];
    NSUInteger j = [indexPath indexAtPosition:1] - 1;
    
    NSUInteger indexes[] = {i, j};
    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:indexes length:2];
    return [self viewAt:path];
}

- (NSView *)viewLeading:(NSIndexPath *)indexPath {
    
    NSUInteger i = [indexPath indexAtPosition:0] - 1;
    NSUInteger j = [indexPath indexAtPosition:1];
    NSUInteger indexes[] = {i, j};
    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:indexes length:2];
    return [self viewAt:path];
}

- (void)layoutKeys {
  [self layoutKeysNumberStyle];
}

- (void)layoutKeysNumberStyle {
    [self.keyViews eachWithIndex:^(NRNumpadKeyView *view, NSUInteger index) {
        
//        view.keyLabel.stringValue = [NSString stringWithFormat:@"%lu", index];
        NSUInteger i = index % 3;
        NSUInteger j = index / 3;
        
        NSIndexPath *indexPath = [[NSIndexPath indexPathWithIndex:i] indexPathByAddingIndex:j];
        
//        NSView *prevView = [self.keyViews objectBeforeIndex:index];
//        NSView *nextView = [self.keyViews objectAfterIndex:index];
        NSView *viewAbove = [self viewAbove:indexPath];
        NSView *viewLeading = [self viewLeading:indexPath];
      

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (viewAbove) {
                make.top.equalTo(viewAbove.mas_bottom).offset(10);
            } else {
                make.top.equalTo(self.mas_top).offset(10);
            }
            
            
            if (viewLeading) {
                make.left.equalTo(viewLeading.mas_right).offset(10);
            } else {
                make.left.equalTo(self.mas_left).offset(10);
            }
            
            if (i == 2) {
                make.right.equalTo(self.mas_right).offset(-10);
            }
            if (j == ((self.keyViews.count - 1) / 3)) {
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            }
            
            if (index == self.keyViews.count - 1) {
                make.width.equalTo(viewAbove).multipliedBy(2).offset(10).priorityHigh();
            }
        }];
        
    }];
    
    NSView *firstView = [self.keyViews firstObject];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(firstView.mas_width);
        // Skip first
        NSArray *heightViews = [self.keyViews subarrayWithRange:NSMakeRange(1, self.keyViews.count - 1)];
        // Skip first & last
        NSArray *widthViews = [self.keyViews subarrayWithRange:NSMakeRange(1, self.keyViews.count - 2)];
        make.height.equalTo(heightViews);
        make.width.equalTo(widthViews);
    }];
     
}

@end

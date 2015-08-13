//
//  NRNumpadView.m
//  NumpadRemap
//
//  Created by David Belford on 3/16/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadView.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <Masonry/Masonry.h>
#import "NSArray+NRConvenience.h"
#import "NRNumpadKeyView.h"

@implementation NRNumpadView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        

//        self.wantsLayer = YES;
    }
    return self;
}

- (void)setKeyViews:(NSMutableArray *)keyViews {
    
    [_keyViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _keyViews = keyViews;
    
    [_keyViews each:^(NSView *view) {
        [self addSubview:view];
    }];

    self.needsUpdateConstraints = YES;
}

- (void)updateConstraints {
    
    [super updateConstraints];
    
//    [self layoutVerticalRows];
    [self layoutKeys];

}

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

- (void)layoutVerticalRows {
    [self.keyViews eachWithIndex:^(NSView *view, NSUInteger index) {
        
        NSView *prevView = [self.keyViews objectBeforeIndex:index];
        NSView *nextView = [self.keyViews objectAfterIndex:index];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //            make.height.equalTo(@[view1.mas_height, view2.mas_height]);
            
            if (!prevView) {
                make.top.equalTo(self.mas_top).offset(10);
            } else {
                make.top.equalTo(prevView.mas_bottom).with.offset(10); //with is an optional semantic filler
            }
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
            if (!nextView) {
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            } else {
                make.bottom.equalTo(nextView.mas_top).with.offset(-10);
            }
        }];
        
    }];
    
    
    NSView *firstView = [self.keyViews firstObject];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        NSArray *relatedViews = [self.keyViews subarrayWithRange:NSMakeRange(1, self.keyViews.count - 1)];
        make.height.equalTo(relatedViews);
    }];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
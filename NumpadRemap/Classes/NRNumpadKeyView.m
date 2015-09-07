//
//  NRNumpadKeyView.m
//  NumpadRemap
//
//  Created by David Belford on 3/17/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadKeyView.h"
#import <Masonry/Masonry.h>

@implementation NRNumpadKeyView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.iconImageView = [[NSImageView alloc] initWithFrame:frame];
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
//        self.iconImageView.contentMode = BTRViewContentModeScaleAspectFit;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [NSColor grayColor].CGColor;
        self.layer.cornerRadius = 7;
        self.keyLabel = [[BTRLabel alloc] initWithFrame:frame];
        self.keyLabel.stringValue = @"Key Label Work";
        self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.keyLabel.font = [NSFont systemFontOfSize:16.0];
        self.keyLabel.textColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
        
        [self addSubview:_iconImageView];
        [self addSubview:_keyLabel];
        
//        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).with.insets(NSEdgeInsetsMake(10, 10, 10, 10));
//        }];

        
        self.needsUpdateConstraints = YES;
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.btr_backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
    } else {
        self.btr_backgroundColor = nil;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.btr_backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
    } else {
        self.btr_backgroundColor = nil;
    }
}

- (void)configureView {

//    self.needsUpdateConstraints = YES;

}

// TODO: Figure out why deleteing intrinsicContentSize breaks window resizing!

- (CGSize)intrinsicContentSize {
    return CGSizeMake(60, 60);
}

- (void)updateConstraints {
    [super updateConstraints];
    [self constraintsV2];
}

- (void)constraintsV2 {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).insets(NSEdgeInsetsMake(20, 20, 20, 20));
        
    }];
    
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.lessThanOrEqualTo(self.mas_height).multipliedBy(0.3);
        make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(0.3);
        
    }];
}

@end

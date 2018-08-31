//
//  NRNumpadKeyView.m
//  NumpadRemap
//
//  Created by David Belford on 3/17/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadKeyView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NRNumpadKeyView ()

@property (nonatomic, assign) BOOL canDrag;

@end

@implementation NRNumpadKeyView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code here.
    self.translatesAutoresizingMaskIntoConstraints = NO;
    //        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.layer.backgroundColor = [NSColor colorWithWhite:0.95 alpha:1].CGColor;
    self.iconImageView = [[NSImageView alloc] initWithFrame:self.bounds];
//    self.iconImageView.translatesAutoresizingMaskIntoConstraints = YES;
//    self.iconImageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//    self.iconImageView.autoresizesSubviews = YES;
//    [self setContentCompressionResistancePriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationHorizontal];
//    [self setContentCompressionResistancePriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationVertical];
    self.iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [self.iconImageView setContentCompressionResistancePriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.iconImageView setContentCompressionResistancePriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationVertical];
    
//    [self.iconImageView setImageFrameStyle:NSImageFrameNone];
//    [self.iconImageView setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationHorizontal ];
//    [self.iconImageView setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationVertical ];
//            self.iconImageView.contentMode = NSLayoutPriorityFittingSizeCompression;
    
    //        self.layer.borderWidth = 1;
    self.layer.borderColor = [NSColor grayColor].CGColor;
    self.layer.cornerRadius = 7;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowColor = [NSColor colorWithWhite:0.97 alpha:1].CGColor;
    
    
    self.keyLabel = [[BTRLabel alloc] initWithFrame:self.bounds];
    self.keyLabel.stringValue = @"Key Label Work";
    //        self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.keyLabel.font = [NSFont systemFontOfSize:16.0];
    self.keyLabel.textColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
    self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_iconImageView];
    [self addSubview:_keyLabel];
    
    
//    self.iconImageView.size
    
    //        [self addList]
    
    [self registerForDraggedTypes: @[NSPasteboardTypeString]];
    
    //        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.edges.equalTo(self).with.insets(NSEdgeInsetsMake(10, 10, 10, 10));
    //        }];
    
    self.canDrag = NO;
    self.needsUpdateConstraints = YES;
    
    @weakify(self);
    [RACObserve(self, viewModel.hideNumpadNumbers) subscribeNext:^(NSNumber *hide) {
      @strongify(self);
      [self setNeedsUpdateConstraints:YES];
    }];
    [RACObserve(self, viewModel) subscribeNext:^(id _) {
      @strongify(self);
      [self bindModel];
    }];
  }
  return self;
}

- (void)bindModel {
  if (self.viewModel) {
    self.iconImageView.image = self.viewModel.image;
    self.keyLabel.stringValue = self.viewModel.keyName;
    self.identifier = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewModel.shortcut.keyCode];
    [self setNeedsUpdateConstraints:YES];
  } else {
    [self setNeedsUpdateConstraints:YES];
  }
}

- (NSEdgeInsets)alignmentRectInsets {
  return NSEdgeInsetsMake(-4, -4, -4, -4);
}

- (void)dealloc {
  
}

- (void)mouseDown:(NSEvent *)event {
  [super mouseDown:event];
  self.canDrag = YES;
}

- (void)mouseDragged:(NSEvent *)event {
  //  [super mouseDragged:event];
  if (self.canDrag) {
    //  NSPasteboardItem *pbItem = [[NSPasteboardItem alloc] init];
    //  pbItem setDataProvider:self forTypes:@[NSPasteboardTypeString, NSPaste]
    NSDraggingItem *item = [[NSDraggingItem alloc] initWithPasteboardWriter:self.keyLabel.stringValue];
    //  item.draggingFrame =
    NSData *iconData = [self dataWithPDFInsideRect:self.bounds];
    NSImage *image = [[NSImage alloc] initWithData:iconData];
    //  NSImage *image = [self.iconImageView.image]
    //  [self iconImage]
    [item setDraggingFrame:self.bounds contents:image];
    //  item setP
    //  item.
    //  item.imageComponentsProvider = @[[[NSDraggingImageComponent alloc] init]
    
    [self beginDraggingSessionWithItems:@[item]
                                  event:event
                                 source:self];
  }
  
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  
  if (highlighted) {
    self.btr_backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
  } else {
    self.btr_backgroundColor = [NSColor colorWithWhite:0.95 alpha:1];
    //        self.btr_backgroundColor = nil;
  }
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  if (selected) {
    self.btr_backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
  } else {
    self.btr_backgroundColor = [NSColor colorWithWhite:0.95 alpha:1];
    //        self.btr_backgroundColor = nil;
  }
}

- (void)configureView {
  
  //    self.needsUpdateConstraints = YES;
  
}

// TODO: Figure out why deleteing intrinsicContentSize breaks window resizing!

//- (CGSize)intrinsicContentSize {
//    return CGSizeMake(32, 32);
//}

- (void)updateConstraints {
  [super updateConstraints];
  [self addConstraintsV2];
}


- (void)addConstraintsV2 {
  
  if (self.viewModel.hideNumpadNumbers) {
    self.keyLabel.hidden = YES;
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self).insets(NSEdgeInsetsMake(11, 11, 11, 11));
    }];
  } else {
    self.keyLabel.hidden = NO;
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self).insets(NSEdgeInsetsMake(18, 11, 11, 18));
//      make.edges.lessThanOrEqualTo(self).insets(NSEdgeInsetsMake(18, 11, 11, 18));
    }];
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
      
      make.top.equalTo(self.mas_top).offset(7);
      make.right.equalTo(self.mas_right).offset(-7);
//      make.height.lessThanOrEqualTo(self.mas_height).multipliedBy(0.3);
//      make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(0.3);
      
    }];
  }
}

// MARK: Dragging Source

- (NSDraggingSession *)beginDraggingSessionWithItems:(NSArray<NSDraggingItem *> *)items event:(NSEvent *)event source:(id<NSDraggingSource>)source {
  NSLog(@"Begginning dragging");
  NSDraggingSession *session = [super beginDraggingSessionWithItems:items event:event source:source];
  
  self.highlighted = NO;
  
  //  session
  //  [session.draggingPasteboard setData:[self.keyLabel.stringValue dataUsingEncoding:NSUTF8StringEncoding] forType:NSPasteboardTypeString];
  self.canDrag = NO;
  return session;
}

- (NSDragOperation)draggingSession:(nonnull NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
  NSLog(@"Try dragging %@ %ld", session, (long)context);
  switch (context) {
    case NSDraggingContextWithinApplication :
      return NSDragOperationMove;
    default:
      return NSDragOperationNone;
  }
}



//- (nullable id)animationForKey:(nonnull NSAnimatablePropertyKey)key {
//  <#code#>
//}
//
//- (nonnull instancetype)animator {
//  <#code#>
//}
//
//+ (nullable id)defaultAnimationForKey:(nonnull NSAnimatablePropertyKey)key {
//  <#code#>
//}
//
//- (NSRect)accessibilityFrame {
//  <#code#>
//}
//
//- (nullable id)accessibilityParent {
//  <#code#>
//}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//  <#code#>
//}

// MAKR: Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSStringPboardType] ) {
    if (sourceDragMask & NSDragOperationMove) {
      return NSDragOperationMove;
    }
  }
  return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSPasteboardTypeString] ) {
    // Only a copy operation allowed so just copy the data
    NSString *string = [[NSString alloc] initWithData:[pboard dataForType:NSPasteboardTypeString] encoding:NSUTF8StringEncoding];
    NSLog(string);
    return YES;
  }
  return NO;
}

@end

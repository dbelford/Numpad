//
//  NRNumpadKeyView.m
//  NumpadRemap
//
//  Created by David Belford on 3/17/14.
//  Copyright (c) 2014 David Belford. All rights reserved.
//

#import "NRNumpadKeyView.h"
#import <Masonry/Masonry.h>

@interface NRNumpadKeyView ()

@property (nonatomic, assign) BOOL canDrag;

@end

@implementation NRNumpadKeyView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
          self.layer.backgroundColor = [NSColor colorWithWhite:0.95 alpha:1].CGColor;
        self.iconImageView = [[NSImageView alloc] initWithFrame:frame];
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
//        self.iconImageView.contentMode = BTRViewContentModeScaleAspectFit;
        
//        self.layer.borderWidth = 1;
        self.layer.borderColor = [NSColor grayColor].CGColor;
        self.layer.cornerRadius = 7;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowColor = [NSColor colorWithWhite:0.97 alpha:1].CGColor;
        self.keyLabel = [[BTRLabel alloc] initWithFrame:frame];
        self.keyLabel.stringValue = @"Key Label Work";
//        self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.keyLabel.font = [NSFont systemFontOfSize:16.0];
        self.keyLabel.textColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
        
        [self addSubview:_iconImageView];
        [self addSubview:_keyLabel];
      
//        [self addList]
      
        [self registerForDraggedTypes: @[NSPasteboardTypeString]];
      
//        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).with.insets(NSEdgeInsetsMake(10, 10, 10, 10));
//        }];

        self.canDrag = NO;
        self.needsUpdateConstraints = YES;
    }
    return self;
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
//    return CGSizeMake(60, 60);
//}

- (void)updateConstraints {
    [super updateConstraints];
    [self constraintsV2];
}


- (void)constraintsV2 {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.top.equalTo(self.iconImageView.mas_bottom);
//      make.top.equalTo(self.icon)
//      make.trailing.equalTo(self.mas_trailing);
//      make.left.equalTo(self.iconImageView.mas_right);
//      make.center.equalTo(self);
//      make.centerX.equalTo(self.mas_centerX).with.priorityLow();
//      make.centerY.equalTo(self.mas_centerY).with.priorityLow();
//      make.size.greaterThanOrEqualTo(self).multipliedBy(.8);
//      make.size.lessThanOrEqualTo(self).multipliedBy(.9);
//      make.size.equalTo(self).multipliedBy(.8);
      //.priority(MASLayoutPriorityFittingSizeCompression);
      
//        make.edges.equalTo(self).multipliedBy(.7);
        make.edges.equalTo(self).insets(NSEdgeInsetsMake(7, 7, 7, 7));
      
    }];
  
  
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.lessThanOrEqualTo(self.mas_height).multipliedBy(0.3);
        make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(0.3);
        
    }];
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

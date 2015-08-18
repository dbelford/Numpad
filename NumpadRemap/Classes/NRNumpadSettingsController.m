//
//  NRNumpadSettingsController.m
//  
//
//  Created by David Belford on 3/16/14.
//
//

#import "NRNumpadSettingsController.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <MASShortcut/MASShortcut.h>
#import <MASShortcut/MASShortcutView.h>
#import <Masonry/Masonry.h>
#import "NRNumpadShortcutModel.h"
#import "NRNumpadKeyView.h"
#import "NRNumpadPreferencesView.h"
#import <DABActiveApplications/DABActiveApplications.h>
#import <Carbon/Carbon.h>

@interface NRNumpadSettingsController ()

@property (nonatomic, strong) DABActiveApplicationsMonitor *monitor;

@end

@implementation NRNumpadSettingsController

- (id)init {
    
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self setupObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupObject];
    }

    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {

    
    int keypadNum = theEvent.keyCode - kVK_ANSI_Keypad0;
    
//    int num = theEvent.keyCode - kVK_ANSI_0;
    
    if (keypadNum >= 0 && keypadNum < 10) {
        [self.numpadModel launchApplicationAtIndex:keypadNum];
    } else if (theEvent.keyCode >= kVK_ANSI_1 && theEvent.keyCode <= kVK_ANSI_0) {
        if (theEvent.keyCode == kVK_ANSI_Minus || theEvent.keyCode == kVK_ANSI_Equal) {
            [super keyDown:theEvent];
            return;
        }
        
        [self.numpadModel launchApplicationAtIndex:theEvent.characters.integerValue];
        
    } else {
        [super keyDown:theEvent];
    }
    
    
}

- (void)setupObject {
//    self.numpadModel = [[NRNumpadModel alloc] init];
//    NRNumpadViewModel *vm = [[NRNumpadViewModel alloc] init];
//    vm.model = self.numpadModel;
//    self.numpadView.viewModel = vm;
    
//    self.monitor = [[DABActiveApplicationsMonitor alloc] init];
//    [self updateRunningApps];
}

- (void)updateRunningApps {
    
    [self.monitor updateApplicationData];
    
//    [self.monitor orderedApps];
    
//    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
    NSArray *runningApps = self.monitor.orderedRunningApplications;
    
    runningApps = [runningApps reject:^ BOOL (NSRunningApplication *app){
        
        return app.activationPolicy != NSApplicationActivationPolicyRegular;
        
    }];
    NSLog(@"The running apps: %@", runningApps);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    __block int i = 0;
    [self configurePreferencePane];
//    [self configureKeyViews];
    [self configureConstraints];
    
    self.numpadModel = [[NRNumpadModel alloc] init];
    NRNumpadViewModel *vm = [[NRNumpadViewModel alloc] init];
    vm.model = self.numpadModel;
    self.numpadView.viewModel = vm;
    
    [self.numpadView.viewModel.keyPressedSignal subscribeNext:^(NSNumber *keypadNum) {
        [self.numpadModel launchApplicationAtIndex:keypadNum.integerValue];
    }];
}

- (void)configurePreferencePane {
    NSArray *topLevel;
    [[NSBundle mainBundle] loadNibNamed:@"NRNumpadPreferencesView" owner:nil topLevelObjects:&topLevel];
    self.prefView = [topLevel reject:^BOOL(id obj) {
        return ![obj isKindOfClass:[NRNumpadPreferencesView class]];
    }].firstObject;
    
    [self.view addSubview:self.prefView];

}

- (void)configureKeyViews {
//    [self.numpadModel update];
//    NSArray *keyOrder = @[@(kVK_ANSI_Keypad7),
//                          @(kVK_ANSI_Keypad8),
//                          @(kVK_ANSI_Keypad9),
//                          @(kVK_ANSI_Keypad4),
//                          @(kVK_ANSI_Keypad5),
//                          @(kVK_ANSI_Keypad6),
//                          @(kVK_ANSI_Keypad1),
//                          @(kVK_ANSI_Keypad2),
//                          @(kVK_ANSI_Keypad3),
//                          @(kVK_ANSI_Keypad0)
//                          ];
//    self.numpadView.keyViews = [self.numpadModel.numpadKeys map:^ NSView* (NSNumber *key, NRNumpadShortcutModel *shortcut){
//        NRNumpadKeyView *view = [[NRNumpadKeyView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)];
//        view.iconImageView.image = shortcut.image;
//        view.keyLabel.stringValue = shortcut.keyCodeString;
//        view.identifier = key.stringValue;
//        
//        return view;
//    }];
//    
//    self.numpadView.keyViews = [self.numpadView.keyViews sortedArrayWithOptions:0 usingComparator:^NSComparisonResult (NRNumpadKeyView *view1, NRNumpadKeyView *view2) {
//        NSInteger v1 = view1.identifier.integerValue;
//        NSInteger v2 = view2.identifier.integerValue;
//        
//        NSUInteger v1Ordered = [keyOrder indexOfObject:@(v1)];
//        NSUInteger v2Ordered = [keyOrder indexOfObject:@(v2)];
//        
//        return v1Ordered < v2Ordered ? NSOrderedAscending : NSOrderedDescending;
//    }];
}

- (void)configureConstraints {
    [self.numpadView.superview removeConstraints:self.numpadView.superview.constraints];
    //    [self.numpadView.superview removeConstraints:self.numpadView.constraints];
    
    [self.prefView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.lessThanOrEqualTo(self.view.mas_height);
        make.right.equalTo(self.numpadView.mas_left);
        make.width.greaterThanOrEqualTo(@200);
        
    }];
    
    [self.numpadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numpadView.superview.mas_top).offset(10);
        make.bottom.equalTo(self.numpadView.superview.mas_bottom).offset(-10);
        make.right.equalTo(self.numpadView.superview.mas_right).offset(-10);
        make.left.greaterThanOrEqualTo(self.prefView.mas_right).offset(10);
        make.height.equalTo(self.numpadView.superview.mas_height).offset(-20);
    }];
}

- (void)loadView {
    [super loadView];
    
    self.nextResponder = self.numpadView.nextResponder;
    self.numpadView.nextResponder = self;
    
    [self updateRunningApps];
    
}

@end

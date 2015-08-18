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

#pragma mark - Init Methods

- (id)init {
    
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }

    return self;
}

#pragma mark - Responding to Key Presses

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

#pragma mark - Configure Controller

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configurePreferencePane];
    [self configureConstraints];
    
    self.numpadModel = [[NRNumpadModel alloc] init];
    NRNumpadViewModel *vm = [[NRNumpadViewModel alloc] init];
    vm.model = self.numpadModel;
    self.numpadView.viewModel = vm;
    
    [self.numpadView.viewModel.keyPressedSignal subscribeNext:^(NSNumber *keypadNum) {
        [self.numpadModel launchApplicationAtIndex:keypadNum.integerValue];
    }];
}

- (void)loadView {
    [super loadView];
    
    self.nextResponder = self.numpadView.nextResponder;
    self.numpadView.nextResponder = self;
    
}

- (void)configurePreferencePane {
    NSArray *topLevel;
    [[NSBundle mainBundle] loadNibNamed:@"NRNumpadPreferencesView" owner:nil topLevelObjects:&topLevel];
    self.prefView = [topLevel reject:^BOOL(id obj) {
        return ![obj isKindOfClass:[NRNumpadPreferencesView class]];
    }].firstObject;
    
    [self.view addSubview:self.prefView];

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


@end

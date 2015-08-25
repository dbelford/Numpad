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
#import <FontAwesomeIconFactory/FontAwesomeIconFactory.h>
#import "NRWindowContentView.h"


static NRNumpadKeyOrdering kCurrentOrdering = NRNumpadKeyOrderingNumeric;

@interface NRNumpadSettingsController ()

@property (nonatomic, strong) DABActiveApplicationsMonitor *monitor;
@property (nonatomic, strong) NSArray *appList;

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

    
//    int keypadNum = theEvent.keyCode - kVK_ANSI_Keypad0;
    
//    int num = theEvent.keyCode - kVK_ANSI_0;
    
    NRNumpadKeyOrdering order = kCurrentOrdering;
    
    NSInteger appIndex = [NRNumpadModel indexForKeyCode:theEvent.keyCode usingOrdering:order];
    
    if (appIndex != NSNotFound) {
        [self.numpadModel launchApplicationAtIndex:appIndex];
    } else if (theEvent.keyCode) {
        [super keyDown:theEvent];
    }
    
    
//    [NSWorkspace sharedWorkspace] launch
    
    // TODO: Handle files not in NSApplicationDirectory, or nested more deeply like Utilities/Terminal etc
    

    
    
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
        
        int arr[10] = {7, 8, 9, 4, 5, 6, 1, 2, 3, 0};

        NSInteger i = kCurrentOrdering == NRNumpadKeyOrderingNumeric ? arr[keypadNum.intValue] : keypadNum.integerValue;
        
        [self.numpadModel launchApplicationAtIndex:i];
    }];
}

- (void)loadView {
    [super loadView];
    
    self.nextResponder = self.numpadView.nextResponder;
    self.numpadView.nextResponder = self;
    
    [self loadApplist];
//    NIKFontAwesomeButton *b = [NIKFontAwesomeButton

    
}

- (void)loadApplist {
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSLocalDomainMask];
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:[urls objectAtIndex:0]
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    if (array == nil) {
        // Handle the error
    }
    
    self.appList = array;
    
}

- (void)configurePreferencePane {
    NSArray *topLevel;
    [[NSBundle mainBundle] loadNibNamed:@"NRNumpadPreferencesView" owner:nil topLevelObjects:&topLevel];
    self.prefView = [topLevel reject:^BOOL(id obj) {
        return ![obj isKindOfClass:[NRNumpadPreferencesView class]];
    }].firstObject;
    
    [self.view addSubview:self.prefView];

    
    
    NSButton *prefButton = ((NRWindowContentView *)self.numpadView.superview).settingsButton;
    NSMenu *m = [[NSMenu alloc] initWithTitle:@"Actions"];
    NSMenuItem *i = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(tryQuit:) keyEquivalent:@"q"];
//    i.keyEquivalentModifierMask = nil;
//    [m addItemWithTitle:@"Quit" action: keyEquivalent:@"Q"];
    
    NSMenuItem *i2 = [[NSMenuItem alloc] initWithTitle:@"About" action:@selector(tryAbout:) keyEquivalent:@","];
    NSMenuItem *i3 = [[NSMenuItem alloc] initWithTitle:@"Todos" action:@selector(tryTodos:) keyEquivalent:@"t"];
    
    [m addItem:i2];
    [m addItem:i3];
    [m addItem:[NSMenuItem separatorItem]];
    [m addItem:i];
    
    

    prefButton.menu = m;
    prefButton.action = @selector(showMenu:);
    prefButton.target = self;

//    [prefButton addTarget:self action:@selector(showMenu:) forControlEvents:BTRControlEventMouseDownInside];
}



- (void)showMenu:(NSButton *)sender {
    
    [NSMenu popUpContextMenu:sender.menu withEvent:[[NSApplication sharedApplication] currentEvent] forView:sender];
//    sender.menu pop
    
}

- (void)tryTodos:(NSMenuItem *)sender {
    [[NSWorkspace sharedWorkspace] openFile:@"/Users/dbelford/Projects/osx.launchpad-remap/TODO.txt" withApplication:@"todo-txt"];
}

- (void)tryQuit:(NSMenuItem *)sender {
    [[NSRunningApplication currentApplication] terminate];
}

- (void)tryAbout:(NSMenuItem *)sender {
    
}

- (void)configureConstraints {
    [self.numpadView.superview removeConstraints:self.numpadView.superview.constraints];
    
    NSButton *prefButton = ((NRWindowContentView *)self.numpadView.superview).settingsButton;
    
    [prefButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numpadView.superview).offset(-20);
        make.bottom.equalTo(self.numpadView.superview).offset(-20);
    }];
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

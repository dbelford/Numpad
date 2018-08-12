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
//#import "NRAppDelegate.h"



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
    if (![self handleNumpadKeypress:theEvent.keyCode]) {
        [super keyDown:theEvent];
    }
}

- (BOOL)handleNumpadKeypress:(NSUInteger)keyCode {
    NRNumpadKeyOrdering order = [NRPreferences sharedInstance].keyOrdering;
    
    NSInteger appIndex = [NRNumpadModel indexForKeyCode:keyCode usingOrdering:order];
    if (appIndex != NSNotFound) {
        [self.numpadModel launchApplicationAtIndex:appIndex];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Configure Controller

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configurePreferencePane];
    [self configureConstraints];
    
    [self.prefView removeFromSuperview];
    
    self.numpadModel = [[NRNumpadModel alloc] init];
    NRNumpadViewModel *vm = [[NRNumpadViewModel alloc] init];
    vm.model = self.numpadModel;
    self.numpadView.viewModel = vm;
    
    @weakify(self);
    [self.numpadView.viewModel.keycodeActivatedSignal subscribeNext:^(NSNumber *keyCode) {
        @strongify(self);
        [self handleNumpadKeypress:keyCode.integerValue];
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
    
    NSMenuItem *i2 = [[NSMenuItem alloc] initWithTitle:@"About" action:@selector(tryAbout:) keyEquivalent:@""];
    NSMenuItem *pref = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(tryPreferences:) keyEquivalent:@","];
    NSMenuItem *i3 = [[NSMenuItem alloc] initWithTitle:@"Todos" action:@selector(tryTodos:) keyEquivalent:@"t"];
    
    [m addItem:i2];
    [m addItem:pref];
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
    [[NSWorkspace sharedWorkspace] openFile:@"/Users/dbelford/Projects/osx.launchpad-remap/TODO.txt" withApplication:@"Sublime Text 3.app"];
}

- (void)tryQuit:(NSMenuItem *)sender {
    [[NSRunningApplication currentApplication] terminate];
}

- (void)tryAbout:(NSMenuItem *)sender {
    
}

- (void)tryPreferences:(NSMenuItem *)sender {
    [self.view doCommandBySelector:@selector(showPreferencesWindow:)];
}

- (void)configureConstraints {
    [self.numpadView.superview removeConstraints:self.numpadView.superview.constraints];
    
    NSButton *prefButton = ((NRWindowContentView *)self.numpadView.superview).settingsButton;
    
    [prefButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numpadView.superview).offset(-20);
        make.bottom.equalTo(self.numpadView.superview).offset(-20);
    }];

    [self.numpadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(NSEdgeInsetsMake(7, 7, 7, 7));
    }];
}


@end

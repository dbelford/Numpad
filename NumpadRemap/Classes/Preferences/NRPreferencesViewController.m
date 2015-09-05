//
//  NRPreferencesViewController.m
//  NumpadRemap
//
//  Created by David Belford on 9/4/15.
//  Copyright (c) 2015 David Belford. All rights reserved.
//

#import "NRPreferencesViewController.h"

@interface NRPreferencesViewController ()

@end

@implementation NRPreferencesViewController

- (id)init {
    return [self initWithNibName:NSStringFromClass(self.class)
                          bundle:nil];
}

- (NRPreferences *)preferences {
    return [NRPreferences sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (IBAction)restoreDefaults:(id)sender {
    [self.preferences resetPreferences];
}

@end

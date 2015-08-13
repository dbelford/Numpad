//
//  NRNumpadSettingsController.h
//  
//
//  Created by David Belford on 3/16/14.
//
//

#import <Cocoa/Cocoa.h>
#import "NRNumpadModel.h"
#import "NRNumpadView.h"
#import "NRNumpadPreferencesView.h"

@interface NRNumpadSettingsController : NSViewController

@property (nonatomic, strong) NRNumpadModel *numpadModel;
@property (nonatomic, strong) IBOutlet NRNumpadView *numpadView;
@property (nonatomic, strong) NRNumpadPreferencesView *prefView;

@end

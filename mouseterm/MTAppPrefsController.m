#import <Cocoa/Cocoa.h>
#import "MouseTerm.h"
#import "MTAppPrefsController.h"
#import "Terminal.h"

@implementation NSWindowController (MTAppPrefsController)

- (void) MouseTerm_windowDidLoad
{
    [self MouseTerm_windowDidLoad];

    NSView* settingsView = [[[self valueForKey: @"tabView"]
                                tabViewItemAtIndex: 1] view];
    NSTabView* tabView = [[settingsView subviews] objectAtIndex: 0];
    NSView* keyboardView = [[tabView tabViewItemAtIndex: 3] view];

    NSButton* button = [[NSButton alloc] init];
    [button setBezelStyle: NSRoundedBezelStyle];
    [[button cell] setControlSize: NSSmallControlSize];
    // FIXME: Localize this string
    [button setTitle: @"Mouse\u2026"];
    [button setFont: [NSFont systemFontOfSize: 11]];
    [button sizeToFit];
    [button setTarget: [MouseTerm sharedInstance]];
    [button setAction: @selector(orderFrontMouseConfiguration:)];
    // FIXME: Set the position relative to the checkbox above it
    [button setFrameOrigin: NSMakePoint(11, 3)];
    [keyboardView addSubview: button];
    [button release];
}

@end

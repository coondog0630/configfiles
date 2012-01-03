#import <Cocoa/Cocoa.h>
#import <objc/objc-class.h>
#import "JRSwizzle.h"
#import "MouseTerm.h"
#import "MTView.h"
#import "Terminal.h"

NSMutableDictionary* MouseTerm_ivars = nil;

@implementation MouseTerm

#define EXISTS(cls, sel)                                                 \
    do {                                                                 \
        if (!class_getInstanceMethod(cls, sel))                          \
        {                                                                \
            NSLog(@"[MouseTerm] ERROR: Got nil Method for [%@ %@]", cls, \
                  NSStringFromSelector(sel));                            \
            return;                                                      \
        }                                                                \
    } while (0)

#define SWIZZLE(cls, sel1, sel2)                                        \
    do {                                                                \
        NSError *err = nil;                                             \
        if (![cls jr_swizzleMethod: sel1 withMethod: sel2 error: &err]) \
        {                                                               \
            NSLog(@"[MouseTerm] ERROR: Failed to swizzle [%@ %@]: %@",  \
                  cls, NSStringFromSelector(sel1), err);                \
            return;                                                     \
        }                                                               \
    } while (0)

+ (void) load
{
    Class controller = NSClassFromString(@"TTTabController");
    if (!controller)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTTabController");
        return;
    }

    EXISTS(controller, @selector(shellDidReceiveData:));

    Class logicalScreen = NSClassFromString(@"TTLogicalScreen");
    if (!logicalScreen)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTLogicalScreen");
        return;
    }

    EXISTS(logicalScreen, @selector(isAlternateScreenActive));

    Class shell = NSClassFromString(@"TTShell");
    if (!shell)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTShell");
        return;
    }

    EXISTS(shell, @selector(writeData:));
    EXISTS(shell, @selector(dealloc));

    Class view = NSClassFromString(@"TTView");
    if (!view)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTView");
        return;
    }

    EXISTS(view, @selector(scrollWheel:));
    EXISTS(view, @selector(rowCount));
    EXISTS(view, @selector(controller));
    EXISTS(view, @selector(logicalScreen));

    Class prefs = NSClassFromString(@"TTAppPrefsController");
    if (!prefs)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTAppPrefsController");
        return;
    }

    EXISTS(prefs, @selector(windowDidLoad));

    Class profile = NSClassFromString(@"TTProfile");
    if (!profile)
    {
        NSLog(@"[MouseTerm] ERROR: Got nil Class for TTProfile");
        return;
    }

    EXISTS(profile, @selector(valueForKey:));
    EXISTS(profile, @selector(setValue:forKey:));
    EXISTS(profile, @selector(propertyListRepresentation));

    // Initialize instance vars before any swizzling so nothing bad happens
    // if some methods are swizzled but not others.
    MouseTerm_ivars = [[NSMutableDictionary alloc] init];

    SWIZZLE(shell, @selector(dealloc), @selector(MouseTerm_dealloc));
    SWIZZLE(shell, @selector(writeData:), @selector(MouseTerm_writeData:));
    SWIZZLE(view, @selector(scrollWheel:), @selector(MouseTerm_scrollWheel:));
    SWIZZLE(view, @selector(mouseDown:), @selector(MouseTerm_mouseDown:));
    SWIZZLE(view, @selector(mouseDragged:),
            @selector(MouseTerm_mouseDragged:));
    SWIZZLE(view, @selector(mouseUp:), @selector(MouseTerm_mouseUp:));
    SWIZZLE(view, @selector(rightMouseDown:),
            @selector(MouseTerm_rightMouseDown:));
    SWIZZLE(view, @selector(rightMouseDragged:),
            @selector(MouseTerm_rightMouseDragged:));
    SWIZZLE(view, @selector(rightMouseUp:),
            @selector(MouseTerm_rightMouseUp:));
    SWIZZLE(view, @selector(otherMouseDown:),
            @selector(MouseTerm_otherMouseDown:));
    SWIZZLE(view, @selector(otherMouseDragged:),
            @selector(MouseTerm_otherMouseDragged:));
    SWIZZLE(view, @selector(otherMouseUp:),
            @selector(MouseTerm_otherMouseUp:));
    SWIZZLE(controller, @selector(shellDidReceiveData:),
            @selector(MouseTerm_shellDidReceiveData:));
    SWIZZLE(prefs, @selector(windowDidLoad),
            @selector(MouseTerm_windowDidLoad));
    SWIZZLE(profile, @selector(valueForKey:),
            @selector(MouseTerm_valueForKey:));
    SWIZZLE(profile, @selector(setValue:forKey:),
            @selector(MouseTerm_setValue:forKey:));
    SWIZZLE(profile, @selector(propertyListRepresentation),
            @selector(MouseTerm_propertyListRepresentation));

    [self insertMenuItem];
}

+ (IBAction) toggle: (NSMenuItem*) sender
{
    [sender setState: ![sender state]];
    [NSView MouseTerm_setEnabled: [sender state]];
}

+ (void) insertMenuItem;
{
    NSMenu* shellMenu = [[[NSApp mainMenu] itemAtIndex: 1] submenu];
    if (!shellMenu)
    {
        NSLog(@"[MouseTerm] ERROR: Shell menu not found");
        return;
    }

    [shellMenu addItem: [NSMenuItem separatorItem]];
    NSBundle *bundle = [NSBundle bundleForClass: self];
    NSString* t = NSLocalizedStringFromTableInBundle(@"Send Mouse Events", nil,
                                                     bundle, nil);
    NSMenuItem* item = [shellMenu addItemWithTitle: t
                                            action: @selector(toggle:)
                                     keyEquivalent: @"m"];
    if (!item)
    {
        NSLog(@"[MouseTerm] ERROR: Unable to create menu item");
        return;
    }

    [item setKeyEquivalentModifierMask: (NSShiftKeyMask | NSCommandKeyMask)];
    [item setTarget: self];
    [item setState: NSOnState];
    [item setEnabled: YES];
}

+ (MouseTerm*) sharedInstance
{
    static MouseTerm* plugin = nil;
    if (!plugin)
        plugin = [[MouseTerm alloc] init];

    return plugin;
}

- (void) orderFrontMouseConfiguration: (id) sender
{
    if (![self window] &&
        ![NSBundle loadNibNamed: @"Configuration" owner: self])
    {
        NSLog(@"[MouseTerm] ERROR: Failed to load Configuration.nib");
        return;
    }

    [NSApp beginSheet: [self window] modalForWindow: [sender window]
        modalDelegate: nil didEndSelector: nil contextInfo: nil];
}

- (IBAction) orderOutConfiguration: (id) sender
{
    [NSApp endSheet: [sender window]];
    [[sender window] orderOut: self];
}

- (TTProfileArrayController*) profilesController
{
    Class cls = NSClassFromString(@"TTAppPrefsController");
    TTProfileArrayController* controller = [[cls sharedPreferencesController]
                                               profilesController];
    return controller;
}

// Deletes instance variables dictionary
- (BOOL) unload
{
    if (MouseTerm_ivars)
    {
        [MouseTerm_ivars release];
        MouseTerm_ivars = nil;
    }

    return YES;
}

@end

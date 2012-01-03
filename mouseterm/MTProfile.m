#import <Cocoa/Cocoa.h>
#import "Mouse.h"
#import "MTProfile.h"

@implementation NSObject (MTProfile)

static NSString* mouseKeys[] = {
    @"mouseLeftClick",
    @"mouseMiddleClick",
    @"mouseRightClick",
    @"mouseWheel",
    @"mouseWheelEmulation",
};

- (BOOL) MouseTerm_buttonEnabled: (MouseButton) button
{
    NSString* key;

    switch (button)
    {
    case MOUSE_BUTTON1:
        key = @"mouseLeftClick";
        break;
    case MOUSE_BUTTON3:
        key = @"mouseMiddleClick";
        break;
    case MOUSE_BUTTON2:
        key = @"mouseRightClick";
        break;
    case MOUSE_WHEEL_UP:
    case MOUSE_WHEEL_DOWN:
        key = @"mouseWheel";
        break;
    default:
        return YES;
    }

    return [[self MouseTerm_mouseValueForKey: key] boolValue];
}

- (BOOL) MouseTerm_emulationEnabled
{
    return [[self MouseTerm_mouseValueForKey: @"mouseWheelEmulation"]
               boolValue];
}

- (id) MouseTerm_mouseValueForKey: (NSString*) key
{
    NSMutableDictionary* values = [self valueForKey: @"values"];
    id value = [values objectForKey: key];

    if ([value isKindOfClass: [NSData class]])
    {
        [self MouseTerm_setMouseValue:
                  [NSUnarchiver unarchiveObjectWithData: value]
                               forKey: key];
        value = [self MouseTerm_mouseValueForKey: key];
    }

    if (value == nil)
        value = [NSNumber numberWithBool: YES];

    return value;
}

- (void) MouseTerm_setMouseValue: (id) value forKey: (NSString*) key
{
    NSMutableDictionary* values = [self valueForKey: @"values"];
    [values setObject: value forKey: key];

    // Terrible hack to trigger preferences saving
    id cursorType = [values objectForKey: @"CursorType"];
    [self setValue: [NSNumber numberWithInt:-1] forKey: @"CursorType"];
    [self setValue: cursorType forKey: @"CursorType"];
}

- (id) MouseTerm_valueForKey: (NSString*) key
{
    if ([key hasPrefix: @"mouse"])
        return [self MouseTerm_mouseValueForKey: key];

    return [self MouseTerm_valueForKey: key];
}

- (void) MouseTerm_setValue: (id) value forKey: (NSString*) key
{
    if ([key hasPrefix: @"mouse"])
        return [self MouseTerm_setMouseValue: value forKey: key];

    return [self MouseTerm_setValue: value forKey: key];
}

- (id) MouseTerm_propertyListRepresentation
{
    size_t i;
    NSMutableDictionary* plist = [[self MouseTerm_propertyListRepresentation]
                                     mutableCopy];

    for (i = 0; i < sizeof(mouseKeys) / sizeof(mouseKeys[0]); ++i)
    {
        NSString* key = mouseKeys[i];
        id value = [self MouseTerm_mouseValueForKey: key];
        if (value)
            [plist setObject: [NSArchiver archivedDataWithRootObject: value]
                      forKey: key];
    }

    return [plist autorelease];
}

@end

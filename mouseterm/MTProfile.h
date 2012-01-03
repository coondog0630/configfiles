#import <Cocoa/Cocoa.h>
#import "Mouse.h"

@interface NSObject (MTProfile)
- (BOOL) MouseTerm_buttonEnabled: (MouseButton) button;
- (BOOL) MouseTerm_emulationEnabled;
- (id) MouseTerm_mouseValueForKey: (NSString*) key;
- (void) MouseTerm_setMouseValue: (id) value forKey: (NSString*) key;
- (id) MouseTerm_valueForKey: (NSString*) key;
- (void) MouseTerm_setValue: (id) value forKey: (NSString*) key;
- (id) MouseTerm_propertyListRepresentation;
@end

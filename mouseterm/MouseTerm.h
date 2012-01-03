#import <Cocoa/Cocoa.h>

extern NSMutableDictionary* MouseTerm_ivars;

@interface MouseTerm: NSWindowController
+ (void) load;
+ (IBAction) toggle: (NSMenuItem*) sender;
+ (void) insertMenuItem;
+ (MouseTerm*) sharedInstance;
- (void) orderFrontMouseConfiguration: (id) sender;
- (IBAction) orderOutConfiguration: (id) sender;
- (id) profilesController;
- (BOOL) unload;
@end

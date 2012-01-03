#import <Cocoa/Cocoa.h>

@class MTParserState;

@interface NSObject (MTShell)
- (NSValue*) MouseTerm_initVars;
- (void) MouseTerm_writeData: (NSData*) data;
- (void) MouseTerm_dealloc;

- (void) MouseTerm_setMouseMode: (int) mouseMode;
- (int) MouseTerm_getMouseMode;

- (void) MouseTerm_setAppCursorMode: (BOOL) appCursorMode;
- (BOOL) MouseTerm_getAppCursorMode;

- (void) MouseTerm_setIsMouseDown: (BOOL) isMouseDown;
- (BOOL) MouseTerm_getIsMouseDown;

- (void) MouseTerm_setParserState: (MTParserState*) parserState;
- (MTParserState*) MouseTerm_getParserState;

@end

#import <Cocoa/Cocoa.h>

@interface MTParserState: NSObject
{
    int currentState;
    int pendingMouseMode;
    BOOL toggleState;
    int lastEscapeIndex;
    BOOL handleSda;
}

@property(nonatomic, assign) int currentState;
@property(nonatomic, assign) int pendingMouseMode;
@property(nonatomic, assign) BOOL toggleState;
@property(nonatomic, assign) int lastEscapeIndex;
@property(nonatomic, assign) BOOL handleSda;

@end

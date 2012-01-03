#import <Cocoa/Cocoa.h>
#import "Mouse.h"
#import "MTParser.h"
#import "MTParserState.h"
#import "MTShell.h"
#import "MTTabController.h"
#import "Terminal.h"

@implementation NSObject (MTTabController)

// Intercepts all shell output to look for mouse reporting control codes
- (void) MouseTerm_shellDidReceiveData: (NSData*) data
{
    NSUInteger length = [data length];
    const char* chars = [data bytes];

    MTParserState* state = [[(TTTabController*) self shell]
                               MouseTerm_getParserState];
    MTParser_execute(chars, length, NO, [(TTTabController*) self shell],
                     state);

    [self MouseTerm_shellDidReceiveData: data];

    if (state.handleSda)
    {
        [(TTShell*) [(TTTabController*) self shell]
            writeData: [NSData dataWithBytes: SDA_RESPONSE
                                      length: SDA_RESPONSE_LEN]];
        // Unset so it's not set the next time
        state.handleSda = NO;
    }
}

@end

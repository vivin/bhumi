#import "RandomBug.h"
#include <stdlib.h>

@implementation RandomBug : Bug <BugProtocol>

- (void) act {

    [super act];

    long rows = [world rows];
    long columns = [world columns];

    do {
        long originalX = x;
        long originalY = y;

        x = arc4random() % columns;
        y = arc4random() % rows;
    } while(![[bug world] moveBug: [bug layer] fromX: originalX fromY: originalY toLayer: [bug layer] toX: [bug x] toY: [bug y]]);
}

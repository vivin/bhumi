#import "RandomBug.h"
#include <stdlib.h>

@implementation RandomBug : Bug <BugProtocol>

- (void) act {

    long rows = [world rows];
    long columns = [world columns];

    x = arc4random() % columns;
    y = arc4random() % rows;
}

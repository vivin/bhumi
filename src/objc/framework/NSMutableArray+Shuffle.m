#import "NSMutableArray+Shuffle.h"
#include <stdlib.h>

@implementation NSMutableArray (Shuffle)

- (void) shuffle {

    NSUInteger count = [self count];
    NSUInteger i = 0;
    for(i = 0; i < count; i++) {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        n = (n < 0) ? n * -1 : n;
        [self exchangeObjectAtIndex: i withObjectAtIndex: n];
    }
}

@end

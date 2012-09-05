#import "NSMutableArray+Shuffle.h"
#include <stdlib.h>
#include <time.h>

@implementation NSMutableArray (Shuffle)

- (void) shuffle {

    srand(time(0));

    NSUInteger count = [self count];
    NSUInteger i = 0;
    for(i = 0; i < count; i++) {
        int nElements = count - i;
        int n = (rand() % nElements) + i;
        n = (n < 0) ? n * -1 : n;
        [self exchangeObjectAtIndex: i withObjectAtIndex: n];
    }
}

@end

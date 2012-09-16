#import "NSMutableArray+Shuffle.h"
#include <stdlib.h>
#include <time.h>

@implementation NSMutableArray (Shuffle)

- (void) shuffle {

    NSUInteger count = [self count];
    for(NSUInteger i = 0; i < count; i++) {
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex: i withObjectAtIndex: n];
    }
}

@end

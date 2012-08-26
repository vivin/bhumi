#import "RandomBug.h"
#import "../framework/World.h"
#include <stdlib.h>

@implementation RandomBug

- (void) act {
    int rows = [world rows];
    int columns = [world columns];

    do {
        x = arc4random() % columns;
        y = arc4random() % rows;

        //arc4random is returning negative numbers for some strange reason
        y = (y < 0) ? y * -1 : y;
        x = (x < 0) ? x * -1 : x;
    } while([world isOccupied: layer x: x y: y]);
}

@end

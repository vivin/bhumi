#import "RandomBug.h"
#import "../framework/World.h"
#include <stdlib.h>
#include <time.h>

@implementation RandomBug

- (void) act {
    srand(time(0));

    int rows = [world rows];
    int columns = [world columns];

    do {
        x = rand() % columns;
        y = rand() % rows;

    } while([world isOccupied: layer x: x y: y]);
}

@end

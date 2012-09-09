#import "RandomBug.h"
#import "../framework/World.h"
#include <stdlib.h>
#include <time.h>

@implementation RandomBug

- (void) act {

    int rows = [world rows];
    int columns = [world columns];

    do {
        int _x = (arc4random() % 3);
        _x = (_x < 0) ? _x * -1 : _x;

        int _y = (arc4random() % 3);
        _y = (_y < 0) ? _y * -1 : _y;

        NSLog(@"%i,%i", _x - 1, _y - 1);


        x += _x - 1;
        y += _y - 1;

        //Straight forward mod doesn't work with negative numbers
        x %= rows; if(x < 0) x += rows;
        y %= columns; if(y < 0) y += columns;

    } while([world isOccupied: layer x: x y: y]);
}

@end

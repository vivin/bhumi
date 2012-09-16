#import "RandomBug.h"
#import "../framework/World.h"

@implementation RandomBug

- (void) act {

    int rows = [self.world rows];
    int columns = [self.world columns];

    do {
        int _x = (arc4random() % 3);
        int _y = (arc4random() % 3);

        NSLog(@"%i,%i", _x - 1, _y - 1);


        self.x += _x - 1;
        self.y += _y - 1;

        //Straight forward mod doesn't work with negative numbers
        self.x %= rows; if(self.x < 0) self.x += rows;
        self.y %= columns; if(self.y < 0) self.y += columns;

    } while([self.world isLocationOccupiedInLayer: self.layer atX: self.x atY: self.y]);
}

@end

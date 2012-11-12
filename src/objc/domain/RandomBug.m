#import "RandomBug.h"
#import "../framework/World.h"

@implementation RandomBug

- (id) init {
    if(self = [super init]) {
        _possibleDirectionDeltas = [[NSMutableArray alloc] init];
        for(NSInteger _x = -1; _x <= 1; _x++) {
            for(NSInteger _y = -1; _y <= 1; _y++) {
                struct FixedPoint possibleDirectionPoint;
                possibleDirectionPoint.x = _x;
                possibleDirectionPoint.y = _y;
                
                [_possibleDirectionDeltas addObject: [NSValue valueWithBytes: &possibleDirectionPoint objCType: @encode(FixedPoint)]];
            }
        }
    }
    
    return self;
}

- (void) act {
    
    [_possibleDirectionDeltas shuffle];
    NSUInteger rows = [self.world rows];
    NSUInteger columns = [self.world columns];
    
    NSUInteger i = 0;
    BOOL found = NO;
    
    do {
        
        NSInteger _x = self.x;
        NSInteger _y = self.y;
        
        struct FixedPoint point;
        [[_possibleDirectionDeltas objectAtIndex: i] getValue: &point];
        
        _x += point.x;
        _y += point.y;
        
        _x %= columns; if(_x < 0) _x += columns;
        _y %= rows; if(_y < 0) _y += rows;
        
        found = ([self.world isLocationOccupiedInLayer: self.layer atX: _x atY: _y] == NO);
        
        if(found) {
            self.x = _x;
            self.y = _y;
        }
        
        i++;
        
    } while(!found && i < [_possibleDirectionDeltas count]);
}

@end

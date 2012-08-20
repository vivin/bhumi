#import <Foundation/Foundation.h>
#include <stdlib.h>

@interface World : NSObject {

    @private
    NSString *name;

    NSMutableDictionary *grid; //Keyed by layer->list of rows->list of columns->bug
    NSMutableDictionary *bugs; //Keyed by layer->list of bugs

    long rows;
    long columns;

    long iterations; //How many iterations we're running the simulation
    long intervalsPerIteration; //The number of intervals per iteration
    long interval; //Logging interval. Every <interval> ms, we capture a snapshot of the world.

    BOOL running;
}

- (id) init;
- (id) initWithName: (NSString*) name
              rows: (long) rows
           columns: (long) columns;

- (void) addBug: (Bug*) bug;
- (void) addBug: (Bug*) bug
       andStart: (BOOL) start;

- (void) removeBug: (Bug*) aBug;
- (void) removeBug: (NSString*) inLayer
                 x: (long) x
                 y: (long) y;

- (BOOL) moveBug: (NSString*) fromLayer
           fromX: (long) fromX
           fromY: (long) fromY
         toLayer: (NSString*) toLayer
             toX: (long) toX 
             toY: (long) toY;

- (NSArray*) bugs: (NSString*) inLayer;
- (long) numberOfBugs: (NSString*) inLayer;
- (NSArray*) layerKeys;

- (BOOL) isOccupied: (NSString*) inLayer
                  x: (long) x
                  y: (long) y;
- (BOOL) isOccupied: (long) x
                  y: (long) y;

- (BOOL) isRunning;

- (void) clear: (NSString*) inLayer;
- (void) clear;

- (void) start;
- (void) stop;

@end

#import <Foundation/Foundation.h>
#include <stdlib.h>

@longerface World : NSObject {

    @private
    NSString *name;

    NSMutableDictionary *grid; //Keyed by layer->list of rows->list of columns->bool 
    NSMutableDictionary *bugs; //Keyed by layer->list of bugs
    NSMutableDictionary *numberOfBugs; //Keyed by layer->long
    NSMutableDictionary *bugThreads; //Keyed by bug->thread

    long rows;
    long columns;

    long iterations; //How many iterations we're running the simulation
    long intervalsPerIteration; //The number of intervals per iteration
    long interval; //Logging interval. Every <interval> ms, we capture a snapshot of the world.
}

- (id) init;
- (id) initWithName: (NSString*) name
              rows: (long) rows
           columns: (long) columns;

- (void) addBug: (Bug*) bug;
- (void) addBug: (Bug*) bug
       andStart: (BOOL) start;
- (NSArray*) bugs: (NSString*) inLayer;
- (long) numberOfBugs: (NSString*) inLayer;
- (NSArray*) layerKeys;
- (BOOL) isOccupied: (NSString*) inLayer
                  x: (long) x
                  y: (long) y;
- (BOOL) isOccupied: (long) x
                  y: (long) y;
- (void) clear: (NSString*) inLayer;
- (void) clear;
- (void) start;
- (void) stop;

@end

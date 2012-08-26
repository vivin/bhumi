#import <Foundation/Foundation.h>
#import "NSMutableArray+Shuffle.h"
#import "Bug.h"
#include <stdlib.h>

@interface World : NSObject {

    @private
    NSString *name;

    NSMutableDictionary *grid; //Keyed by layer->list of rows->list of columns->bug
    NSMutableDictionary *layerBugDictionary; //Keyed by layer->list of bugs
    NSMutableArray *bugs;   //Array of all bugs 

    int rows;
    int columns;

    int iterations; //How many iterations we're running the simulation
    int snapshotInterval; //Generate a snapshot every <snapshotInterval> iterations

    BOOL running;
}

- (id) init;
- (id) initWithName: (NSString*) aName
               rows: (int) aRows
            columns: (int) aColumns
         iterations: (int) anIterations
   snapshotInterval: (int) aSnapshotInterval;

- (void) addBug: (Bug*) bug;

- (void) removeBug: (Bug*) aBug;
- (void) removeBug: (NSString*) inLayer
                 x: (int) x
                 y: (int) y;
- (Bug*) getBug: (NSString*) inLayer
              x: (int) x
              y: (int) y;
- (BOOL) moveBug: (NSString*) fromLayer
           fromX: (int) fromX
           fromY: (int) fromY
         toLayer: (NSString*) toLayer
             toX: (int) toX 
             toY: (int) toY;

- (NSArray*) bugs: (NSString*) inLayer;
- (int) numberOfBugs: (NSString*) inLayer;
- (NSArray*) layers;
- (int) rows;
- (int) columns;

- (BOOL) isOccupied: (NSString*) inLayer
                  x: (int) x
                  y: (int) y;
- (BOOL) isOccupied: (int) x
                  y: (int) y;

- (BOOL) isRunning;

- (void) clearLayer: (NSString*) layer;
- (void) clear;

- (void) start;

@end

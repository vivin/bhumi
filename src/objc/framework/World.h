#import <Foundation/Foundation.h>
#import "NSMutableArray+Shuffle.h"
#import "Bug.h"
#import "ToStringSerializerProtocol.h"

@protocol InterceptorProtocol;

@interface World : NSObject

@property NSString *name;

@property(readonly) NSMutableDictionary *grid; //Keyed by layer->list of rows->list of columns->bug
@property(readonly) NSMutableDictionary *layerBugDictionary; //Keyed by layer->list of bugs
@property(readonly) NSMutableArray *bugs;   //Array of all bugs

@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;

@property(readonly) NSUInteger currentIteration; //The current iteration
@property NSUInteger iterations; //How many iterations we're running the simulation
@property NSUInteger snapshotInterval; //Generate a snapshot every <snapshotInterval> iterations

@property(readonly) BOOL running;

@property(readonly) id <InterceptorProtocol> interceptor;

- (id) init;

//TODO: instead of having just one interceptor, consider having a bunch of interceptors

- (id) initWithName: (NSString *) aName
               rows: (NSUInteger) aRows
            columns: (NSUInteger) aColumns
         iterations: (NSUInteger) anIterations
   snapshotInterval: (NSUInteger) aSnapshotInterval
        interceptor: (id <InterceptorProtocol>) anInterceptor;

+ (id) objectWithName: (NSString *) aName
                 rows: (NSUInteger) aRows
              columns: (NSUInteger) aColumns
           iterations: (NSUInteger) anIterations
     snapshotInterval: (NSUInteger) aSnapshotInterval
          interceptor: (id <InterceptorProtocol>) anInterceptor;

- (void) addBug: (Bug *) bug;

- (void) removeBug: (Bug *) aBug;

- (void) removeBugInLayer: (NSString *) inLayer
                      atX: (NSUInteger) atX
                      atY: (NSUInteger) atY;

- (Bug *) getBugInLayer: (NSString *) inLayer
                    atX: (NSUInteger) atX
                    atY: (NSUInteger) atY;

- (NSArray *) getBugsAtX: (NSUInteger) atX
                     atY: (NSUInteger) atY;

- (BOOL) moveBugFrom: (NSString *) fromLayer
                 atX: (NSUInteger) fromX
                 atY: (NSUInteger) fromY
             toLayer: (NSString *) toLayer
                 atX: (NSUInteger) toX
                 atY: (NSUInteger) toY;

- (NSArray *) bugs: (NSString *) inLayer;

- (NSUInteger) numberOfBugs: (NSString *) inLayer;

- (NSArray *) layers;

- (BOOL) isLocationOccupiedInLayer: (NSString *) inLayer
                               atX: (NSUInteger) atX
                               atY: (NSUInteger) atY;

- (BOOL) isLocationOccupiedAtX: (NSUInteger) atX
                           atY: (NSUInteger) atY;

- (void) clearLayer: (NSString *) layer;

- (void) clear;

- (void) start;

@end

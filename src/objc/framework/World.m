#include "World.h"
#import "InterceptorProtocol.h"

@implementation World

@synthesize name;
@synthesize grid;
@synthesize layerBugDictionary;
@synthesize bugs;
@synthesize rows;
@synthesize columns;
@synthesize currentIteration;
@synthesize iterations;
@synthesize snapshotInterval;
@synthesize running;
@synthesize interceptor;

- (id) init {
    self = [super init];

    if((self = [super init])) {
        name = @"";
        grid = [[NSMutableDictionary alloc] init];
        layerBugDictionary = [[NSMutableDictionary alloc] init]; 
        bugs = [[NSMutableArray alloc] init];
        rows = 0;
        columns = 0;
        currentIteration = 0;
        iterations = 0;
        snapshotInterval = 0;
        _wait = YES;
    }

    return self;
}

- (id) initWithName: (NSString *) aName
               rows: (NSUInteger) aRows
            columns: (NSUInteger) aColumns
         iterations: (NSUInteger) anIterations
   snapshotInterval: (NSUInteger) aSnapshotInterval
        interceptor: (id <InterceptorProtocol>) anInterceptor {

    self = [super init];
    self = [self init];

    if (self) {
        name = aName;
        rows = aRows;
        columns = aColumns;
        iterations = anIterations;
        snapshotInterval = aSnapshotInterval;
        interceptor = anInterceptor;
    }

    return self;
}

+ (id) objectWithName: (NSString *) aName
                 rows: (NSUInteger) aRows
              columns: (NSUInteger) aColumns
           iterations: (NSUInteger) anIterations
     snapshotInterval: (NSUInteger) aSnapshotInterval
          interceptor: (id <InterceptorProtocol>) anInterceptor {
    return [[World alloc] initWithName: aName
                                  rows: aRows
                               columns: aColumns
                            iterations: anIterations
                      snapshotInterval: aSnapshotInterval
                           interceptor: anInterceptor];
}

- (void) addBug: (Bug*) aBug {

    NSString* layer = [aBug layer];

    NSUInteger numberOfBugs = 0;
    if([layerBugDictionary objectForKey: layer] == nil) {
        [layerBugDictionary setObject: [NSMutableArray array] forKey: layer];
    } else {
        numberOfBugs = [[layerBugDictionary objectForKey: layer] count];
    }

    if(numberOfBugs == (rows * columns)) {
       [NSException raise:@"Layer is full! Cannot add more bugs!" format:@"The %s layer is full! Cannot add more bugs", [layer UTF8String]];
    } else {
       [[layerBugDictionary objectForKey: layer] addObject: aBug];
    }

    NSUInteger x = [aBug x];
    NSUInteger y = [aBug y];

    if([aBug isPlaced] == NO) {
        x = arc4random() % columns;
        y = arc4random() % rows;
    }

    if([self isLocationOccupiedInLayer: layer atX: x atY: y] == YES) {
        //NSLog(@"Bug %@ could not be put in random location %lu:%lu", [aBug name], x, y);
        //That location is already occupied. Let's look for the first non-occupied location.
        
        NSUInteger i = 0;
        BOOL found = NO;

        while(i < columns && !found) {

            NSUInteger j = 0;
            while(j < rows && !found) {
                if([self isLocationOccupiedInLayer: layer atX: i atY: j] == NO) {
                    found = YES;
                    x = i;
                    y = j;
                }

                j++;
            }

            i++;
        }

       //NSLog(@"Bug %@ was put in new location at %lu:%lu", [aBug name], x, y);
        //NSLog(@"This location is %@", [self isLocationOccupiedInLayer: layer atX: x atY: y] ? @"occupied" :  @"not occupied");
    } else {
        //NSLog(@"Bug %@ was put in random location at %lu:%lu", [aBug name], x, y);
    }

    [aBug setX: x Y: y];
    
    //Mark the location in the grid as occupied
    if([grid objectForKey: layer] == nil) {
        //NSLog(@"Bug %@: layer %@ was empty so creating new dict", [aBug name], layer);
        [grid setObject: [[NSMutableDictionary alloc] init] forKey: layer];
    }

    NSMutableDictionary* gridColumns = [grid objectForKey: layer];
    if([gridColumns objectForKey: [NSNumber numberWithUnsignedInteger: x]] == nil) {
        //NSLog(@"Bug %@: bug column %li was empty so creating new dict", [aBug name], [aBug x]);
        [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithUnsignedInteger: x]];
    }

    NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithUnsignedInteger: x]];
    if([gridRows objectForKey: [NSNumber numberWithUnsignedInteger: y]] == nil) {
        //NSLog(@"Bug %@: bug row %li (y: %li) was empty as it should be so setting bug at that location", [aBug name], [aBug y], y);
        [gridRows setObject: aBug forKey: [NSNumber numberWithUnsignedInteger: y]];

        //NSLog(@"Location is %@", [gridRows objectForKey: [[NSNumber numberWithUnsignedInteger: y] stringValue]] == nil ? @"nil" : @"not nil");
        //NSLog(@"%@:%i:%i is %@", layer, x, y, [self isLocationOccupiedInLayer: layer atX: x atY: y] ? @"occupied" : @"not occupied");
    }

    //NSLog(@"Bug %@ is at %lu:%lu", [aBug name], [aBug x], [aBug y]);

    [bugs addObject: aBug];
}

- (void) removeBug: (Bug*) aBug {
    [self removeBugInLayer: [aBug layer] atX: [aBug x] atY: [aBug y]];
}

- (void) removeBugInLayer: (NSString *) inLayer
                      atX: (NSUInteger) atX
                      atY: (NSUInteger) atY {

    if([self isLocationOccupiedInLayer: inLayer atX: atX atY: atY] == YES) {
        Bug* bug = [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithUnsignedInteger: atX]] objectForKey: [NSNumber numberWithUnsignedInteger: atY]];
        [bug kill]; 

        [[[grid objectForKey: inLayer] objectForKey:  [NSNumber numberWithUnsignedInteger: atX]] removeObjectForKey: [NSNumber numberWithUnsignedInteger: atY]];

        NSMutableArray* bugsInLayer = [layerBugDictionary objectForKey: inLayer];
        NSEnumerator* bugEnumerator = [bugsInLayer objectEnumerator];
        Bug* aBug;
        BOOL found = NO;
        NSUInteger i = 0;

        while((aBug = [bugEnumerator nextObject]) && !found) {
            found = (bug == aBug);
            i++;
        }

        //We must always find the bug we are looking for!
        NSAssert(found, @"We must have been able to find the bug we are looking for");

        [bugsInLayer removeObjectAtIndex: --i];
    }
}

- (Bug*) getBugInLayer: (NSString *) inLayer
                   atX: (NSUInteger) atX
                   atY: (NSUInteger) atY {

    Bug* bug = nil;

    if([self isLocationOccupiedInLayer: inLayer atX: atX atY: atY] == YES) {
        bug = [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithUnsignedInteger: atX]] objectForKey: [NSNumber numberWithUnsignedInteger: atY]];
    }

    return bug;
}

- (NSArray*) getBugsAtX: (NSUInteger) atX
                    atY: (NSUInteger) atY {

    NSMutableArray* bugsAtLocation = [[NSMutableArray alloc] init];

    if([self isLocationOccupiedAtX: atX atY: atY] == YES) {
        NSArray* allLayers = [self layers];
        NSEnumerator* layerEnumerator = [allLayers objectEnumerator];
        NSString* layer;

        while((layer = [layerEnumerator nextObject])) {
            Bug* bug = [self getBugInLayer: layer atX: atX atY: atY];

            if(bug != nil) {
                [bugsAtLocation addObject: bug];
            }
        }
    }

    return bugsAtLocation;
}

- (BOOL) moveBugFrom: (NSString *) fromLayer
                 atX: (NSUInteger) fromX
                 atY: (NSUInteger) fromY
             toLayer: (NSString *) toLayer
                 atX: (NSUInteger) toX
                 atY: (NSUInteger) toY {

    //NSLog(@"Moving bug from %@:%lu:%lu to %@:%lu:%lu", fromLayer, fromX, fromY, toLayer, toX, toY);

    BOOL success = NO;

    if([self isLocationOccupiedInLayer: toLayer atX: toX atY: toY] == NO) {

        //NSLog(@"Location is not occupied!");

        Bug* bug = [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithUnsignedInteger: fromX]] objectForKey: [NSNumber numberWithUnsignedInteger: fromY]];

        if(bug == nil) {
            int uppy = 0;
            NSAssert(bug != nil, @"Bug must not be nil!!");
        }


        if(![toLayer isEqualToString: fromLayer]) {
            NSMutableArray* bugsInLayer = [layerBugDictionary objectForKey: fromLayer];
            NSEnumerator* bugEnumerator = [bugsInLayer objectEnumerator];
            Bug* aBug;
            BOOL found = NO;
            NSUInteger i = 0;

            while((aBug = [bugEnumerator nextObject]) && !found) {
                found = (bug == aBug);
                i++;
            }

            //We must always find the bug we are looking for!
            NSAssert(found, @"We must have been able to find the bug we are looking for");

            [bugsInLayer removeObjectAtIndex: i--];
            [[layerBugDictionary objectForKey: toLayer] addObject: bug];
        }

        [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithUnsignedInteger: fromX]] removeObjectForKey: [NSNumber numberWithUnsignedInteger: fromY]];

        //Mark the new location in the grid as occupied
        if([grid objectForKey: toLayer] == nil) {
            [grid setObject: [[NSMutableDictionary alloc] init] forKey: toLayer];
        }

        NSMutableDictionary* gridColumns = [grid objectForKey: toLayer];
        if([gridColumns objectForKey: [NSNumber numberWithUnsignedInteger: toX]] == nil) {
            [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithUnsignedInteger: toX]];
        }

        NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithUnsignedInteger: toX]];
        [gridRows setObject: bug forKey: [NSNumber numberWithUnsignedInteger: toY]];

        success = YES;
    }

    return success;
}

- (NSArray*) bugs: (NSString*) inLayer {
    return [layerBugDictionary objectForKey: inLayer];
}

- (NSUInteger) numberOfBugs: (NSString*) inLayer {
    NSUInteger numberOfBugs = 0;

    if([layerBugDictionary objectForKey: inLayer] != nil) {
        numberOfBugs = [[layerBugDictionary objectForKey: inLayer] count];
    }

    return numberOfBugs;
}

- (NSArray*) layers {
    return [layerBugDictionary allKeys];
}

- (BOOL) isLocationOccupiedInLayer: (NSString *) inLayer
                               atX: (NSUInteger) atX
                               atY: (NSUInteger) atY {

    BOOL occupied = NO;

    //NSLog(@"Checking occupancy of %lu:%lu", atX, atY);

    NSMutableDictionary* gridColumns = [grid objectForKey: inLayer];

    if(gridColumns != nil) {
        //NSLog(@"Something is in the layer");

        NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithUnsignedInteger: atX]];

        if(gridRows != nil) {
            //NSLog(@"Something is in the rows");

            Bug* bug = [gridRows objectForKey: [NSNumber numberWithUnsignedInteger: atY]];

            if(bug != nil) {
                //NSLog(@"Something is at %lu:%lu", atX, atY);
                occupied = YES;
            }  else {
                //NSLog(@"Nothing is at %lu:%lu", atX, atY);
            }
        }
    }

    return occupied;
}

- (BOOL) isLocationOccupiedAtX: (NSUInteger) atX
                           atY: (NSUInteger) atY {

    NSEnumerator* enumerator = [grid keyEnumerator];
    id key;
    BOOL occupied = NO;
 
    while((key = [enumerator nextObject]) && !occupied) {
       occupied = [self isLocationOccupiedInLayer: key atX: atX atY: atY];
    }

    return occupied;
}

- (void) clearLayer: (NSString*) layer {
    [layerBugDictionary removeObjectForKey: layer];
    [grid removeObjectForKey: layer];
}

- (void) step {
    _wait = NO;
}

- (void) clear {
    [grid removeAllObjects];
    [layerBugDictionary removeAllObjects];
    [bugs removeAllObjects];
}

- (void) start {

    NSLog(@"We are starting!");

    running = YES;

    while(currentIteration < iterations) {

        _wait = YES;

        @autoreleasepool {

            NSMutableArray* deadBugs = [[NSMutableArray alloc] init];

            [bugs shuffle];

            NSEnumerator* bugEnumerator = [bugs objectEnumerator];
            Bug* bug;
            NSUInteger i = 0;

            while((bug = [bugEnumerator nextObject])) {

                NSString* originalLayer = [bug layer];
                NSUInteger originalX = [bug x];
                NSUInteger originalY = [bug y];

                Bug* oBug = [self getBugInLayer: [bug layer] atX: [bug x] atY: [bug y]];

                NSAssert(oBug == bug, @"Bug %@ says its location is %lu:%lu, but the bug at that location is %@", [bug name], [bug x], [bug y], [oBug name]);
                [bug act];
                //NSLog(@"Bug has acted");

                if([bug alive] == YES) {
                    if(![originalLayer isEqualToString: [bug layer]] || originalX != [bug x] || originalY != [bug y]) {
                        //NSLog(@"Moving bug %@ from %lu:%lu to %lu:%lu", [bug name], originalX, originalY, [bug x], [bug y]);
                        //NSLog(@"Bug has moved");
                        [self moveBugFrom: originalLayer atX: originalX atY: originalY toLayer: [bug layer] atX: [bug x] atY: [bug y]];

                        Bug* xBug = [self getBugInLayer: [bug layer] atX: [bug x] atY: [bug y]];
                        NSAssert(xBug == bug, @"After moving, bug %@ says its location is %lu:%lu, but the bug at that location is %@", [bug name], [bug x], [bug y], [xBug name]);
                        //NSLog(@"Updated bug position");
                    }
                } else {
                    [deadBugs addObject: bug];
                }

                i++;
            }

            [bugs removeObjectsInArray: deadBugs];

            if(currentIteration % snapshotInterval == 0) {
                [interceptor intercept: self];
            }

            currentIteration++;
        }

        while(_wait == YES) {
        }
    }

    //NSLog(@"Done.");
}

@end

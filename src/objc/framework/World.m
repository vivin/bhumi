#include "World.h"
#import "WorldToStringSerializer.h"
#import "BugToStringSerializer.h"

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
@synthesize toStringSerializer;

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
    }

    return self;
}

- (id) initWithName: (NSString *) aName
               rows: (NSUInteger) aRows
            columns: (NSUInteger) aColumns
         iterations: (NSUInteger) anIterations
   snapshotInterval: (NSUInteger) aSnapshotInterval
    serializerClass: (Class) serializerClass {

    self = [super init];
    self =[self init];

    if (self) {
        name = aName;
        rows = aRows;
        columns = aColumns;
        iterations = anIterations;
        snapshotInterval = aSnapshotInterval;

        toStringSerializer = [[serializerClass alloc] initWithWorld: self];

        if([toStringSerializer isKindOfClass: [WorldToStringSerializer class]]) {


            if([toStringSerializer serializerType] != [self class]) {
                [NSException raise:@"Serializer format must match format of world!" format:@"Serializer format must match format of world!"];
            }
        } else {
            [NSException raise:@"Serializer class is expected to be a subtype of WorldToStringSerializer!" format:@"Serializer class is expected to be a subtype WorldToStringSerializer!"];
        }
    }

    return self;
}

+ (id) objectWithName: (NSString *) aName
                 rows: (NSUInteger) aRows
              columns: (NSUInteger) aColumns
           iterations: (NSUInteger) anIterations
     snapshotInterval: (NSUInteger) aSnapshotInterval
      serializerClass: (Class) serializerClass {
    return [[World alloc] initWithName: aName
                                  rows: aRows
                               columns: aColumns
                            iterations: anIterations
                      snapshotInterval: aSnapshotInterval
                       serializerClass: serializerClass];
}


- (void) addBug: (Bug*) aBug {

    if([[aBug toStringSerializer] serializerFormat] != [toStringSerializer serializerFormat]) {
        [NSException raise:@"Serializer format of bug must match format of world!" format:@"Serializer format must match format of world!"];
    }

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
        //NSLog(@"Bug %@ could not be put in random location %i:%i", [aBug name], x, y);
        //That location is already occupied. Let's look for the first non-occupied location.
        
        NSUInteger i = 0;
        NSUInteger j = 0;
        BOOL found = NO;

        while(i < columns && !found) {
            while(j < rows && !found) {
                if([self isLocationOccupiedInLayer: layer atX: i atY: j] == YES) {
                    found = YES;
                    x = i;
                    y = j;
                }

                j++;
            }

            i++;
        }

        /*
        NSMutableDictionary* gridColumns = [grid objectForKey: layer];
        BOOL columnFound = NO;
        BOOL rowFound = NO;
        NSUInteger i = 0;
        while(i < columns && !columnFound) {

            NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: i]];
            if(gridRows == nil) {
                //If the rows entry for this column is null, we don't need to search any further since
                //it means that we don't have any layerBugDictionary in this column
                x = i;
                y = 0;
                columnFound = YES;
                rowFound = YES;
            } else {
                //If the column entry is not null, we need to start looking at each row entry in this column.
                //Each entry here translates to a cell in the grid.
                NSUInteger j = 0;
                while(j < rows && !rowFound) {
                    if([gridRows objectForKey: [NSNumber numberWithInt: j]] == nil) {
                        y = j;
                        columnFound = YES;
                        rowFound = YES;
                    }

                    j++;
                }
            }

            i++;
        }*/

        //NSLog(@"Found new location for Bug %@ at %i:%i", [aBug name], x, y);
        //NSLog(@"This location is %@", [self isLocationOccupiedInLayer: layer atX: x atY: y] ? @"occupied" :  @"not occupied");
    } else {
        //NSLog(@"Bug %@ was put in random location %i:%i", [aBug name], x, y);
    }

    [aBug setX: x Y: y];

    //Mark the location in the grid as occupied
    if([grid objectForKey: layer] == nil) {
        //NSLog(@"Bug %@: layer %@ was empty so creating new dict", [aBug name], layer);
        [grid setObject: [[NSMutableDictionary alloc] init] forKey: layer];
    }

    NSMutableDictionary* gridColumns = [grid objectForKey: layer];
    if([gridColumns objectForKey: [[NSNumber numberWithInt: x] stringValue]] == nil) {
        //NSLog(@"Bug %@: column %i was empty so creating new dict", [aBug name], [aBug x]);
        [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [[NSNumber numberWithInt: x] stringValue]];
    }

    NSMutableDictionary* gridRows = [gridColumns objectForKey: [[NSNumber numberWithInt: x] stringValue]];
    if([gridRows objectForKey: [[NSNumber numberWithInt: y] stringValue]] == nil) {
        //NSLog(@"Bug %@: row %i (%i) was empty as it should be so setting bug at that location", [aBug name], [aBug y], y);
        [gridRows setObject: aBug forKey: [[NSNumber numberWithInt: y] stringValue]];

        //NSLog(@"Location is %@", [gridRows objectForKey: [[NSNumber numberWithInt: y] stringValue]] == nil ? @"nil" : @"not nil");
        //NSLog(@"%@:%i:%i is %@", layer, x, y, [self isLocationOccupiedInLayer: layer atX: x atY: y] ? @"occupied" : @"not occupied");
    }

    [bugs addObject: aBug];
}

- (void) removeBug: (Bug*) aBug {
    [self removeBugInLayer: [aBug layer] atX: [aBug x] atY: [aBug y]];
}

- (void) removeBugInLayer: (NSString *) inLayer
                      atX: (NSUInteger) atX
                      atY: (NSUInteger) atY {

    if([self isLocationOccupiedInLayer: inLayer atX: atX atY: atY] == YES) {
        Bug* bug = [[[grid objectForKey: inLayer] objectForKey: [[NSNumber numberWithInt: atX] stringValue]] objectForKey: [[NSNumber numberWithInt: atY] stringValue]];
        [bug kill]; 

        [[[grid objectForKey: inLayer] objectForKey:  [[NSNumber numberWithInt: atX] stringValue]] removeObjectForKey: [[NSNumber numberWithInt: atY] stringValue]];

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

        [bugsInLayer removeObjectAtIndex: i--];
    }
}

- (Bug*) getBugInLayer: (NSString *) inLayer
                   atX: (NSUInteger) atX
                   atY: (NSUInteger) atY {

    Bug* bug = nil;

    if([self isLocationOccupiedInLayer: inLayer atX: atX atY: atY] == YES) {
        bug = [[[grid objectForKey: inLayer] objectForKey: [[NSNumber numberWithInt: atX] stringValue]] objectForKey: [[NSNumber numberWithInt: atY] stringValue]];
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

    //NSLog(@"Moving bug from %@:%i:%i to %@:%i:%i", fromLayer, fromX, fromY, toLayer, toX, toY);

    BOOL success = NO;

    if([self isLocationOccupiedInLayer: toLayer atX: toX atY: toY] == YES) {

        //NSLog(@"Location is not occupied!");

        Bug* bug = [[[grid objectForKey: fromLayer] objectForKey: [[NSNumber numberWithInt: fromX] stringValue]] objectForKey: [[NSNumber numberWithInt: fromY] stringValue]];

        NSAssert(bug != nil, @"Bug must not be nil!!");

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

        [[[grid objectForKey: fromLayer] objectForKey: [[NSNumber numberWithInt: fromX] stringValue]] removeObjectForKey: [[NSNumber numberWithInt: fromY] stringValue]];

        //Mark the new location in the grid as occupied
        if([grid objectForKey: toLayer] == nil) {
            [grid setObject: [[NSMutableDictionary alloc] init] forKey: toLayer];
        }

        NSMutableDictionary* gridColumns = [grid objectForKey: toLayer];
        if([gridColumns objectForKey: [NSNumber numberWithInt: toX]] == nil) {
            [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithInt: toX]];
        }

        NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: toX]];
        [gridRows setObject: bug forKey: [NSNumber numberWithInt: toY]];

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

    //NSLog(@"Checking occupancy of %@:%i:%i", inLayer, x, y);

    NSMutableDictionary* gridColumns = [grid objectForKey: inLayer];

    if(gridColumns != nil) {
        //NSLog(@"Something is in the layer");

        NSMutableDictionary* gridRows = [gridColumns objectForKey: [[NSNumber numberWithInt: atX] stringValue]];

        if(gridRows != nil) {
            //NSLog(@"Something is in the rows");

            Bug* bug = [gridRows objectForKey: [[NSNumber numberWithInt: atY] stringValue]];

            if(bug != nil) {
                //NSLog(@"Something is in that cell");
                occupied = YES;
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

- (void) clear {
    [grid removeAllObjects];
    [layerBugDictionary removeAllObjects];
    [bugs removeAllObjects];
}

- (void) start {

    while(currentIteration < iterations) {

//        NSAutoreleasePool* innerPool = [[NSAutoreleasePool alloc] init];
               
        //printf("Iteration %i of %i\n", currentIteration + 1, iterations);
        
        [bugs shuffle];

        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        while((bug = [bugEnumerator nextObject])) {
            NSString* originalLayer = [bug layer];
            NSUInteger originalX = [bug x];
            NSUInteger originalY = [bug y];

            //NSLog(@"Bug %@ is going to act and location %i:%i is %@", [bug name], [bug x], [bug y], [self isOccupied: [bug layer] x: [bug x] y: [bug y]] ? @"occupied" : @"not occupied");
            //NSAutoreleasePool* innerPool = [[NSAutoreleasePool alloc] init];
            [bug act];
            //[innerPool drain];
            //NSLog(@"Bug has acted");

            if(![originalLayer isEqualToString: [bug layer]] || originalX != [bug x] || originalY != [bug y]) {
                //NSLog(@"Bug has moved");
                [self moveBugFrom: originalLayer atX: originalX atY: originalY toLayer: [bug layer] atX: [bug x] atY: [bug y]];
                //NSLog(@"Updated bug position");
            }
        }

        if(currentIteration % snapshotInterval == 0) {

            printf("%s", [[toStringSerializer serializeToString] UTF8String]);   
            /*
             
            NSUInteger i = 0;
            NSUInteger j = 0;
            NSUInteger k = 0;

            
            for(i = 0; i < rows; i++) {

                for(k = 0; k < columns; k++) {
                    printf("+---");
                    if(k == columns - 1) {
                        printf("+");
                    }
                }

                printf("\n");

                for(j = 0; j < columns; j++) {
                    if([self isOccupied: bugLayer x: j y: i]) {
                        printf("| X ");
                    } else {
                        printf("|   ");
                    }

                    if(j == columns - 1) {
                        printf("|\n");
                    }
                }
            } 

            for(k = 0; k < columns; k++) {
                printf("+---");
                if(k == columns - 1) {
                    printf("+");
                }
            } */
        } 

        currentIteration++;
        //printf("\n"); 
        //
//        [innerPool drain];
    } 

    //NSLog(@"Done.");
}

@end

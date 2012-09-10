#include "World.h"
#import "WorldToStringSerializer.h"
#include <stdlib.h>
#include <time.h>

@implementation World

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

- (id) initWithName: (NSString*) aName
               rows: (int) aRows
            columns: (int) aColumns 
         iterations: (int) anIterations
   snapshotInterval: (int) aSnapshotInterval
    serializerClass: (Class) serializerClass {

   if((self = [super init])) {
       [self init];

       [name autorelease];
       name = [aName retain];

       rows = aRows;
       columns = aColumns;
       currentIteration = 0;
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

- (void) addBug: (Bug*) aBug {

    if([[aBug toStringSerializer] serializerFormat] != [toStringSerializer serializerFormat]) {
        [NSException raise:@"Serializer format of bug must match format of world!" format:@"Serializer format must match format of world!"];
    }

    NSString* layer = [aBug layer];

    int numberOfBugs = 0;
    if([layerBugDictionary objectForKey: layer] == nil) {
        [layerBugDictionary setObject: [NSMutableArray array] forKey: layer];
    } else {
        numberOfBugs = [[layerBugDictionary objectForKey: layer] count];
    }

    if(numberOfBugs == (rows * columns)) {
       [NSException raise:@"Layer is full! Cannot add more bugs!" format:@"The %s layer is full! Cannot add more bugs", layer];
    } else {
       [[layerBugDictionary objectForKey: layer] addObject: aBug];
    }

    int x = [aBug x];
    int y = [aBug y];

    if([aBug x] == -1) {
        x = arc4random() % columns;
        x = (x < 0) ? x * -1 : x;
    }

    if([aBug y] == -1) {
        y = arc4random() % rows;
        y = (y < 0) ? y * -1 : y;
    }

    if([self isOccupied: layer x: x y: y] == YES) {
        //NSLog(@"Bug %@ could not be put in random location %i:%i", [aBug name], x, y);
        //That location is already occupied. Let's look for the first non-occupied location.
        
        int i = 0;
        int j = 0;
        BOOL found = NO;

        while(i < columns && !found) {
            while(j < rows && !found) {
                if([self isOccupied: layer x: i y: j] == YES) {
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
        int i = 0;
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
                int j = 0;
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
        //NSLog(@"This location is %@", [self isOccupied: layer x: x y: y] ? @"occupied" :  @"not occupied");
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
    if([gridColumns objectForKey: [NSNumber numberWithInt: x]] == nil) {
        //NSLog(@"Bug %@: column %i was empty so creating new dict", [aBug name], [aBug x]);
        [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithInt: x]];
    }

    NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: x]];
    if([gridRows objectForKey: [NSNumber numberWithInt: y]] == nil) {
        //NSLog(@"Bug %@: row %i (%i) was empty as it should be so setting bug at that location", [aBug name], [aBug y], y);
        [gridRows setObject: aBug forKey: [NSNumber numberWithInt: y]];

        //NSLog(@"Location is %@", [gridRows objectForKey: [NSNumber numberWithInt: y]] == nil ? @"nil" : @"not nil");
        //NSLog(@"%@:%i:%i is %@", layer, x, y, [self isOccupied: layer x: x y: y] ? @"occupied" : @"not occupied");
    }

    [bugs addObject: aBug];
}

- (void) removeBug: (Bug*) aBug {
    [self removeBug: [aBug layer] x: [aBug x] y: [aBug y]];
}

- (void) removeBug: (NSString*) inLayer
                 x: (int) x
                 y: (int) y {

    if([self isOccupied: inLayer x: x y: y] == YES) {
        Bug* bug = [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithInt: x]] objectForKey: [NSNumber numberWithInt: y]];
        [bug kill]; 

        [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithInt: x]] removeObjectForKey: [NSNumber numberWithInt: y]];

        NSMutableArray* bugsInLayer = [layerBugDictionary objectForKey: inLayer];
        NSEnumerator* bugEnumerator = [bugsInLayer objectEnumerator];
        Bug* aBug;
        BOOL found = NO;
        int i = 0;

        while((aBug = [bugEnumerator nextObject]) && !found) {
            found = (bug == aBug);
            i++;
        }

        //We must always find the bug we are looking for!
        NSAssert(found, @"We must have been able to find the bug we are looking for");

        [bugsInLayer removeObjectAtIndex: i--];
    }
}

- (Bug*) getBug: (NSString*) inLayer
              x: (int) x
              y: (int) y {

    Bug* bug = nil;

    if([self isOccupied: inLayer x: x y: y] == YES) {
        bug = [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithInt: x]] objectForKey: [NSNumber numberWithInt: y]];
    }

    return bug;
}

- (NSArray*) getBugs: (int) x
                   y: (int) y {

    NSMutableArray* bugsAtLocation = [[NSMutableArray alloc] init];

    if([self isOccupied: x y: y] == YES) {
        NSArray* allLayers = [self layers];
        NSEnumerator* layerEnumerator = [allLayers objectEnumerator];
        NSString* layer;

        while((layer = [layerEnumerator nextObject])) {
            Bug* bug = [self getBug: layer x: x y: y];

            if(bug != nil) {
                [bugsAtLocation addObject: bug];
            }
        }
    }

    return [bugsAtLocation autorelease];
}

- (BOOL) moveBug: (NSString*) fromLayer
           fromX: (int) fromX
           fromY: (int) fromY
         toLayer: (NSString*) toLayer 
             toX: (int) toX
             toY: (int) toY {

    //NSLog(@"Moving bug from %@:%i:%i to %@:%i:%i", fromLayer, fromX, fromY, toLayer, toX, toY);

    BOOL success = NO;

    if([self isOccupied: toLayer x: toX y: toY] == YES) {

        //NSLog(@"Location is not occupied!");

        Bug* bug = [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithInt: fromX]] objectForKey: [NSNumber numberWithInt: fromY]];

        NSAssert(bug != nil, @"Bug must not be nil!!");

        if(![toLayer isEqualToString: fromLayer]) {
            NSMutableArray* bugsInLayer = [layerBugDictionary objectForKey: fromLayer];
            NSEnumerator* bugEnumerator = [bugsInLayer objectEnumerator];
            Bug* aBug;
            BOOL found = NO;
            int i = 0;

            while((aBug = [bugEnumerator nextObject]) && !found) {
                found = (bug == aBug);
                i++;
            }

            //We must always find the bug we are looking for!
            NSAssert(found, @"We must have been able to find the bug we are looking for");

            [bugsInLayer removeObjectAtIndex: i--];
            [[layerBugDictionary objectForKey: toLayer] addObject: bug];
        }

        [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithInt: fromX]] removeObjectForKey: [NSNumber numberWithInt: fromY]];

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

- (NSArray*) bugs {
    return bugs;
}

- (NSArray*) bugs: (NSString*) inLayer {
    return [layerBugDictionary objectForKey: inLayer];
}

- (int) numberOfBugs: (NSString*) inLayer {
    int numberOfBugs = 0;

    if([layerBugDictionary objectForKey: inLayer] != nil) {
        numberOfBugs = [[layerBugDictionary objectForKey: inLayer] count];
    }

    return numberOfBugs;
}

- (NSArray*) layers {
    return [layerBugDictionary allKeys];
}

- (int) rows {
    return rows;
}

- (int) columns {
    return columns;
}

- (int) iterations {
    return iterations;
}

- (int) currentIteration {
    return currentIteration;
}

- (int) snapshotInterval {
    return snapshotInterval;
}

- (NSString*) name {
    return name;
}

- (BOOL) isOccupied: (NSString*) inLayer
                  x: (int) x
                  y: (int) y {

    BOOL occupied = NO;

    //NSLog(@"Checking occupancy of %@:%i:%i", inLayer, x, y);

    NSMutableDictionary* gridColumns = [grid objectForKey: inLayer];

    if(gridColumns != nil) {
        //NSLog(@"Something is in the layer");

        NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: x]];

        if(gridRows != nil) {
            //NSLog(@"Something is in the rows");

            Bug* bug = [gridRows objectForKey: [NSNumber numberWithInt: y]];

            if(bug != nil) {
                //NSLog(@"Something is in that cell");
                occupied = YES;
            } 
        }
    }

    return occupied;
}

- (BOOL) isOccupied: (int) x
                  y: (int) y {

    NSEnumerator* enumerator = [grid keyEnumerator];
    id key;
    BOOL occupied = NO;
 
    while((key = [enumerator nextObject]) && !occupied) {
       occupied = [self isOccupied: key x: x y: y];
    }

    return occupied;
}

- (BOOL) isRunning {
    return running;
}

- (void) clearLayer: (NSString*) layer {

    [[layerBugDictionary objectForKey: layer] release];
    [layerBugDictionary removeObjectForKey: layer];

    NSMutableDictionary* gridColumns = [grid objectForKey: layer];
    [gridColumns release];

    [grid removeObjectForKey: layer];
}

- (void) clear {
    [grid removeAllObjects];
    [layerBugDictionary removeAllObjects];
    [bugs removeAllObjects];
}

- (void) start {

    while(currentIteration < iterations) {

        //NSAutoreleasePool* innerPool = [[NSAutoreleasePool alloc] init];
        
        //printf("Iteration %i of %i\n", currentIteration + 1, iterations);
        
        [bugs shuffle];

        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        while((bug = [bugEnumerator nextObject])) {
            NSString* originalLayer = [bug layer];
            int originalX = [bug x];
            int originalY = [bug y];

            //NSLog(@"Bug %@ is going to act and location %i:%i is %@", [bug name], [bug x], [bug y], [self isOccupied: [bug layer] x: [bug x] y: [bug y]] ? @"occupied" : @"not occupied");
            [bug act];
            //NSLog(@"Bug has acted");

            if(![originalLayer isEqualToString: [bug layer]] || originalX != [bug x] || originalY != [bug y]) {
                //NSLog(@"Bug has moved");
                [self moveBug: originalLayer fromX: originalX fromY: originalY toLayer: [bug layer] toX: [bug x] toY: [bug y]];
                //NSLog(@"Updated bug position");
            }
        }

        if(currentIteration % snapshotInterval == 0) {

            printf("%s", [[toStringSerializer serializeToString] UTF8String]);   

            /*
             
            int i = 0;
            int j = 0;
            int k = 0;

            
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
        //[innerPool drain];
    } 

    //NSLog(@"Done.");
}

@end

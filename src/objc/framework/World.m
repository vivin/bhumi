#include "World.h"

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
    }

    return self;
}

- (id) initWithName: (NSString*) aName
               rows: (int) aRows
            columns: (int) aColumns 
         iterations: (int) anIterations
   snapshotInterval: (int) aSnapshotInterval {

   if((self = [super init])) {
       [self init];

       [name autorelease];
       name = [aName retain];

       rows = aRows;
       columns = aColumns;
       iterations = anIterations;
       snapshotInterval = aSnapshotInterval;
   }

   return self;
}

- (void) addBug: (Bug*) aBug {

    printf("adding bug\n");

    NSString* layer = [aBug layer];

    int numberOfBugs = 0;
    if([layerBugDictionary objectForKey: layer] == nil) {
        [layerBugDictionary setObject: [NSMutableArray array] forKey: layer];
    } else {
        numberOfBugs = [[layerBugDictionary objectForKey: layer] count];
    }

    if(numberOfBugs == (rows * columns)) {
       [NSException raise:@"Layer is full! Cannot add more layerBugDictionary!" format:@"The %s layer is full! Cannot add more layerBugDictionary", layer];
    } else {
       [[layerBugDictionary objectForKey: layer] addObject: aBug];
    }

    int x = [aBug x];
    int y = [aBug y];

    if([aBug x] == -1) {
        x = arc4random() % columns;
    }

    if([aBug y] == -1) {
        y = arc4random() % rows;
    }

    //arc4random is returning negative numbers for some strange reason
    y = (y < 0) ? y * -1 : y;
    x = (x < 0) ? x * -1 : x;

    if([self isOccupied: layer x: x y: y]) {
        printf("need to find new spot because %i,%i is occupied\n", x, y);
        //That location is already occupied. Let's look for the first non-occupied location.

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
        }

        //This should always hold YES, or something is seriously wrong. We should never be in a situation
        //where we can't find a place to add a new bug because we check to see beforehand if we have enough
        //room in this layer
        NSAssert(rowFound && columnFound, @"There must be enough room to add a new bug");
    }

    [aBug setX: x Y: y];

    //Mark the location in the grid as occupied
    if([grid objectForKey: layer] == nil) {
        [grid setObject: [[NSMutableDictionary alloc] init] forKey: layer];
    }

    NSMutableDictionary* gridColumns = [grid objectForKey: layer];
    if([gridColumns objectForKey: [NSNumber numberWithInt: x]] == nil) {
        [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithInt: x]];
    }

    NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: x]];
    if([gridRows objectForKey: [NSNumber numberWithInt: y]] == nil) {
        [gridRows setObject: aBug forKey: [NSNumber numberWithInt: y]];
    }

    [bugs addObject: aBug];
}

- (void) removeBug: (Bug*) aBug {
    [self removeBug: [aBug layer] x: [aBug x] y: [aBug y]];
}

- (void) removeBug: (NSString*) inLayer
                 x: (int) x
                 y: (int) y {

    if([self isOccupied: inLayer x: x y: y]) {
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

    if([self isOccupied: inLayer x: x y: y]) {
        bug = [[[grid objectForKey: inLayer] objectForKey: [NSNumber numberWithInt: x]] objectForKey: [NSNumber numberWithInt: y]];
    }

    return bug;
}

- (BOOL) moveBug: (NSString*) fromLayer
           fromX: (int) fromX
           fromY: (int) fromY
         toLayer: (NSString*) toLayer 
             toX: (int) toX
             toY: (int) toY {

    BOOL success = NO;

    if(![self isOccupied: toLayer x: toX y: toY]) {

        Bug* bug = [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithInt: fromX]] objectForKey: [NSNumber numberWithInt: fromY]];

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

- (BOOL) isOccupied: (NSString*) inLayer
                  x: (int) x
                  y: (int) y {
    BOOL occupied = NO;

    NSMutableDictionary* gridColumns = [grid objectForKey: inLayer];

    if(gridColumns != nil) {
        NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithInt: x]];

        if(gridRows != nil) {
            Bug* bug = [gridRows objectForKey: [NSNumber numberWithInt: y]];

            if(bug != nil) {
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

    int iteration = 0;

    while(iteration < iterations) {
        
        printf("Iteration %i of %i\n", iteration + 1, iterations);
        
        [bugs shuffle];

        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        NSString* bugLayer = @"FirstLayer";

        while((bug = [bugEnumerator nextObject])) {
            NSString* originalLayer = [bug layer];
            int originalX = [bug x];
            int originalY = [bug y];

            [bug act];

            if(![originalLayer isEqualToString: [bug layer]] || originalX != [bug x] || originalY != [bug y]) {
                [self moveBug: originalLayer fromX: originalX fromY: originalY toLayer: [bug layer] toX: [bug x] toY: [bug y]];
            }
        }

        if(iteration % snapshotInterval == 0) {

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
            }
        }

        iteration++;
        printf("\n");
    }
}

@end

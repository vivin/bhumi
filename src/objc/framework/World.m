#include "World.h"

@implementation

- (id) init {
    self = [super init];

    if((self = [super init])) {
        name = @"";
        grid = [[NSMutableDictionary alloc] init];
        bugs = [[NSMutableDictionary alloc] init]; 
        numberOfBugs = [[NSMutableDictionary alloc] init];
        rows = 0;
        columns = 0;
    }

    return self;
}

- (id) initWithName: (NSString*) aName
               rows: (long) aRows
            columns: (long) aColumns {

   if((self = [super init])) {
       [self init];

       [name autorelease];
       name = [aName retain];

       rows = aRows;
       columns = aColumns;
   }

   return self;
}

- (void) addBug: (Bug*) aBug {

    NSString* layer = [aBug layer];

    @synchronized(numberOfBugs) {
        long numberOfBugsInLayer = 0;
        if([numberOfBugs objectForKey: layer] == nil) {
           [numberOfBugs setObject: [NSNumber numberWithLong: 0] forKey: layer];
        } else {
            numberOfBugsInLayer = [[numberOfBugs objectForKey: layer] longValue];
        }

        //No more room for the new bug :(
        if(numberOfBugsInLayer == (rows * columns)) {
            [NSException raise:@"Layer is full! Cannot add more bugs!" format:@"The %s layer is full! Cannot add more bugs", layer];
        } else {
            [numberOfBugs setObject: [NSNumber numberWithLong: ++numberOfBugsInLayer]];
        }
    }

    @synchronized(bugs) {
        if([bugs objectForKey: layer] == nil) {
            [bugs setObject: [NSMutableArray array] forKey: layer];
        }

        [[bugs objectForKey: layer] addObject: aBug];
    }

    long x = -1;
    long y = -1;

    if([aBug x] == -1) {
        x = arc4random() % columns;
    }

    if([aBug y] == -1) {
        y = arc4random() % rows;
    }

    if(![self isOccupied: layer x: x y: y]) {
        [aBug setX: x setY: y];

        @synchronized(grid) {
            //Mark the location in the grid as occupied
            if([grid objectForKey: layer] == nil) {
                [grid setObject: [[NSMutableDictionary alloc] init] forKey: layer];
            }

            NSMutableDictionary* gridColumns = [grid objectForKey: layer];
            if([gridColumns objectForKey: [NSNumber numberWithLong: x]] == nil) {
                [gridColumns setObject: [[NSMutableDictionary alloc] init] forKey: [NSNumber numberWithLong: x]];
            }

            NSMutableDictionary* gridRows = [gridRows objectForKey: [NSNumber numberWithLong: x]];
            if([gridRows objectForKey: [NSNumber numberWithLong: y]] == nil) {
                [gridRows setObject: [NSNumber numberWithBool: true] forKey: [NSNumber numberWithLong: y]];
            }
        }
    } else {

        @synchronized(grid) {
            //That location is already occupied. Let's look for the first non-occupied location.

            NSMutableDictionary* gridColumns = [grid objectForKey: layer];
            BOOL columnFound = false;
            BOOL rowFound = false;
            long i = 0;
            while(i < columns && !columnFound) {

                NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithLong: i]]
                if(gridRows == nil) {
                    //If the rows entry for this column is null, we don't need to search any further since
                    //it means that we don't have any bugs in this column
                    x = i;
                    y = 0;
                    columnFound = true;
                    rowFound = true;
                } else {
                    //If the column entry is not null, we need to start looking at each row entry in this column.
                    //Each entry here translates to a cell in the grid.
                    long j = 0;
                    while(j < rows && !rowFound) {
                        if([gridRows objectForKey: [NSNumber numberWithLong: j]] == nil) {
                            y = j;
                            columnFound = true;
                            rowFound = true;
                        }

                        j++;
                    }
                }

                i++;
            }
        }

        //This should always hold true, or something is seriously wrong. We should never be in a situation
        //where we can't find a place to add a new bug because we check to see beforehand if we have enough
        //room in this layer
        NSAssert((rowFound == true) && (columnFound == true));
        [aBug setX: x setY: y];
    }
}

- (void) addBug: (Bug*) aBug
       andStart: (BOOL) start {

    [self addBug: aBug];

    if(start) {
        //TODO start a new thread
    }
}

- (NSArray*) bugs: (NSString*) inLayer {
    @synchronized(bugs) {
        return [bugs objectForKey: inLayer];
    }
}

- (long) numberOfBugs: (NSString*) inLayer {
    long numberOfBugsInLayer = 0;

    @synchronized(numberOfBugs) {
        if([numberOfBugs objectForKey: inLayer] != nil) {
            numberOfBugsInLayer = [[numberOfBugs objectForKey: inLayer] longValue];
        }
    }

    return numberOfBugsInLayer;
}

- (NSArray*) layers {
    @synchronized(bugs) {
        return [bugs: allKeys];
    }
}

- (BOOL) isOccupied: (NSString*) inLayer
                  x: (long) x
                  y: (long) y {
    BOOL occupied = false;

    @synchronized(bugs) {
        NSMutableDictionary* gridColumns = [grid objectForKey: layer];

        if(gridColumns != nil) {
            NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithLong: x]];

            if(gridRows != nil) {
                NSNumber* cell = [gridRows objectForKey: [NSNumber numberWithLong: y]];
                occupied = (cell != nil) && [cell boolValue]
            }
        }
    }

    return occupied;
}

- (BOOL) isOccupied: (long) x
                  y: (long) y {

   @synchronized(bugs) {
       NSEnumerator* enumerator = [bugs keyEnumerator];
       id key;
       BOOL occupied = false;

       while((key = [enumerator nextObject]) && !occupied) {
           occupied = [self isOccupied: key x: x y: y]
       }
   }
}

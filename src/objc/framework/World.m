#include "World.h"

@implementation World

- (id) init {
    self = [super init];

    if((self = [super init])) {
        name = @"";
        grid = [[NSMutableDictionary alloc] init];
        bugs = [[NSMutableDictionary alloc] init]; 
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

    [aBug retain];
    NSString* layer = [aBug layer];

    @synchronized(bugs) {
        long numberOfBugs = 0;
        if([bugs objectForKey: layer] == nil) {
            [bugs setObject: [NSMutableArray array] forKey: layer];
        } else {
            numberOfBugs = [[bugs objectForKey: layer] count];
        }

        if(numberOfBugs == (rows * columns)) {
           [NSException raise:@"Layer is full! Cannot add more bugs!" format:@"The %s layer is full! Cannot add more bugs", layer];
        } else {
           [[bugs objectForKey: layer] addObject: aBug];
        }
    }

    long x = [aBug x];
    long y = [aBug y];

    if([aBug x] == -1) {
        x = arc4random() % columns;
    }

    if([aBug y] == -1) {
        y = arc4random() % rows;
    }

    @synchronized(grid) {
        if([self isOccupied: layer x: x y: y]) {
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
        NSAssert(rowFound && columnFound);
    }

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
            [gridRows setObject: aBug forKey: [NSNumber numberWithLong: y]];
        }
    }
}

- (void) addBug: (Bug*) aBug
       andStart: (BOOL) start {

    [self addBug: aBug];

    if(start) {
        [aBug act];
    }
}

- (void) removeBug: (Bug*) aBug {
    [self removeBug: [aBug layer] x: [aBug x] y: [aBug y]];
}

- (void) removeBug: (NSString*) inLayer
                 x: (long) x
                 y: (long) y {

    @synchronized(grid) {
        if([self isOccupied: inLayer x: x y: y]) {
            Bug* bug = [[[grid objectForKey: layer] objectForKey: [NSNumber numberWithLong: x]] objectForKey: [NSNumber numberWithLong: y]];
            [bug kill]; 

            [[[grid objectForKey: layer] objectForKey: [NSNumber numberWithLong: x]] setObject: nil forKey: [NSNumber numberWithLong: y]];

            @synchronized(bugs) {
                NSMutableArray* bugsInLayer = [bugs objectForKey: inLayer];
                NSEnumerator* bugEnumuerator = [bugsInLayer objectEnumerator];
                Bug* aBug;
                BOOL found = false;
                int i = 0;

                while((aBug = [bugEnumerator nextObject]) && !found) {
                    found = (bug == aBug);
                    i++;
                }

                //We must always find the bug we are looking for!
                NSAssert(found);

                [bugsInLayer removeObjectAtIndex: i--];
            }
            [bug release];
        }
    }
}

- (BOOL) moveBug: (NSString*) fromLayer
           fromX: (long) fromX
           fromY: (long) fromY
         toLayer: (NSString*) toLayer 
             toX: (long) toX
             toY: (long) toY {

    BOOL success = false;

    @synchronized(grid) {
        if(![self isOccupied: toLayer x: toX y: toY]) {

            Bug* bug = [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithLong: fromX]] objectForKey: [NSNumber numberWithLong: fromY]];
            
            @synchronized(bugs) {
                if(![toLayer isEqualToString: fromLayer]) {
                    NSMutableArray* bugsInLayer = [bugs objectForKey: fromLayer];
                    NSEnumerator* bugEnumuerator = [bugsInLayer objectEnumerator];
                    Bug* aBug;
                    BOOL found = false;
                    int i = 0;

                    while((aBug = [bugEnumerator nextObject]) && !found) {
                        found = (bug == aBug);
                        i++;
                    }

                    //We must always find the bug we are looking for!
                    NSAssert(found);

                    [bugsInLayer removeObjectAtIndex: i--];
                    [[bugs objectForKey: toLayer] addObject: bug];
                }

                [[[grid objectForKey: fromLayer] objectForKey: [NSNumber numberWithLong: fromX]] setObject: nil forKey: [NSNumber numberWithLong: fromY]];
                [[[grid objectForKey: toLayer] objectForKey: [NSNumber numberWithLong: toX]] setObject: bug forKey: [NSNumber numberWithLong: toY]];
            }
        }
    }
}

- (NSArray*) bugs: (NSString*) inLayer {
    @synchronized(bugs) {
        return [bugs objectForKey: inLayer];
    }
}

- (long) numberOfBugs: (NSString*) inLayer {
    long numberOfBugs = 0;

    @synchronized(bugs) {
        if([bugs objectForKey: inLayer] != nil) {
            numberOfBugs = [[bugs objectForKey: inLayer] count];
        }
    }

    return numberOfBugs;
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

    @synchronized(grid) {
        NSMutableDictionary* gridColumns = [grid objectForKey: layer];

        if(gridColumns != nil) {
            NSMutableDictionary* gridRows = [gridColumns objectForKey: [NSNumber numberWithLong: x]];

            if(gridRows != nil) {
                Bug* bug = [gridRows objectForKey: [NSNumber numberWithLong: y]];
                occupied = (bug != nil);
            }
        }
    }

    return occupied;
}

- (BOOL) isOccupied: (long) x
                  y: (long) y {

    @synchronized(grid) {
        NSEnumerator* enumerator = [grid keyEnumerator];
        id key;
        BOOL occupied = false;
 
        while((key = [enumerator nextObject]) && !occupied) {
           occupied = [self isOccupied: key x: x y: y];
        }
    }
}

- (BOOL) isRunning {
    return running;
}

- (BOOL) clear: (NSString*) inLayer {
    @synchronized(grid) {
        NSMutableDictionary* gridColumns = [grid objectForKey: layer];

        if(gridColumns != nil) {
            NSEnumerator* xEnumerator [gridColumns keyEnumerator];
            NSNumber* x;

            while((x = [xEnumerator nextObject])) {
                NSMutableDictionary *gridRows = [gridColumns objectForKey: x];
                NSEnumerator *yEnumator = [gridRows keyEnumerator];
                NSNumber* y;

                while((y = [yEnumerator nextObject])) {
                    [self removeBug: inLayer x: x y: y];
                }
            }

            @synchronized(bugs) {
                NSMutableArray* bugsInLayer = [bugs objectForKey: layer];
                NSEnumerator* bugEnumuerator = [bugsInLayer objectEnumerator];
                Bug* aBug;

                while((aBug = [bugEnumerator nextObject])) {
                    [aBug kill];
                }
            }
        }
    }
}

- (BOOL) clear: (NSString*) inLayer {
    @synchronized(grid) {
        NSMutableDictionary* enumerator = [grid keyEnumerator];
        id key;

        while((key = [enumerator nextObject])) {
            [self clear: key];
        }
    }
}

- (void) start {
    @synchronized(bugs) {
        NSEnumerator* enumerator = [bugs keyEnumerator];
        NSString* layer;

        while((layer = [enumerator nextObject])) {
            NSMutableArray* bugsInLayer = [bugs objectForKey: layer];
            NSEnumerator* bugEnumuerator = [bugsInLayer objectEnumerator];
            Bug* aBug;

            while((aBug = [bugEnumerator nextObject])) {
                [aBug act];
            }
        }
    }
}

- (void) stop {
    @synchronized(bugs) {
        NSEnumerator* enumerator = [bugs keyEnumerator];
        NSString* layer;

        while((layer = [enumerator nextObject])) {
            NSMutableArray* bugsInLayer = [bugs objectForKey: layer];
            NSEnumerator* bugEnumuerator = [bugsInLayer objectEnumerator];
            Bug* aBug;

            while((aBug = [bugEnumerator nextObject])) {
                [aBug stop];
            }
        }
    }
}

@end

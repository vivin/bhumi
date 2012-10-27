//
// Created by vivin on 9/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "InfectableNonLinearBug.h"
#import "World.h"

@implementation InfectableNonLinearBug

@synthesize state;
@synthesize infectionStartIteration;
@synthesize incubationPeriod;
@synthesize infectionPeriod;
@synthesize infectionRadius;
@synthesize alertRadius;
@synthesize mortalityRate;

- (id) initWithWorld: (World *) aWorld name: (NSString *) aName layer: (NSString *) aLayer state: (InfectableNonLinearBugState) aState incubationPeriod: (NSUInteger) anIncubationPeriod infectionPeriod: (NSUInteger) anInfectionPeriod infectionRadius: (NSUInteger) anInfectionRadius alertRadius: (NSUInteger) anAlertRadius mortalityRate: (NSUInteger) aMortalityRate {

    if((self = [super initWithWorld: aWorld
                               name: aName
                              layer: aLayer])) {
        state = aState;
        incubationPeriod = anIncubationPeriod;
        infectionPeriod = anInfectionPeriod;
        infectionRadius = anInfectionRadius;
        alertRadius = anAlertRadius;
        mortalityRate = aMortalityRate;

        if(state == INFECTED || state == INFECTIOUS) {
            infectionStartIteration = 1;
        }

        _possibleDirectionDeltas = [[NSMutableArray alloc] init];
        _alertScanLocationDeltas = [[NSMutableArray alloc] init];
        _infectionScanLocationDeltas = [[NSMutableArray alloc] init];

        for(NSInteger _x = -1; _x <= 1; _x++) {
            for(NSInteger _y = -1; _y <= 1; _y++) {
                struct FixedPoint possibleDirectionPoint;
                possibleDirectionPoint.x = _x;
                possibleDirectionPoint.y = _y;

               [_possibleDirectionDeltas addObject: [NSValue valueWithBytes: &possibleDirectionPoint objCType: @encode(FixedPoint)]];
            }
        }
                                   
        for(NSInteger _x = (NSInteger) alertRadius * -1; _x <= (NSInteger) alertRadius; _x++) {
            for(NSInteger _y = (NSInteger) alertRadius * -1; _y <= (NSInteger) alertRadius; _y++) {
                struct FixedPoint alertScanPoint;
                alertScanPoint.x = _x;
                alertScanPoint.y = _y;

               [_alertScanLocationDeltas addObject: [NSValue valueWithBytes: &alertScanPoint objCType: @encode(FixedPoint)]];
            }
        }

        for(NSInteger _x = (NSInteger) infectionRadius * -1; _x <= (NSInteger) infectionRadius; _x++) {
            for(NSInteger _y = (NSInteger) infectionRadius * -1; _y <= (NSInteger) infectionRadius; _y++) {
                struct FixedPoint infectionScanPoint;
                infectionScanPoint.x = _x;
                infectionScanPoint.y = _y;

               [_infectionScanLocationDeltas addObject: [NSValue valueWithBytes: &infectionScanPoint objCType: @encode(FixedPoint)]];
            }
        }
    }

    return self;
}

+ (id) objectWithWorld: (World *) aWorld name: (NSString *) aName layer: (NSString *) aLayer state: (InfectableNonLinearBugState) aState incubationPeriod: (NSUInteger) anIncubationPeriod infectionPeriod: (NSUInteger) anInfectionPeriod infectionRadius: (NSUInteger) anInfectionRadius alertRadius: (NSUInteger) anAlertRadius mortalityRate: (NSUInteger) aMortalityRate {
    return [[InfectableNonLinearBug alloc] initWithWorld: aWorld name: aName layer: aLayer state: aState incubationPeriod: anIncubationPeriod infectionPeriod: anInfectionPeriod infectionRadius: anInfectionRadius alertRadius: anAlertRadius mortalityRate: aMortalityRate];
}

- (void) act {

    NSInteger iterationDelta = [self.world currentIteration] - infectionStartIteration;

    if((state == INFECTED || state == INFECTIOUS) && iterationDelta > (NSInteger) incubationPeriod) {
        state = INFECTIOUS;

        NSArray* bugs = [self scanForState: HEALTHY];
        //NSLog(@"Found %li infectable bugs", [bugs count]);

        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        InfectableNonLinearBug* bug;
        while((bug = [bugEnumerator nextObject])) {
            [bug infect];
        }
    }

    if(state == INFECTIOUS && iterationDelta > (NSInteger) (incubationPeriod + infectionPeriod)) {
        NSUInteger number = arc4random() % 100;

        if(number <= mortalityRate) {
            self.alive = NO;
        } else {
            state = IMMUNE;
        }
    }

    if(self.alive == YES) {

        [_possibleDirectionDeltas shuffle];

        NSArray* bugs = [self scanForState: INFECTIOUS];

        NSUInteger rows = [self.world rows];
        NSUInteger columns = [self.world columns];

        if([bugs count] > 0 && state != IMMUNE) {

            NSMutableArray* distancesFromCurrentPosition = [[NSMutableArray alloc] init];
            NSEnumerator* bugEnumerator = [bugs objectEnumerator];
            InfectableNonLinearBug* bug;

            //NSLog(@"%@ needs to get out of here", self.name);
            //NSLog(@"%@ state is %@ and is at %lu:%lu", self.name, state == HEALTHY ? @"healthy" : @"infected", self.x, self.y);

            while((bug = [bugEnumerator nextObject])) {
                NSInteger dx = self.x - [bug x];
                NSInteger dy = self.y - [bug y];
                NSNumber* distance = [NSNumber numberWithDouble: sqrt((dx * dx) + (dy * dy))];

                [distancesFromCurrentPosition addObject: distance];
            }

            NSUInteger numberOfFurtherPoints = 0;
            struct FixedPoint furthest;
            furthest.x = 0;
            furthest.y = 0;

            NSEnumerator* directionDeltaEnumerator = [_possibleDirectionDeltas objectEnumerator];
            NSValue* directionDeltaValue;
            BOOL furthestPointFound = NO;

            while ((directionDeltaValue = [directionDeltaEnumerator nextObject])) {

                struct FixedPoint directionDelta;
                [directionDeltaValue getValue: &directionDelta];

                NSMutableArray* distancesFromDeltaPosition = [[NSMutableArray alloc] init];

                NSInteger _x = self.x + directionDelta.x;
                NSInteger _y = self.y + directionDelta.y;

                _x %= columns; if(_x < 0) _x += columns;
                _y %= rows; if(_y < 0) _y += rows;

                if([self.world isLocationOccupiedInLayer: self.layer atX: (NSUInteger) _x atY: (NSUInteger) _y] == NO) {

                    bugEnumerator = [bugs objectEnumerator];
                    while((bug = [bugEnumerator nextObject])) {
                        NSInteger dx = _x - [bug x];
                        NSInteger dy = _y - [bug y];
                        NSNumber* distance = [NSNumber numberWithDouble: sqrt((dx * dx) + (dy * dy))];

                        [distancesFromDeltaPosition addObject: distance];
                    }

                    NSUInteger numberOfFurtherPointsForDelta = 0;
                    for(NSUInteger i = 0; i < [distancesFromCurrentPosition count]; i++) {
                        if([[distancesFromDeltaPosition objectAtIndex: i] doubleValue] > [[distancesFromCurrentPosition objectAtIndex: i] doubleValue]) {
                            numberOfFurtherPointsForDelta++;
                        }
                    }

                    if(numberOfFurtherPointsForDelta > numberOfFurtherPoints) {
                        furthest.x = _x;
                        furthest.y = _y;
                        numberOfFurtherPoints = numberOfFurtherPointsForDelta;
                        furthestPointFound = YES;
                    }
                }
            }

            if(furthestPointFound == YES) {
                self.x = (NSUInteger) furthest.x;
                self.y = (NSUInteger) furthest.y;
            }

        } else {

            NSUInteger i = 0;
            BOOL found = NO;

            do {

                NSInteger _x = self.x;
                NSInteger _y = self.y;

                struct FixedPoint point;
                [[_possibleDirectionDeltas objectAtIndex: i] getValue: &point];

                _x += point.x;
                _y += point.y;

                _x %= columns; if(_x < 0) _x += columns;
                _y %= rows; if(_y < 0) _y += rows;

                found = ([self.world isLocationOccupiedInLayer: self.layer atX: _x atY: _y] == NO);

                if(found) {
                    self.x = _x;
                    self.y = _y;
                }

                i++;

            } while(!found && i < [_possibleDirectionDeltas count]);
        }
    }
}

- (NSArray *) scanForState: (InfectableNonLinearBugState) bugState {
    NSMutableArray* bugsWithStateWithinInfectionRadius = [[NSMutableArray alloc] init];

    NSMutableArray* scanLocationDeltas;

    if(bugState == HEALTHY) {
        scanLocationDeltas = _alertScanLocationDeltas;
    } else {
        scanLocationDeltas = _infectionScanLocationDeltas;
    }

    NSEnumerator* scanLocationDeltaEnumerator = [scanLocationDeltas objectEnumerator];
    NSValue* scanLocationDeltaValue;

    while((scanLocationDeltaValue = [scanLocationDeltaEnumerator nextObject])) {
        struct FixedPoint scanLocationDelta;
        [scanLocationDeltaValue getValue: &scanLocationDelta];

        NSInteger rows = [self.world rows];
        NSInteger columns = [self.world columns];

        NSInteger scanX = self.x + scanLocationDelta.x;
        NSInteger scanY = self.y + scanLocationDelta.y;

        scanX %= columns; if(scanX < 0) scanX += columns;
        scanY %= rows; if(scanY < 0) scanY += rows;

        double distance = sqrt((scanLocationDelta.x * scanLocationDelta.x) + (scanLocationDelta.y * scanLocationDelta.y));

        //NSLog(@"Checking %i:%i. Distance to that location is %f", scanX, scanY, distance);

        if(distance <= infectionRadius && distance > 0) {
            NSArray* bugs = [self.world getBugsAtX: (NSUInteger) scanX atY: (NSUInteger) scanY];

            //NSLog(@"Distance is smaller than infection radius. The number of bugs at this location is %i", [bugs count]);

            if([bugs count] > 0) {
                //Let's only get the uninfected bugs

                NSEnumerator* bugEnumerator = [bugs objectEnumerator];
                InfectableNonLinearBug* bug;

                while((bug = [bugEnumerator nextObject])) {
                    //NSLog(@"%@ infected: %@", [bug name], [bug infected] ? @"yes" : @"no");
                    if([bug state] == bugState) {
                        //NSLog(@"Bug in that location is not infected so I am going to add");
                        [bugsWithStateWithinInfectionRadius addObject: bug];
                    }
                }
            }
        }
    }

    return bugsWithStateWithinInfectionRadius;
}

- (void) infect {
    state = INFECTED;
    infectionStartIteration = [self.world currentIteration];
}

@end
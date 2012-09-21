#import "InfectableBug.h"
#import "../framework/World.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>

@class World;
@class BugToStringSerializer;

@implementation InfectableBug

@synthesize infected;
@synthesize infectionRadius;
@synthesize incubationPeriod;
@synthesize infectionStartIteration;

- (id)    initWithWorld: (World*) aWorld
                   name: (NSString*) aName
                  layer: (NSString*) aLayer
               infected: (BOOL) anInfected
        infectionRadius: (NSUInteger) anInfectionRadius
       incubationPeriod: (NSUInteger) anIncubationPeriod
infectionStartIteration: (NSUInteger) anInfectionStartIteration {

    if((self = [super initWithWorld: aWorld
                               name: aName
                              layer: aLayer])) {
        infected = anInfected;
        infectionRadius = anInfectionRadius;
        incubationPeriod = anIncubationPeriod;
        infectionStartIteration = anInfectionStartIteration;
    }

    return self;
}

- (void) act {

    NSUInteger rows = [self.world rows];
    NSUInteger columns = [self.world columns];

//    if(infected) {
//        NSLog(@"%@ is infected", name);
//        NSLog(@"infection started in iteration %i. Current iteration is %i. Incubation period is %i. Iterations since infection is %i", infectionStartIteration, [self.world currentIteration], incubationPeriod, [self.world currentIteration] - infectionStartIteration);
//    }

    if(infected && ([self.world currentIteration] - infectionStartIteration) > incubationPeriod) {

//        NSLog(@"Going to find bugs to infect!");

        NSArray* uninfectedBugsWithinInfectionRadius = [self scan];

//        NSLog(@"There are %i uninfected bugs within the infection radius of %i", [uninfectedBugsWithinInfectionRadius count], infectionRadius);

        NSEnumerator* bugEnumerator = [uninfectedBugsWithinInfectionRadius objectEnumerator];
        InfectableBug* bug;
        while((bug = [bugEnumerator nextObject])) {
            [bug infect];
        }
    }

    do {

        NSInteger _x = 0;
        NSInteger dx = (arc4random() % 3) - 1;
        _x += dx;

        NSInteger _y = 0;
        NSInteger dy = (arc4random() % 3) - 1;
        _y += dy;

        _x %= rows; if(_x < 0) _x += rows;
        _y %= columns; if(_y < 0) _y += columns;

        self.x = _x;
        self.y = _y;

    } while([self.world isLocationOccupiedInLayer: self.layer atX: self.x atY: self.y]);

//    [actPool drain];
}

- (NSArray*) scan {

    NSMutableArray* uninfectedBugsWithinInfectionRadius = [[NSMutableArray alloc] init];

    for(NSInteger i = 1; i <= infectionRadius; i++) {
        for(NSInteger _x = -i; _x <= i; _x++) {
            for(NSInteger _y = -i; _y <= i; _y++) {

                NSInteger rows = [self.world rows];
                NSInteger columns = [self.world columns];

                NSInteger scanX = self.x + _x;
                NSInteger scanY = self.y + _y;

                scanX %= rows; if(scanX < 0) scanX += rows;
                scanY %= columns; if(scanY < 0) scanY += columns;

                double distance = sqrt((_x * _x) + (_y * _y));

                //NSLog(@"Checking %i:%i. Distance to that location is %f", scanX, scanY, distance);

                if(distance <= infectionRadius && distance > 0) {
                    NSArray* bugs = [self.world getBugsAtX: (NSUInteger) scanX atY: (NSUInteger) scanY];

                    //NSLog(@"Distance is smaller than infection radius. The number of bugs at this location is %i", [bugs count]);
                    
                    if([bugs count] > 0) {
                        //Let's only get the uninfected bugs
                        
                        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
                        InfectableBug* bug;

                        while((bug = [bugEnumerator nextObject])) {
                            //NSLog(@"%@ infected: %@", [bug name], [bug infected] ? @"yes" : @"no");
                            if([bug infected] == NO) {
                                //NSLog(@"Bug in that location is not infected so I am going to add");
                                [uninfectedBugsWithinInfectionRadius addObject: bug];
                            }
                        }
                    }
                }
            }
        }
    }

    return uninfectedBugsWithinInfectionRadius;
}

- (void) infect {
    infected = YES;
    infectionStartIteration = [self.world currentIteration];
}

@end

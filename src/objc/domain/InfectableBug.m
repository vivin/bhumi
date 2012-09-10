#import "InfectableBug.h"
#import "../framework/World.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>

@class World;
@class BugToStringSerializer;

@implementation InfectableBug

- (id)    initWithWorld: (World*) aWorld
                   name: (NSString*) aName
                  layer: (NSString*) aLayer
               infected: (BOOL) anInfected
        infectionRadius: (int) anInfectionRadius
       incubationPeriod: (int) anIncubationPeriod
infectionStartIteration: (int) anInfectionStartIteration
     serializerClass: (Class) serializerClass {

    if((self = [super initWithWorld: aWorld
                               name: aName
                              layer: aLayer
                    serializerClass: serializerClass])) {

    }

    infected = anInfected;
    infectionRadius = anInfectionRadius;
    incubationPeriod = anIncubationPeriod;
    infectionStartIteration = anInfectionStartIteration;
    
    return self;
}

- (void) act {

    NSAutoreleasePool *actPool = [[NSAutoreleasePool alloc] init];

    int rows = [world rows];
    int columns = [world columns];

//    if(infected) {
//        NSLog(@"%@ is infected", name);
//        NSLog(@"infection started in iteration %i. Current iteration is %i. Incubation period is %i. Iterations since infection is %i", infectionStartIteration, [world currentIteration], incubationPeriod, [world currentIteration] - infectionStartIteration);
//    }

    if(infected && ([world currentIteration] - infectionStartIteration) > incubationPeriod) {

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
        int _x = (arc4random() % 3);
        _x = (_x < 0) ? _x * -1 : _x;

        int _y = (arc4random() % 3);
        _y = (_y < 0) ? _y * -1 : _y;

        x += _x - 1;
        y += _y - 1;

        //Straight forward mod doesn't work with negative numbers
        x %= rows; if(x < 0) x += rows;
        y %= columns; if(y < 0) y += columns;

    } while([world isOccupied: layer x: x y: y]); 

    [actPool drain];
}

- (NSArray*) scan {

    NSMutableArray* uninfectedBugsWithinInfectionRadius = [[NSMutableArray alloc] init];

    for(int i = 1; i <= infectionRadius; i++) {
        for(int _x = -i; _x <= i; _x++) {
            for(int _y = -i; _y <= i; _y++) {

                int rows = [world rows];
                int columns = [world columns];

                int scanX = x + _x;
                int scanY = y + _y;

                scanX %= rows; if(scanX < 0) scanX += rows;
                scanY %= columns; if(scanY < 0) scanY += columns;

                double distance = sqrt((_x * _x) + (_y * _y));

                //NSLog(@"Checking %i:%i. Distance to that location is %f", scanX, scanY, distance);

                if(distance <= infectionRadius && distance > 0) {
                    NSArray* bugs = [world getBugs: scanX y: scanY];

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

    return [uninfectedBugsWithinInfectionRadius autorelease];
}

- (void) infect {
    infected = YES;
    infectionStartIteration = [world currentIteration];
}

- (BOOL) infected {
    return infected;
}

- (int) infectionRadius {
    return infectionRadius;
}

- (int) incubationPeriod {
    return incubationPeriod;
}

@end

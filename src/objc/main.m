#include <stdio.h>
#import <Cocoa/Cocoa.h>
#import "framework/World.h"
#import "domain/RandomBug.h"


int main(void) {
 
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    World* world = [[World alloc] initWithName: @"Bhumi"
                                          rows: 10
                                       columns: 10
                                    iterations: 100
                              snapshotInterval: 1];
   

    Bug* randomBug = [[RandomBug alloc] initWithWorld: world
                                                 name: @"RandomBug"
                                                layer: @"FirstLayer"];

    Bug* randomBug2 = [[RandomBug alloc] initWithWorld: world
                                                  name: @"RandomBug"
                                                 layer: @"FirstLayer"];

    [world addBug: randomBug];
    [world addBug: randomBug2];

    [world start];

    // drain the autorelease pool
    [pool drain];
    // execution never gets here ..
    return 0;
}

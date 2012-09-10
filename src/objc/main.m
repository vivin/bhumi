#include <stdio.h>
#import <Cocoa/Cocoa.h>
#import "framework/World.h"
#import "framework/WorldJsonSerializer.h"
//#import "domain/RandomBug.h"
//#import "domain/RandomBugJsonSerializer.h"
#import "domain/InfectableBug.h"
#import "domain/InfectableBugJsonSerializer.h"

int main(void) {

    // Set permissions for our NSLog file
    umask(022);
    // Send stderr to our file
    FILE *newStderr = freopen("/tmp/bhumi.log", "a", stderr);

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    World* world = [[World alloc] initWithName: @"Bhumi"
                                          rows: 100
                                       columns: 100
                                    iterations: 2000
                              snapshotInterval: 1
                               serializerClass: [WorldJsonSerializer class]];

    /*

    Bug* randomBug = [[RandomBug alloc] initWithWorld: world
                                                 name: @"RandomBug0"
                                                layer: @"FirstLayer"
                                      serializerClass: [RandomBugJsonSerializer class]];

    Bug* randomBug2 = [[RandomBug alloc] initWithWorld: world
                                                  name: @"RandomBug2"
                                                 layer: @"FirstLayer"
                                       serializerClass: [RandomBugJsonSerializer class]];

    [world addBug: randomBug];
    [world addBug: randomBug2];

    */

    NSLog(@"Start");

    for(int i = 0; i < 999; i++) {
        NSMutableString* name = [NSMutableString stringWithString: @"HealthyBug"];
        [name appendString: [[NSNumber numberWithInt: i] stringValue]];
        [world addBug: [[InfectableBug alloc] initWithWorld: world
                                                       name: name
                                                      layer: @"FirstLayer"
                                                   infected: NO
                                            infectionRadius: 1
                                           incubationPeriod: 10
                                    infectionStartIteration: 0
                                            serializerClass: [InfectableBugJsonSerializer class]]];
    }

    NSLog(@"Added all bugs. Going to add infected");

    [world addBug: [[InfectableBug alloc] initWithWorld: world
                                                   name: @"InfectedBug"
                                                  layer: @"FirstLayer"
                                               infected: YES
                                        infectionRadius: 1
                                       incubationPeriod: 10
                                infectionStartIteration: 0
                                        serializerClass: [InfectableBugJsonSerializer class]]];

    NSLog(@"Added infected. Going to start world");
//    @try {
        [world start];
//    } @catch(NSException* ex) {
//        NSLog(@"%@", [ex callStackSymbols]);
//    }
    // drain the autorelease pool
    NSLog(@"Going to drain pool");
  //  [pool drain]; //THIS CAUSES A SEGFAULT... WHY???
    // execution never gets here ..
    return 0;
}

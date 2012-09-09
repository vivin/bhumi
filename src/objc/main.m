#include <stdio.h>
#import <Cocoa/Cocoa.h>
#import "framework/World.h"
#import "framework/WorldJsonSerializer.h"
#import "domain/RandomBug.h"
#import "domain/RandomBugJsonSerializer.h"

int main(void) {
 
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    World* world = [[World alloc] initWithName: @"Bhumi"
                                          rows: 100
                                       columns: 100
                                    iterations: 100
                              snapshotInterval: 1
                               serializerClass: [WorldJsonSerializer class]];


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

    [world start];

    // drain the autorelease pool
    [pool drain];
    // execution never gets here ..
    return 0;
}

//
//  MasterViewController.m
//  Bhumi
//
//  Created by Vivin Paliath on 10/1/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "MasterViewController.h"
#import "World.h"
#import "InfectableBug.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _worldView = [[WorldView alloc] init];

        World* world = [[World alloc] initWithName: @"Bhumi"
                                              rows: 192
                                           columns: 256
                                        iterations: 2000
                                  snapshotInterval: 1
                                       interceptor: _worldView];
        for(int i = 0; i < 9999; i++) {
            NSMutableString* name = [NSMutableString stringWithString: @"HealthyBug"];
            [name appendString: [[NSNumber numberWithInt: i] stringValue]];
            [world addBug: [[InfectableBug alloc] initWithWorld: world
                                                           name: name
                                                          layer: @"FirstLayer"
                                                       infected: NO
                                                infectionRadius: 5
                                               incubationPeriod: 10
                                        infectionStartIteration: 0]];
        }

        NSLog(@"Added all bugs. Going to add infected");

        [world addBug: [[InfectableBug alloc] initWithWorld: world
                                                       name: @"InfectedBug"
                                                      layer: @"FirstLayer"
                                                   infected: YES
                                            infectionRadius: 5
                                           incubationPeriod: 10
                                    infectionStartIteration: 0]];

        [_worldView setWorld: world];

        NSArray* bugs = [world bugs];
        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        NSLog(@"Sanity check!");
        while((bug = [bugEnumerator nextObject])) {
            Bug* oBug = [world getBugInLayer: [bug layer] atX: [bug x] atY: [bug y]];

            if(oBug != bug) {
                NSLog(@"Bug %@ says its location is %lu:%lu, but the bug at that location is %@", [bug name], [bug x], [bug y], [oBug name]);
            }
        }

        //[world start];
    }

    return self;
}

- (NSView*) view {
    return self.worldView;
}

@end


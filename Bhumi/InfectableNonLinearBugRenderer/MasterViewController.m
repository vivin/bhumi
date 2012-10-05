//
//  MasterViewController.m
//  Bhumi
//
//  Created by Vivin Paliath on 9/24/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "MasterViewController.h"
#import "World.h"
#import "InfectableNonLinearBug.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _infectableNonLinearBugView = [[InfectableNonLinearBugView alloc] init];

        //NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath: @"/Users/vivin/locs.txt"];

        World* world = [[World alloc] initWithName: @"Bhumi"
                                              rows: 96
                                           columns: 128
                                        iterations: 2000
                                  snapshotInterval: 1
                                       interceptor: _infectableNonLinearBugView];
        for(int i = 0; i < 2303; i++) {
            NSMutableString* name = [NSMutableString stringWithString: @"HealthyBug"];
            [name appendString: [[NSNumber numberWithInt: i] stringValue]];
            [world addBug: [[InfectableNonLinearBug alloc] initWithWorld: world
                                                           name: name
                                                          layer: @"FirstLayer"
                                                          state: HEALTHY
                                               incubationPeriod: 5
                                                infectionPeriod: 5
                                                infectionRadius: 3
                                                    alertRadius: 3
                                                  mortalityRate: 25]];
            /*
            NSMutableString* str = [NSMutableString stringWithString:  @""];
            for(NSUInteger a = 0; a < 128; a++) {
                for(NSUInteger b = 0; b < 96; b++) {
                    if([world isLocationOccupiedInLayer: @"FirstLayer" atX: a atY: b] == YES) {
                        [str appendString: [NSString stringWithFormat: @"%li:%li:%@#", a, b, @"y"]];
                    } else {
                        [str appendString: [NSString stringWithFormat: @"%li:%li:%@#", a, b, @"n"]];
                    }
                }
            } */

            //[str appendString: @"\n"];
            //[fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            /*
            NSArray* bugs = [world bugs];
            NSEnumerator* bugEnumerator = [bugs objectEnumerator];
            Bug* bug;

            NSLog(@"Sanity check!");
            while((bug = [bugEnumerator nextObject])) {
                Bug* oBug = [world getBugInLayer: [bug layer] atX: [bug x] atY: [bug y]];

                if(oBug != bug) {
                    NSLog(@"Bug %@ says its location is %lu:%lu, but the bug at that location is %@", [bug name], [bug x], [bug y], [oBug name]);
                }
            } */
        }

        //[fileHandle closeFile];

        NSLog(@"Added all bugs. Going to add infected");

            [world addBug: [[InfectableNonLinearBug alloc] initWithWorld: world
                                                           name: @"InfectedBug"
                                                          layer: @"FirstLayer"
                                                          state: INFECTED
                                               incubationPeriod: 5
                                                infectionPeriod: 5
                                                infectionRadius: 3
                                                    alertRadius: 3
                                                  mortalityRate: 25]];

        [_infectableNonLinearBugView setWorld: world];


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
    return self.infectableNonLinearBugView;
}

@end

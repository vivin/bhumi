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

        /*
                       state: (InfectableNonLinearNonLinearBugState) aState
    incubationPeriod: (NSUInteger) anIncubationPeriod
     infectionPeriod: (NSUInteger) anInfectionPeriod
     infectionRadius: (NSUInteger) anInfectionRadius
         alertRadius: (NSUInteger) anAlertRadius
       mortalityRate: (NSUInteger) aMortalityRate;
         */

        World* world = [[World alloc] initWithName: @"Bhumi"
                                              rows: 96
                                           columns: 128
                                        iterations: 2000
                                  snapshotInterval: 1
                                       interceptor: _infectableNonLinearBugView];
        for(int i = 0; i < 999; i++) {
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
                                                  mortalityRate: 10]];
        }

        NSLog(@"Added all bugs. Going to add infected");

            [world addBug: [[InfectableNonLinearBug alloc] initWithWorld: world
                                                           name: @"InfectedBug"
                                                          layer: @"FirstLayer"
                                                          state: INFECTED
                                               incubationPeriod: 5
                                                infectionPeriod: 5
                                                infectionRadius: 3
                                                    alertRadius: 3
                                                  mortalityRate: 10]];

        [_infectableNonLinearBugView setWorld: world];

        //[world start];
    }

    return self;
}

- (NSView*) view {
    return self.infectableNonLinearBugView;
}

@end

//
//  ViewController.m
//  InfectableNonLinearBugMobileRenderer
//
//  Created by Vivin Paliath on 10/27/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "ViewController.h"
#import "World.h"
#import "InfectableNonLinearBug.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a niballoc] init];
    
    //NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath: @"/Users/vivin/locs.txt"];
    
    World* world = [[World alloc] initWithName: @"Bhumi"
                                          rows: 96
                                       columns: 128
                                    iterations: 1500
                              snapshotInterval: 1
                                   interceptor: (InfectableNonLinearBugMobileView*) self.view];
    
    for(int i = 0; i < 1999; i++) {
        NSMutableString* name = [NSMutableString stringWithString: @"HealthyBug"];
        [name appendString: [[NSNumber numberWithInt: i] stringValue]];
        [world addBug: [[InfectableNonLinearBug alloc] initWithWorld: world
                                                                name: name
                                                               layer: @"FirstLayer"
                                                               state: HEALTHY
                                                    incubationPeriod: 5
                                                     infectionPeriod: 50
                                                     infectionRadius: 3
                                                         alertRadius: 3
                                                       mortalityRate: 25]];
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
    
    [((InfectableNonLinearBugMobileView*) self.view) setWorld: world];
    
    //[world start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

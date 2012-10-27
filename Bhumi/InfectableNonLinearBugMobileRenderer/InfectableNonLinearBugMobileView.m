//
//  InfectableNonLinearBugMobileView.m
//  Bhumi
//
//  Created by Vivin Paliath on 10/27/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "InfectableNonLinearBugMobileView.h"
#import "World.h"
#import "InfectableNonLinearBug.h"

@implementation InfectableNonLinearBugMobileView

@synthesize world;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        // Do any additional setup after loading the view, typically from a nib

    }
    
    return self;
}


- (void) drawRect:(CGRect) dirtyRect {
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextClearRect(myContext, CGRectMake(0, 0, 1024, 768));

    /*
     CGContextSetRGBStrokeColor(myContext, 255, 0, 0, 1);
     CGContextBeginPath(myContext);
     CGContextMoveToPoint(myContext, 0, 0);
     CGContextAddLineToPoint(myContext, 1024, 768);
     CGContextStrokePath(myContext); */
    
    //TODO: There is a synchronization issue here. This manifests itself when you uncomment the NSLog. It appears that the background thread modifies the bugs array
    //TODO: while the main thread is looping over it. This is something you need to fix.
    
    if([world running]) {
        //NSLog(@"%@ World is running Going to draw!!! Waiting for lock.", [NSThread currentThread]);
        @synchronized (_lock) {
            //NSLog(@"%@ Obtained lock. drawing...", [NSThread currentThread]);
            //Ideally we would need layers, but for now let's just get this to display
            NSUInteger rows = [world rows];
            NSUInteger columns = [world columns];
            
            NSUInteger cellWidth = 1024 / columns;
            NSUInteger cellHeight = 768 / rows;
            
            NSArray* bugs = [world bugs];
            NSEnumerator* enumerator = [bugs objectEnumerator];
            InfectableNonLinearBug* bug;
            
            NSUInteger numHealthy = 0;
            NSUInteger numInfected = 0;
            NSUInteger numInfectious = 0;
            NSUInteger numImmune = 0;
            
            while ((bug = [enumerator nextObject])) {
                
                double intensity = .15 + (([world currentIteration] - [bug infectionStartIteration]) / ((double) [world iterations] / 2));
                //NSLog(@"%f", intensity);
                
                if([bug state] == HEALTHY) {
                    CGContextSetRGBFillColor(myContext, 0, 0, 1, 1); //HEALTHY = blue
                    numHealthy++;
                } else if([bug state] == INFECTED) {
                    CGContextSetRGBFillColor(myContext, intensity, intensity, 0, 1); //INFECTED = yellow
                    numInfected++;
                } else if([bug state] == INFECTIOUS) {
                    CGContextSetRGBFillColor(myContext, intensity, 0, 0, 1); //INFECTIOUS = red
                    numInfectious++;
                } else if([bug state] == IMMUNE) {
                    CGContextSetRGBFillColor(myContext, 0, intensity, 0, 1); //IMMUNE =  green
                    numImmune++;
                }
                
                //NSLog(@"%@: Drawing bug %@ at %lu, %lu with width %lu and height %lu", [NSThread currentThread], [bug name], [bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight);
                
                CGContextFillRect(myContext, CGRectMake([bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight));
            }
            
            CGContextSelectFont(myContext, "Verdana", 1, kCGEncodingMacRoman);
            CGContextSetTextDrawingMode(myContext, kCGTextFill);
            
            CGContextSetRGBFillColor(myContext, 255, 255, 255, 1);
            CGContextSetTextMatrix(myContext, CGAffineTransformMakeScale(15, -15));
            
            NSString* text = [NSString stringWithFormat:@"Iteration: %lu Healthy Bugs: %lu Infected Bugs: %lu Infectious Bugs: %lu Immune Bugs: %lu Total Bugs: %lu", [world currentIteration], numHealthy, numInfected, numInfectious, numImmune, [[world bugs] count]];
            CGContextShowTextAtPoint(myContext, 10, 738, [text UTF8String], [text length]);
            
        }
    } else {
        //NSLog(@"World wasn't running so I started it!");
        [world performSelectorInBackground: @selector(start) withObject: nil];
    }
}

- (void) refreshView {
    [self setNeedsDisplay];
}

- (void) intercept: (World *) aWorld {
    
    //struct timespec time;
    //time.tv_sec  = 0;
    //time.tv_nsec = 100000000L;
    
    //NSLog(@"%@ Waiting for lock.", [NSThread currentThread]);
    @synchronized (_lock) {
        //NSLog(@"%@ Obtained lock.", [NSThread currentThread]);
        //NSLog(@"Updating display");
        [self performSelectorOnMainThread: @selector(refreshView) withObject: nil waitUntilDone: YES];
    }
    
    //nanosleep(&time, NULL);
}

@end

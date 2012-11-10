//
//  WorldView.m
//  Bhumi
//
//  Created by Vivin Paliath on 9/24/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "WorldView.h"
#import "World.h"
#import "InfectableBug.h"

@implementation WorldView

@synthesize world;

- (id) initWithFrame:(NSRect) frame {
    _numInfected = 0;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) drawRect:(NSRect) dirtyRect {

    NSInteger currentNumInfected = 0;
    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextClearRect(myContext, CGRectMake(0, 0, 1024, 768));

    NSUInteger rows = [world rows];
    NSUInteger columns = [world columns];

    NSUInteger cellWidth = 1024 / columns;
    NSUInteger cellHeight = 768 / rows;
    
    /*
    CGContextSetRGBStrokeColor(myContext, 255, 0, 0, 1);
    CGContextBeginPath(myContext);
    CGContextMoveToPoint(myContext, 0, 0);
    CGContextAddLineToPoint(myContext, 1024, 768);
    CGContextStrokePath(myContext); */
    
    if([world running]) {
        //Ideally we would need layers, but for now let's just get this to display
        NSArray* bugs = [world bugs];
        NSEnumerator* enumerator = [bugs objectEnumerator];
        InfectableBug* bug;
        while ((bug = [enumerator nextObject])) {
            if([bug infected] == YES) {
                /*
                CGContextSelectFont(myContext, "Verdana", 2, kCGEncodingMacRoman);
                CGContextSetTextDrawingMode(myContext, kCGTextFill);

                CGContextSetRGBFillColor(myContext, 255, 255, 255, 1);
                CGContextSetTextMatrix(myContext, CGAffineTransformMakeScale(10, -10));

                NSString* text = [NSString stringWithFormat:@"Infected bug at %lu, %lu. Diff is %li, %li", [bug x], [bug y], (ix - [bug x]), (iy - [bug y])];
                CGContextShowTextAtPoint(myContext, 500, 748, [text UTF8String], [text length]); */
                currentNumInfected++;
                CGContextSetRGBFillColor(myContext, 128, 0, 0, 1);
            } else {
                CGContextSetRGBFillColor(myContext, 0, 0, 128, 1);
            }

            //NSLog(@"%@: Drawing bug %@ at %lu, %lu with width %lu and height %lu", [NSThread currentThread], [bug name], [bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight);

            CGContextFillRect(myContext, CGRectMake([bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight));
        }

        CGContextSelectFont(myContext, "Verdana", 2, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(myContext, kCGTextFill);

        CGContextSetRGBFillColor(myContext, 255, 255, 255, 1);
        CGContextSetTextMatrix(myContext, CGAffineTransformMakeScale(10, -10));

        NSString* text = [NSString stringWithFormat:@"Iteration: %lu", [world currentIteration]];
        CGContextShowTextAtPoint(myContext, 0, 748, [text UTF8String], [text length]);

        [world step];
            
    } else {
        //NSLog(@"World wasn't running so I started it!");
        [world performSelectorInBackground: @selector(start) withObject: nil];
    }
    
    if(currentNumInfected < _numInfected) {
        NSLog(@"There are %lu fewer bugs in iteration %lu compared to previous iteration!", (_numInfected - currentNumInfected), [world currentIteration]);
    }
    
    _numInfected = currentNumInfected;
}

- (BOOL) isFlipped {
    return YES;
}

- (void) refreshView {
    [self setNeedsDisplay: YES];
}

- (void) intercept: (World *) aWorld {
    [self performSelectorOnMainThread: @selector(display) withObject: nil waitUntilDone: YES];
}

@end

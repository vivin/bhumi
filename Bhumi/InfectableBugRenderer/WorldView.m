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
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) drawRect:(NSRect) dirtyRect {

    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextClearRect(myContext, CGRectMake(0, 0, 1024, 768));

    NSUInteger rows = [world rows];
    NSUInteger columns = [world columns];

    NSUInteger cellWidth = 1024 / columns;
    NSUInteger cellHeight = 768 / rows;

    if([world running]) {
        @synchronized (_lock) {
            //Ideally we would need layers, but for now let's just get this to display
            NSArray* bugs = [world bugs];
            NSEnumerator* enumerator = [bugs objectEnumerator];
            InfectableBug* bug;
            while ((bug = [enumerator nextObject])) {
                if([bug infected] == YES) {
                    CGContextSetRGBFillColor(myContext, 128, 0, 0, 1);
                } else {
                    CGContextSetRGBFillColor(myContext, 0, 0, 128, 1);
                }

                NSLog(@"Drawing bug %@ at %lu, %lu with width %lu and height %lu", [bug name], [bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight);

                CGContextFillRect(myContext, CGRectMake([bug x] * cellWidth, [bug y] * cellHeight, cellWidth, cellHeight));
            }
        }
    } else {
        [world performSelectorInBackground: @selector(start) withObject: nil];
    }
}

- (BOOL) isFlipped {
    return YES;
}

- (void) intercept: (World *) aWorld {
   
    struct timespec time;
    time.tv_sec  = 0;
    time.tv_nsec = 500000000L;

    //nanosleep(&time, NULL);

    @synchronized (_lock) {
        [self setNeedsDisplay: YES];
    }
}

@end

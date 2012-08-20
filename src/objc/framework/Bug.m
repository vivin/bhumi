#import "Bug.h"

@implementation Bug

- (id) init {
    self = [super init];

    if((self = [super init])) {
        name = @"";
        layer = @"";
        x = -1;
        y = -1;
        alive = true;
    }
}

- (id) initWithWorld: (World*) aWorld
                name: (NSString*) aName
               layer: (NSString*) aLayer
           sleepTime: (long) aSleepTime {
    
    if((self = [super init])) {
        [world autorelease];
        world = [aWorld retain];

        [name autorelease];
        name = [aName retain];

        [layer autorelease];
        layer = [aLayerKey retain];
        x = -1;
        y = -1;

        sleepTime = aSleepTime;
        alive = true;

        bugThread = [[BugThread alloc] initWithBug: self];
    }

    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (World*) world {
    return world;
}

- (NSString*) name {
    return name;
}

- (NSString*) layer {
    return layer;
}

- (long) sleepTime {
    return sleepTime;
}

- (void) setName: (NSString*) aName {
    [name autorelease];
    name = [aName retain];
}

- (void) setX: (long) anX
         setY: (long) aY {
    x = anX;
    y = aY;
}

- (long) x {
    return x;
}

- (long) y {
    return y;
}

- (void) stop {
    [bugThread cancel];
}

- (void) stopped {
    BOOL stopped = false;

    if(bugThread != nil) {
        stopped = ![bugThread isExecution];
    }

    return stopped;
}

- (BOOL) alive {
    return alive;
}

- (void) kill {
    alive = false;
    if([bugThread isExecuting]) {
        [bugThread cancel];
        [bugThread release];
    }
}

- (void) act {
    if(bugThread == nil) {
        bugThread = [[BugThread alloc] initWithBug: self];
    }

    if(![bugThread isExecuting]) {
        [bugThread start];
    }
}

@end

#import "Bug.h"

@implementation Bug

- (id) init {
    self = [super init];

    if((self = [super init])) {
        name = @"";
        layer = @"";
        x = -1;
        y = -1;
        alive = YES;
    }

    return self;
}

- (id) initWithWorld: (World*) aWorld
                name: (NSString*) aName
               layer: (NSString*) aLayer {
    
    if((self = [super init])) {
        [world autorelease];
        world = [aWorld retain];

        [name autorelease];
        name = [aName retain];

        [layer autorelease];
        layer = [aLayer retain];
        x = -1;
        y = -1;

        alive = YES;
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

- (void) setName: (NSString*) aName {
    [name autorelease];
    name = [aName retain];
}

- (void) setX: (int) anX
            Y: (int) aY {
    x = anX;
    y = aY;
}

- (int) x {
    return x;
}

- (int) y {
    return y;
}

- (BOOL) alive {
    return alive;
}

- (void) kill {
    alive = NO;
}

- (void) act {
}

@end 

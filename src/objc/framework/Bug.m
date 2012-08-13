#import "Bug.h"

@implementation

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
               layer: (NSString*) aLayer {
    
    if((self = [super init])) {
        [world autorelease];
        world = [aWorld retain];

        [name autorelease];
        name = [aName retain];

        [layer autorelease];
        layer = [aLayerKey retain];
        x = -1;
        y = -1;
        
        alive = true;
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

- (BOOL) alive {
    return alive;
}

- (void) kill {
    alive = false;
}

@end

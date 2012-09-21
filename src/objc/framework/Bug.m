#import "Bug.h"
#import "BugToStringSerializer.h"
#import "World.h"

@implementation Bug

@synthesize world;
@synthesize name;
@synthesize layer;
@synthesize x;
@synthesize y;
@synthesize alive;
@synthesize isPlaced;

- (id) init {
    self = [super init];

    if(self) {
        name = @"";
        layer = @"";
        x = 0;
        y = 0;
        alive = YES;
        isPlaced = NO;
    }

    return self;
}

- (id)initWithWorld:(World *) aWorld
               name:(NSString *) aName
              layer:(NSString *) aLayer
                  x:(NSUInteger) anX
                  y:(NSUInteger) aY {

    self = [super init];
    if (self) {
        world = aWorld;
        name = aName;
        layer = aLayer;
        x = anX;
        y = aY;
        alive = YES;
        isPlaced = YES;
    }

    return self;
}

- (id) initWithWorld: (World *) aWorld
                name: (NSString *) aName
               layer: (NSString *)aLayer {
    self = [super init];
    if (self) {
        world = aWorld;
        name = aName;
        layer = aLayer;
        x = 0;
        y = 0;
        alive = YES;
        isPlaced = NO;
    }

    return self;
}

+ (id) objectWithWorld: (World *) aWorld
                  name: (NSString *) aName
                 layer: (NSString *) aLayer {
    return [[Bug alloc] initWithWorld: aWorld
                                 name: aName
                                layer: aLayer];
}


+ (id) objectWithWorld: (World *) world
                 name: (NSString *) name
                layer: (NSString *) layer
                    x: (NSUInteger) x
                    y: (NSUInteger) y {
    return [[Bug alloc] initWithWorld: world
                                 name: name
                                layer: layer
                                    x: x
                                    y: y];
}

- (void) kill {
    alive = NO;
}

- (void) setX: (NSUInteger)anX
            Y: (NSUInteger) aY {
    x = anX;
    y = aY;
}

- (void) act {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end

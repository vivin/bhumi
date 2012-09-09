#import "Bug.h"
#import "BugToStringSerializer.h"

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
               layer: (NSString*) aLayer
     serializerClass: (Class) serializerClass {
    
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

        toStringSerializer = [[serializerClass alloc] initWithBug: self];

        if([toStringSerializer isKindOfClass: [BugToStringSerializer class]]) {
            
            if([toStringSerializer serializerType] != [self class]) {
                [NSException raise:@"Serializer format must match format of bug!" format:@"Serializer format must match format of bug!"];
            }
        } else {
            [NSException raise:@"Serializer class is expected to be a subtype of BugToStringSerializer!" format:@"Serializer class is expected to be a subtype BugToStringSerializer!"];
        }
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

- (BugToStringSerializer*) toStringSerializer {
    return toStringSerializer;
}

- (void) kill {
    alive = NO;
}

- (void) act {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSString*) serializeToString {
    return [toStringSerializer serializeToString];
}

@end 

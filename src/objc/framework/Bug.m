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
@synthesize toStringSerializer;

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
                  y:(NSUInteger) aY
    serializerClass: (Class) serializerClass {

    self = [super init];
    if (self) {
        world = aWorld;
        name = aName;
        layer = aLayer;
        x = anX;
        y = aY;
        alive = YES;
        isPlaced = YES;

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

- (id) initWithWorld: (World *) aWorld
                name: (NSString *) aName
               layer: (NSString *)aLayer
     serializerClass: (Class) serializerClass {
    self = [super init];
    if (self) {
        world = aWorld;
        name = aName;
        layer = aLayer;
        x = 0;
        y = 0;
        alive = YES;
        isPlaced = NO;

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

+ (id) objectWithWorld: (World *) aWorld
                  name: (NSString *) aName
                 layer: (NSString *) aLayer
       serializerClass: (Class) serializerClass {
    return [[Bug alloc] initWithWorld: aWorld
                                 name: aName
                                layer: aLayer
                      serializerClass: serializerClass];
}


+ (id) objectWithWorld: (World *) world
                 name: (NSString *) name
                layer: (NSString *) layer
                    x: (NSUInteger) x
                    y: (NSUInteger) y
      serializerClass: (Class) serializerClass {
    return [[Bug alloc] initWithWorld: world
                                 name: name
                                layer: layer
                                    x: x
                                    y: y
                      serializerClass: serializerClass];
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

- (NSString*) serializeToString {
    return [toStringSerializer serializeToString];
}

@end 

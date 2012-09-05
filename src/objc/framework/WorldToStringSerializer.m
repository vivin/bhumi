#import "WorldToStringSerializer.h"

@implementation WorldToStringSerializer

- (id) initWithWorld: (World*) aWorld {

    if((self = [super init])) {
        [world autorelease];
        world = [aWorld retain];
    }

    return self;
}

- (SerializerFormat) serializerFormat {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

- (Class) serializerType {
    return [World class];
}

- (NSString*) serializeToString {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

@end

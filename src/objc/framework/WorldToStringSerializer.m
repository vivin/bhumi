#import "WorldToStringSerializer.h"
#import "World.h"

@implementation WorldToStringSerializer

- (id) initWithWorld: (World*) aWorld {

    if((self = [super init])) {
        _world = aWorld;
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

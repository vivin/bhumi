#import "BugToStringSerializer.h"
#import "Bug.h"

@class Bug;

@implementation BugToStringSerializer

- (id) initWithBug: (Bug *) bug {
    self = [super init];
    if (self) {
        _bug = bug;
    }

    return self;
}

+ (id) objectWithBug: (Bug *) bug {
    return [[BugToStringSerializer alloc] initWithBug: bug];
}


- (SerializerFormat) serializerFormat {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

- (Class) serializerType {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

- (NSString*) serializeToString {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

@end

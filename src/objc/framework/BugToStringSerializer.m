#import "BugToStringSerializer.h"

@class Bug;

@implementation BugToStringSerializer

- (id) initWithBug: (Bug*) aBug {

    if((self = [super init])) {
        [bug autorelease];
        bug = [aBug retain];
    }

    return self;
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

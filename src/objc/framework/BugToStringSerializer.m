#import "BugToStringSerializer.h"

@implementation BugToStringSerializer

- (SerializerFormat *) serializerFormat {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

- (Class) serializedObjectType {
    @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo: nil];
}

- (NSString*) serializeToStringWithObject: (id) objectToSerialize {
    if(![[objectToSerialize class] isKindOfClass: [self serializedObjectType]]) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ expects object to be serialized to be of type %@.", NSStringFromClass([self class]), NSStringFromClass([self serializedObjectType])];
    }

    return @"";
}

@end

#import "RandomBugJsonSerializer.h"
#import "../framework/SerializerFormat.h"

@class RandomBug;

@implementation RandomBugJsonSerializer

- (Class) serializerType {
    return [RandomBug class];
}

- (SerializerFormat) serializerFormat {
    return JSON;
}

- (NSString*) serializeToString {
    return @"";
}

@end

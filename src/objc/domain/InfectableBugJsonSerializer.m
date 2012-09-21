#import "InfectableBugJsonSerializer.h"
#import "../framework/Bug.h"
#import "InfectableBug.h"

@class InfectableBug;

@implementation InfectableBugJsonSerializer

- (Class) serializedObjectType {
    return [InfectableBug class];
}

- (SerializerFormat *) serializerFormat {
    return [SerializerFormats JSON];
}

- (NSString*) serializeToStringWithObject: (id) objectToSerialize {

    [super serializeToStringWithObject: objectToSerialize];

    InfectableBug* bug = (InfectableBug *) objectToSerialize;

    NSString* format = {
        @"    {\n"
        @"        \"name\": \"%@\",\n"
        @"        \"alive\": \"%@\",\n"
        @"        \"infected\": \"%@\",\n"
        @"        \"incubationPeriod\": \"%d\",\n"
        @"        \"infectionRadius\": \"%d\",\n"
        @"        \"x\": \"%d\",\n"
        @"        \"y\": \"%d\"\n"
        @"    }"
    };

    return [NSString stringWithFormat: format,
              [[bug name] UTF8String],
              [bug alive] == YES ? @"true" : @"false",
              [bug infected] == YES ? @"true" : @"false",
                    [bug incubationPeriod],
                    [bug infectionRadius],
                    [bug x],
                    [bug y]];
}

@end

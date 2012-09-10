#import "InfectableBugJsonSerializer.h"
#import "../framework/Bug.h"
#import "../framework/SerializerFormat.h"
#import "InfectableBug.h"

@class InfectableBug;

@implementation InfectableBugJsonSerializer

- (Class) serializerType {
    return [InfectableBug class];
}

- (SerializerFormat) serializerFormat {
    return JSON;
}

- (NSString*) serializeToString {
    NSMutableString* json = [NSMutableString stringWithString: @""];

    [json appendString: @"{\"name\": \""];
    [json appendString: [bug name]];
    [json appendString: @"\",\n"];
    [json appendString: @"\"alive\": "];
    [json appendString: [bug alive] == YES ? @"true,\n" : @"false,\n"];
    [json appendString: @"\"infected\": "];
    [json appendString: [bug infected] == YES ? @"true,\n" : @"false,\n"];
    [json appendString: @"\"incubationPeriod\": "];
    [json appendString: [[NSNumber numberWithInt: [bug incubationPeriod]] stringValue]];
    [json appendString: @",\n"];
    [json appendString: @"\"infectionRadius\": "];
    [json appendString: [[NSNumber numberWithInt: [bug infectionRadius]] stringValue]];
    [json appendString: @",\n"];
    [json appendString: @"\"x\": "];
    [json appendString: [[NSNumber numberWithInt: [bug x]] stringValue]];
    [json appendString: @",\n"];
    [json appendString: @"\"y\": "];
    [json appendString: [[NSNumber numberWithInt: [bug y]] stringValue]];
    [json appendString: @"}"];

    return json;
}

@end

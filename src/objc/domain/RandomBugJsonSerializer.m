#import "RandomBugJsonSerializer.h"
#import "../framework/Bug.h"
#import "RandomBug.h"
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
    NSMutableString* json = [NSMutableString stringWithString: @""];
    
    [json appendString: @"{\"name\": \""];
    [json appendString: [bug name]];
    [json appendString: @"\",\n"];
    [json appendString: @"\"alive\": "];
    [json appendString: [bug alive] == YES ? @"true,\n" : @"false,\n"];
    [json appendString: @"\"x\": "];
    [json appendString: [[NSNumber numberWithInt: [bug x]] stringValue]];
    [json appendString: @",\n"];
    [json appendString: @"\"y\": "];
    [json appendString: [[NSNumber numberWithInt: [bug y]] stringValue]];
    [json appendString: @"}"];

    return [json autorelease];
}

@end

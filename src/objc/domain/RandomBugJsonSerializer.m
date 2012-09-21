#import "RandomBugJsonSerializer.h"
#import "../framework/Bug.h"
#import "RandomBug.h"

@class RandomBug;

@implementation RandomBugJsonSerializer

- (Class) serializedObjectType {
    return [RandomBug class];
}

- (SerializerFormat*) serializerFormat {
    return [SerializerFormats JSON];
}

- (NSString*) serializeToStringWithObject: (id) objectToSerialize {

    [super serializeToStringWithObject: objectToSerialize];

    RandomBug*  bug = (RandomBug*) objectToSerialize;

    NSMutableString* json = [NSMutableString stringWithString: @""];
    
    [json appendString: @"{\"name\": \""];
    [json appendString: [bug name]];
    [json appendString: @"\",\n"];
    [json appendString: @"\"alive\": "];
    [json appendString: [bug alive] == YES ? @"true,\n" : @"false,\n"];
    [json appendString: @"\"x\": "];
    [json appendString: [[NSNumber numberWithUnsignedInteger: [bug x]] stringValue]];
    [json appendString: @",\n"];
    [json appendString: @"\"y\": "];
    [json appendString: [[NSNumber numberWithUnsignedInteger: [bug y]] stringValue]];
    [json appendString: @"}"];

    return json;
}

@end

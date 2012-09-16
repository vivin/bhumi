#import "InfectableBugJsonSerializer.h"
#import "../framework/Bug.h"
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

    NSString* format = {
        @"    {\n"
        @"        \"name\": \"%s\",\n"
        @"        \"alive\": \"%s\",\n"
        @"        \"infected\": \"%s\",\n"
        @"        \"incubationPeriod\": \"%d\",\n"
        @"        \"infectionRadius\": \"%d\",\n"
        @"        \"x\": \"%d\",\n"
        @"        \"y\": \"%d\"\n"
        @"    }"
    };
/*
    NSString* json = [
        NSString stringWithFormat: format,
        [bug name],
        [bug infected] == YES ? @"true" : @"false",
        [bug incubationPeriod],
        [bug infectionRadius],
        [bug x],
        [bug y]
    ]; */
/*
    NSString* json = [NSMutableString stringWithString: @""];
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
  */  
    //return [format autorelease];


    return [NSString stringWithFormat: format,
              [[self.bug name] UTF8String],
              [self.bug alive] == YES ? [[NSString stringWithString: @"true"] UTF8String] : [[NSString stringWithString: @"false"] UTF8String],
              [(InfectableBug *) self.bug infected] == YES ? [[NSString stringWithString: @"true"] UTF8String] : [[NSString stringWithString: @"false"] UTF8String],
                    [(InfectableBug *) self.bug incubationPeriod],
                    [(InfectableBug *) self.bug infectionRadius],
                    [self.bug x],
                    [self.bug y]];
}

@end

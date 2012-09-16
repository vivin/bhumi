#import "WorldJsonSerializer.h"
#import "SerializerFormat.h"
#import "World.h"

@implementation WorldJsonSerializer

- (SerializerFormat) serializerFormat {
    return JSON;
}

- (NSString*) serializeToString {

    NSUInteger currentIteration = [self.world currentIteration];

    NSMutableString* json = [NSMutableString stringWithString: @""];

    if(currentIteration == 0) {
        [json appendString: @"{\"name\": "];
        [json appendString: @"\""];
        [json appendString: [[self.world name] stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""]];
        [json appendString: @"\",\n"];
        [json appendString: @"\"iterations\": "];
        [json appendString: [[NSNumber numberWithInt: [self.world iterations]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"\"rows\": "];
        [json appendString: [[NSNumber numberWithInt: [self.world rows]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"\"columns\": "];
        [json appendString: [[NSNumber numberWithInt: [self.world columns]] stringValue]];
        [json appendString: @", \n"];
        [json appendString: @"\"snapshotInterval\": "];
        [json appendString: [[NSNumber numberWithInt: [self.world snapshotInterval]] stringValue]];
        [json appendString: @", \n"];
        [json appendString: @"\"snapshots\": [\n"];
    }

    [json appendString: @"{\"iteration\": "];
    [json appendString: [[NSNumber numberWithInt: [self.world currentIteration]] stringValue]];
    [json appendString: @", \n"];
    [json appendString: @"\"layers\": {\n"];

    NSEnumerator* layerEnumerator = [[self.world layers] objectEnumerator];
    NSString* layer;

    while((layer = [layerEnumerator nextObject])) {
        [json appendString: @"\""];
        [json appendString: layer];
        [json appendString: @"\""];
        [json appendString: @": [\n"];

        NSArray* bugs = [self.world bugs: layer];
        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        NSUInteger i = 0;
        while((bug = [bugEnumerator nextObject])) {
            [json appendString: [bug serializeToString]];

            if(i != [bugs count] - 1) {
                [json appendString: @",\n"];
            }

            i++;
        }

        [json appendString: @"]"];
    }

    [json appendString: @"}}"];

    if([self.world currentIteration] + [self.world snapshotInterval] < [self.world iterations]) {
        [json appendString: @",\n"];
    } else {
        [json appendString: @"\n]}"];
    }

    return json;
}

@end

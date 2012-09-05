#import "WorldJsonSerializer.h"
#import "SerializerFormat.h"
#import "World.h"

@implementation WorldJsonSerializer

- (SerializerFormat) serializerFormat {
    return JSON;
}

- (NSString*) serializeToString {

    int currentIteration = [world currentIteration];

    NSMutableString* json = [NSMutableString stringWithString: @""];

    if(currentIteration == 0) {
        [json appendString: @"{name: "];
        [json appendString: @"\""];
        [json appendString: [[world name] stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""]];
        [json appendString: @"\",\n"];
        [json appendString: @"iterations: "];
        [json appendString: [[NSNumber numberWithInt: [world iterations]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"rows: "];
        [json appendString: [[NSNumber numberWithInt: [world rows]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"columns: "];
        [json appendString: [[NSNumber numberWithInt: [world columns]] stringValue]];
        [json appendString: @", \n"];
        [json appendString: @"snapshotInterval: "];
        [json appendString: [[NSNumber numberWithInt: [world snapshotInterval]] stringValue]];
        [json appendString: @"iterations: [\n"];
    }

    [json appendString: @"{iteration: "];
    [json appendString: [[NSNumber numberWithInt: [world currentIteration]] stringValue]];
    [json appendString: @", \n"];
    [json appendString: @"layers: {\n"];

    NSEnumerator* layerEnumerator = [[world layers] objectEnumerator];
    NSString* layer;

    while((layer = [layerEnumerator nextObject])) {
        [json appendString: layer];
        [json appendString: @": [\n"];

        NSArray* bugs = [world bugs: layer];
        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        int i = 0;
        while((bug = [bugEnumerator nextObject])) {
            [json appendString: [bug serializeToString]];

            if(i != [bugs count] - 1) {
                [json appendString: @",\n"];
            }
        }

        [json appendString: @"]"];
    }

    [json appendString: @"}}"];

    if([world currentIteration] + [world snapshotInterval] < [world iterations] - 1) {
        [json appendString: @",\n"];
    } else {
        [json appendString: @"\n]}"];
    }

    return @"";
}

@end

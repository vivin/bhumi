//
// Created by vivin on 9/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JsonInterceptor.h"
#import "World.h"
#import "BugToStringSerializer.h"
#import "SerializerFormat.h"

@implementation JsonInterceptor {
}

- (id) initWithBugSerializers: (NSArray *) bugSerializers {
    self = [super init];

    if(self) {

        _bugTypeToSerializerDictionary = [[NSMutableDictionary alloc] init];

        NSEnumerator* bugSerializerEnumerator = [bugSerializers objectEnumerator];
        BugToStringSerializer* bugToStringSerializer;
        while ((bugToStringSerializer = [bugSerializerEnumerator nextObject])) {
            if ([[bugToStringSerializer class] isKindOfClass: [BugToStringSerializer class]]) {
                if ([[[bugToStringSerializer serializerFormat] formatName] isEqualToString: [[SerializerFormats JSON] formatName]]) {
                    [_bugTypeToSerializerDictionary setObject: bugToStringSerializer forKey: (id <NSCopying>) [bugToStringSerializer serializedObjectType]];
                } else {
                    [NSException raise:NSInternalInconsistencyException format:@"Serializer format is expected to be JSON."];
                }
            } else {
                [NSException raise:NSInternalInconsistencyException format:@"Serializer is expected to be of type %@.", NSStringFromClass([BugToStringSerializer class])];
            }
        }
    }

    return self;
}

+ (id) objectWithBugSerializers: (NSArray *) bugSerializers {
    return [[JsonInterceptor alloc] initWithBugSerializers: bugSerializers];
}

- (void) addBugSerializer: (BugToStringSerializer *) bugToStringSerializer {
    if ([[bugToStringSerializer class] isKindOfClass: [BugToStringSerializer class]]) {
        if ([[[bugToStringSerializer serializerFormat] formatName] isEqualToString: [[SerializerFormats JSON] formatName]]) {
            [_bugTypeToSerializerDictionary setObject: bugToStringSerializer forKey: (id <NSCopying>) [bugToStringSerializer serializedObjectType]];
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"Serializer format is expected to be JSON."];
        }
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Serializer is expected to be of type %@.", NSStringFromClass([BugToStringSerializer class])];
    }
}

- (void) intercept: (World *) world {
    NSUInteger currentIteration = [world currentIteration];

    NSMutableString* json = [NSMutableString stringWithString: @""];

    if(currentIteration == 0) {
        [json appendString: @"{\"name\": "];
        [json appendString: @"\""];
        [json appendString: [[world name] stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""]];
        [json appendString: @"\",\n"];
        [json appendString: @"\"iterations\": "];
        [json appendString: [[NSNumber numberWithInt: [world iterations]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"\"rows\": "];
        [json appendString: [[NSNumber numberWithInt: [world rows]] stringValue]];
        [json appendString: @",\n"];
        [json appendString: @"\"columns\": "];
        [json appendString: [[NSNumber numberWithInt: [world columns]] stringValue]];
        [json appendString: @", \n"];
        [json appendString: @"\"snapshotInterval\": "];
        [json appendString: [[NSNumber numberWithInt: [world snapshotInterval]] stringValue]];
        [json appendString: @", \n"];
        [json appendString: @"\"snapshots\": [\n"];
    }

    [json appendString: @"{\"iteration\": "];
    [json appendString: [[NSNumber numberWithInt: [world currentIteration]] stringValue]];
    [json appendString: @", \n"];
    [json appendString: @"\"layers\": {\n"];

    NSEnumerator* layerEnumerator = [[world layers] objectEnumerator];
    NSString* layer;

    while((layer = [layerEnumerator nextObject])) {
        [json appendString: @"\""];
        [json appendString: layer];
        [json appendString: @"\""];
        [json appendString: @": [\n"];

        NSArray* bugs = [world bugs: layer];
        NSEnumerator* bugEnumerator = [bugs objectEnumerator];
        Bug* bug;

        NSUInteger i = 0;
        while((bug = [bugEnumerator nextObject])) {

            [json appendString: [[_bugTypeToSerializerDictionary objectForKey: [bug class]] serializeToStringWithObject: bug]];

            if(i != [bugs count] - 1) {
                [json appendString: @",\n"];
            }

            i++;
        }

        [json appendString: @"]"];
    }

    [json appendString: @"}}"];

    if([world currentIteration] + [world snapshotInterval] < [world iterations]) {
        [json appendString: @",\n"];
    } else {
        [json appendString: @"\n]}"];
    }

    printf("%s", [json UTF8String]);
}

@end
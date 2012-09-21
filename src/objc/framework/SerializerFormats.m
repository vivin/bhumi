//
// Created by vivin on 9/21/12.
//
// To change the template use AppCode | Preferences | File Templates.
//
// A kludgey way to create extensible "enums" (a la Java) in Objective-C. Users can extend serializer formats and create
// new SerializerFormat instances


#import "SerializerFormats.h"
#import "SerializerFormat.h"

@implementation SerializerFormats

+ (SerializerFormat *) JSON {

    static SerializerFormat* thisSerializerFormat = nil;
    if (!thisSerializerFormat) {
        thisSerializerFormat = [[SerializerFormat alloc] initWithFormatName: @"JSON"];
    }

    return thisSerializerFormat;
}

+ (SerializerFormat *) XML {

    static SerializerFormat* thisSerializerFormat = nil;
    if (!thisSerializerFormat) {
        thisSerializerFormat = [[SerializerFormat alloc] initWithFormatName: @"XML"];
    }

    return thisSerializerFormat;
}

@end
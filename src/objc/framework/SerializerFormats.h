//
// Created by vivin on 9/21/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SerializerFormat;

@interface SerializerFormats : NSObject

+ (SerializerFormat *) JSON;
+ (SerializerFormat *) XML;

@end
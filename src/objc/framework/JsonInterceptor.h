//
// Created by vivin on 9/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "InterceptorProtocol.h"

@class BugToStringSerializer;

@interface JsonInterceptor : NSObject <InterceptorProtocol>
    @property(readonly) NSMutableDictionary* bugTypeToSerializerDictionary;

- (id) initWithBugSerializers: (NSArray *) bugSerializers;
+ (id) objectWithBugSerializers: (NSArray *) bugSerializers;
- (void) addBugSerializer: (BugToStringSerializer *) bugToStringSerializer;

@end

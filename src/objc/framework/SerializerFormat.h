//
// Created by vivin on 9/21/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SerializerFormatProtocol.h"

@interface SerializerFormat : NSObject <SerializerFormatProtocol>
    @property(readonly) NSString* formatName;

- (id) initWithFormatName: (NSString *) aFormatName;

@end
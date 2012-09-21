#import <Foundation/Foundation.h>
#import "SerializerFormats.h"

@protocol ToStringSerializerProtocol
- (Class) serializedObjectType;
- (SerializerFormat *) serializerFormat;
- (NSString*) serializeToStringWithObject: (id) objectToSerialize;
@end

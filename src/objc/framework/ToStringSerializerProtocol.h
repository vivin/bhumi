#import <Foundation/Foundation.h>
#import "SerializerFormat.h"

@protocol ToStringSerializerProtocol
- (Class) serializerType;
- (SerializerFormat) serializerFormat;
- (NSString*) serializeToString;
@end

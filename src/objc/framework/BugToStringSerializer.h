#import <Foundation/Foundation.h>
#import "ToStringSerializerProtocol.h"

@class Bug;

@interface BugToStringSerializer : NSObject <ToStringSerializerProtocol>
    @property Bug* bug;

- (id) initWithBug: (Bug *) bug;
+ (id) objectWithBug: (Bug *) bug;

@end

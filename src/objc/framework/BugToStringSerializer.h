#import <Foundation/Foundation.h>
#import "ToStringSerializerProtocol.h"

@class Bug;

@interface BugToStringSerializer : NSObject <ToStringSerializerProtocol> {
    @protected
    Bug* bug;
}

- (id) initWithBug: (Bug*) bug;

@end

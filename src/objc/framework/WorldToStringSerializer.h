#import <Foundation/Foundation.h>
#import "ToStringSerializerProtocol.h"

@class World;

@interface WorldToStringSerializer : NSObject <ToStringSerializerProtocol>
    @property World* world;

- (id) initWithWorld: (World*) world;

@end

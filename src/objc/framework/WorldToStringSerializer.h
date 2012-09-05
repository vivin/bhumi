#import <Foundation/Foundation.h>
#import "ToStringSerializerProtocol.h"

@class World;

@interface WorldToStringSerializer : NSObject <ToStringSerializerProtocol> {
    @protected
    World* world;
}

- (id) initWithWorld: (World*) world;

@end

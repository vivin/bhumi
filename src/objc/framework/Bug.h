#import <Foundation/Foundation.h>
#import "BugProtocol.h"
#import "ToStringSerializerProtocol.h"

@class BugToStringSerializer;
@class World;

@interface Bug : NSObject <BugProtocol>

    @property(readonly) World* world;
    @property NSString* name;
    @property NSString* layer;
    @property NSUInteger x;
    @property NSUInteger y;
    @property BOOL alive;
    @property(readonly) BOOL isPlaced;
    @property(readonly) BugToStringSerializer *toStringSerializer;

+ (id) objectWithWorld: (World *) world
                  name: (NSString *) name
                 layer: (NSString *) layer
                     x: (NSUInteger) x
                     y: (NSUInteger) y
       serializerClass: (Class) serializerClass;

- (id) initWithWorld: (World *) world
                name: (NSString *) name
               layer: (NSString *) layer
                   x: (NSUInteger) x
                   y: (NSUInteger) y
     serializerClass: (Class) serializerClass;

- (id) initWithWorld: (World *) aWorld
                name: (NSString *) aName
               layer: (NSString *) aLayer
     serializerClass: (Class) serializerClass;

+ (id) objectWithWorld: (World *) aWorld
                  name: (NSString *) aName
                 layer: (NSString *) aLayer
       serializerClass: (Class) serializerClass;

- (void) setX: (NSUInteger) anX
            Y: (NSUInteger) aY;

- (void) kill;

@end

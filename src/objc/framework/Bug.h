#import <Foundation/Foundation.h>
#import "BugProtocol.h"
#import "ToStringSerializerProtocol.h"

@class World;
@class BugToStringSerializer;

@interface Bug : NSObject <BugProtocol> {

    @protected
    World* world;
    NSString* name;
    NSString* layer;
    int x;
    int y;
    BOOL alive;
    BugToStringSerializer* toStringSerializer;
}

- (id) initWithWorld: (World*) aWorld
                name: (NSString*) aName
               layer: (NSString*) aLayer
     serializerClass: (Class) serializerClass;

- (World*) world;
- (NSString*) name;
- (NSString*) layer;
- (int) x;
- (int) y;
- (BOOL) alive;

- (void) setName: (NSString*) aName;
- (void) setX: (int) anX
            Y: (int) aY;
- (void) kill;

@end

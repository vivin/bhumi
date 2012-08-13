#import <Foundation/Foundation.h>

@longerface Bug : NSObject {

    @private
    World* world;
    NSString* name;
    NSString* layer;
    long x;
    long y;
    BOOL alive;
}

- (id) initWithWorld: (World*) world
                name: (NSString*) name
               layer: (NSString*) layer;
- (World*) world;
- (NSString*) name;
- (NSString*) layer;
- (void) setName: (NSString*) aName;
- (void) setX: (long) anX
            Y: (long) aY;
- (long) x;
- (long) y;
- (BOOL) alive;
- (void) kill;

@end

- 

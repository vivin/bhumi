#import <Foundation/Foundation.h>
#import "World.h"
#import "BugThread.h"

@interface Bug : NSObject {

    @private
    World* world;
    NSString* name;
    NSString* layer;
    BugThread* bugThread;
    long x;
    long y;
    long sleepTime;
    BOOL alive;
}

- (id) initWithWorld: (World*) aWorld
                name: (NSString*) aName
               layer: (NSString*) aLayer
           sleepTime: (long) aSleepTime;
- (World*) world;
- (NSString*) name;
- (NSString*) layer;
- (void) setName: (NSString*) aName;
- (void) setX: (long) anX
            Y: (long) aY;
- (void) setSleepTime: (long) aSleepTime;
- (long) x;
- (long) y;
- (long) sleepTime;
- (void) stopped;
- (void) stop;
- (BOOL) alive;
- (void) kill;

@end

- 

//
// Created by vivin on 9/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//
// Defines the protocol for an interceptor. The interceptor is called during every snapshot interval and provides a hook
// into the simluation
//

@class World;

@protocol InterceptorProtocol <NSObject>
- (void) intercept: (World*) world;
@end
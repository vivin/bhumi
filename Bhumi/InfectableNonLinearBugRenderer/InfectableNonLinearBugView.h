//
//  InfectableNonLinearBugView.h
//  Bhumi
//
//  Created by Vivin Paliath on 10/1/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InterceptorProtocol.h"

@class World;

@interface InfectableNonLinearBugView : NSView <InterceptorProtocol>

    @property World* world;

- (void) refreshView;
@end

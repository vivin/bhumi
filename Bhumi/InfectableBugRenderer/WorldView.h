//
//  WorldView.h
//  Bhumi
//
//  Created by Vivin Paliath on 9/24/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InterceptorProtocol.h"

@class World;

@interface WorldView : NSView <InterceptorProtocol>
    @property World* world;
    @property NSObject* lock;
@end


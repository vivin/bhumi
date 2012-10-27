//
//  InfectableNonLinearBugMobileView.h
//  Bhumi
//
//  Created by Vivin Paliath on 10/27/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterceptorProtocol.h"

@class World;

@interface InfectableNonLinearBugMobileView : UIView <InterceptorProtocol>

@property World* world;
@property NSObject* lock;

- (void) refreshView;

@end

//
//  MasterViewController.h
//  Bhumi
//
//  Created by Vivin Paliath on 10/1/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InfectableNonLinearBugView.h"

@interface MasterViewController : NSViewController

@property(atomic,strong) InfectableNonLinearBugView *infectableNonLinearBugView;

@end

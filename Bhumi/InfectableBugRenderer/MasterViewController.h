//
//  MasterViewController.h
//  Bhumi
//
//  Created by Vivin Paliath on 9/24/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WorldView.h"

@interface MasterViewController : NSViewController

@property(atomic,strong) WorldView* worldView;

@end

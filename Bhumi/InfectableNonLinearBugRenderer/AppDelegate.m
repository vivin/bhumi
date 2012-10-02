//
//  AppDelegate.m
//  InfectableNonLinearBugRenderer
//
//  Created by Vivin Paliath on 10/1/12.
//  Copyright (c) 2012 Vivin Paliath. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle: nil];
    [self.window.contentView addSubview: self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*) self.window.contentView).bounds;
}

@end

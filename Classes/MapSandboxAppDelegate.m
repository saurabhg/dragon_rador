//
//  MapSandboxAppDelegate.m
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//
#import "MapSandboxAppDelegate.h"

@implementation MapSandboxAppDelegate

@synthesize window, view_controller;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   view_controller = [[SandboxMapViewController alloc] initWithNibName:@"SandboxMapView" bundle:nil];
   [window addSubview:view_controller.view];
   [window makeKeyAndVisible];
}

- (void)dealloc
{
   [view_controller release];
   [window release];
   [super dealloc];
}

@end
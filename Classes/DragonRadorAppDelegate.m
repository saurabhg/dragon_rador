//
//  DragonRadorAppDelegate.m
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//
#import "DragonRadorAppDelegate.h"

@implementation DragonRadorAppDelegate

@synthesize window, view_controller;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   view_controller = [[DragonRadorMapViewController alloc] initWithNibName:@"DragonRadorMapView" bundle:nil];
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

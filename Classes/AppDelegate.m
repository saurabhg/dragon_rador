//
//  AppDelegate.m
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, view_controller;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   view_controller = [[DRMapViewController alloc] initWithNibName:@"DRMapView" bundle:nil];
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

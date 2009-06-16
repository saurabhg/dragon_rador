//
//  AppDelegate.m
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "MySelf.h"
#import "DragonRador.h"

@implementation AppDelegate

@synthesize window, view_controller, my_self;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   // create my_self from scratch or from persistent storage.
   my_self = [[MySelf alloc] initWithName:[[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_USER] password:[[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_PASSWORD]];

   view_controller = [[DRMapViewController alloc] initWithNibName:@"DRMapView" bundle:nil];
   [window addSubview:view_controller.view];
   [window makeKeyAndVisible];
}

- (void)dealloc
{
   [view_controller release];
   [window release];
   [my_self release];
   [super dealloc];
}

@end

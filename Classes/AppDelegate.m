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
#import "SettingViewController.h"

@interface AppDelegate (Private)
- (void) showAuthorization;
@end // AppDelegate

@implementation AppDelegate

@synthesize window, view_controller, my_self;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   if (! [[NSUserDefaults standardUserDefaults] boolForKey:DR_TWITTER_AUTHORIZED]) {
      my_self = nil;
      // authorize first
      [self showAuthorization];
   } else {
      [self authorized];
   }
   [window makeKeyAndVisible];
}

- (void)dealloc
{
   [view_controller release];
   [window release];
   if (my_self) [my_self release];
   [super dealloc];
}

- (void) applicationWillTerminate:(UIApplication *)application
{
   [my_self saveFriends];
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) authorized
{
   [setting_view_controller release];

   // create my_self from scratch or from persistent storage.
   my_self = [[MySelf alloc] initWithName:[[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_USER] password:[[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_PASSWORD]];

   view_controller = [[DRMapViewController alloc] initWithNibName:@"DRMapView" bundle:nil];
   [window addSubview:view_controller.view];
}

@end // AppDelegate

@implementation AppDelegate (Private)

- (void) showAuthorization
{
   setting_view_controller = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
   //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
   //[self presentModalViewController:nc animated:YES];
   //[nc release];
   [window addSubview:setting_view_controller.view];
   //[svc release];
}

@end // AppDelegate (Private)

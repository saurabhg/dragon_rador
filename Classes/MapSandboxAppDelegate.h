//
//  MapSandboxAppDelegate.h
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "SandboxMapViewController.h"

@interface MapSandboxAppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   SandboxMapViewController *view_controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *view_controller;

@end
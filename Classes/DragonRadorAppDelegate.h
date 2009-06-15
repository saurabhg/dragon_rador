//
//  DragonRadorAppDelegate.h
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "DragonRadorMapViewController.h"

@interface DragonRadorAppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   DragonRadorMapViewController *view_controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *view_controller;

@end
//
//  AppDelegate.h
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "DRMapViewController.h"

@class MySelf;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   DRMapViewController *view_controller;
   MySelf *my_self;
}

@property (nonatomic, assign) MySelf *my_self;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *view_controller;

@end

//
//  AppDelegate.h
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "DRMapViewController.h"

@class MySelf, SettingViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   DRMapViewController *view_controller;
   MySelf *my_self;
   SettingViewController *setting_view_controller;
}

@property (nonatomic, assign) MySelf *my_self;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *view_controller;

- (void) authorized;

@end

//
//  SandboxMapViewController.h
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "UICUserLocation.h"
@protocol MKMapViewDelegate;
@class MKMapView;

@interface SandboxMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
   IBOutlet MKMapView *map_view;
   NSMutableArray *friends;
   CLLocationManager *location_manager;
}

@property (nonatomic, retain) MKMapView *map_view;

- (IBAction) openSettings;
- (IBAction) goHome;
- (IBAction) moveOther;
- (IBAction) showFriends;
- (IBAction) updateMyLocation;
- (IBAction) showCurrentLocation;

@end

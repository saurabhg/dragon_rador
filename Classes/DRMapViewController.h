//
//  DRMapViewController.h
//  DragonRador
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "UICUserLocation.h"
@protocol MKMapViewDelegate;
@class MKMapView;

@interface DRMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
   IBOutlet MKMapView *map_view;
   CLLocationManager *location_manager;
   NSMutableArray *friends;
}

@property (nonatomic, retain) MKMapView *map_view;

- (IBAction) openSettings;
- (IBAction) goHome;
- (IBAction) moveOther;
- (IBAction) pickFriends;
- (IBAction) showCurrentLocation;

@end

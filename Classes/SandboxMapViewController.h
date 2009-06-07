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

@interface SandboxMapViewController : UIViewController <MKMapViewDelegate>
{
   IBOutlet MKMapView *map_view;
   UICUserLocation *other_user_location;
}

@property (nonatomic, retain) MKMapView *map_view;

- (IBAction) openSettings;
- (IBAction) goHome;
- (IBAction) moveOther;

@end
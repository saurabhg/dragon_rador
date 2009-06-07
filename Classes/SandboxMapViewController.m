//
//  SandboxMapViewController.m
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "SandboxMapViewController.h"
#import "UICUserLocation.h"

@implementation SandboxMapViewController
@synthesize map_view;

- (void) dealloc
{
   [other_user_location release];
   [super dealloc];
}

- (void) viewDidLoad
{
   [super viewDidLoad];

   CLLocation *loc = [[CLLocation alloc] initWithLatitude:35.697944f longitude:139.414398f];
   other_user_location = [[UICUserLocation alloc] initWithFrame:CGRectMake(32, 32, 24, 24) location:loc];
   [loc release];
   other_user_location.user_name = @"> <";
   
   [self.view addSubview:other_user_location];
   [other_user_location release];
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
   //NSLog(@"mapView:mapView regionWillChangeAnimated: region = {lat => %f, long => %f}, span = {lat => %f, long => %f}, animated=%d", mapView.region.center.latitude, mapView.region.center.longitude, mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta, animated);

   //CGPoint pt = [mapView convertCoordinate:other_user_location.coordinate toPointToView:nil];
   //other_user_location.center = pt;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
   CGPoint pt = [mapView convertCoordinate:other_user_location.location.coordinate toPointToView:nil];

   [UIView beginAnimations:nil context:NULL]; {
      [UIView setAnimationDuration:0.20f];
      [UIView setAnimationDelegate:self];

      other_user_location.center = pt;
   } [UIView commitAnimations];
   
}

- (IBAction) goHome
{
   const MKCoordinateRegion my_home = {{35.697944f, 139.414398f}, {0.017914f, 0.018021f}};
   [self.map_view setRegion:my_home];
}

- (IBAction) moveOther
{
   CLLocation *cur = other_user_location.location;
   CLLocation *nxt = [[CLLocation alloc] initWithLatitude:cur.coordinate.latitude + 3.0f longitude:cur.coordinate.longitude + 3.0f];
   other_user_location.location = nxt;
   [nxt release];
}

@end
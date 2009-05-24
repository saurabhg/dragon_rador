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

   other_user_location = [[UICUserLocation alloc] initWithFrame:CGRectMake(32, 32, 24, 24)];
   other_user_location.user_name = @"> <";
   
   CLLocationCoordinate2D coord = {35.697944f, 139.414398f};
   other_user_location.coordinate = coord;
   [self.view addSubview:other_user_location];
   [other_user_location release];
}

- (IBAction) showParticles
{
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
   NSLog(@"mapView:mapView regionWillChangeAnimated: region = {lat => %f, long => %f}, span = {lat => %f, long => %f}, animated=%d", mapView.region.center.latitude, mapView.region.center.longitude, mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta, animated);

   CGPoint pt = [mapView convertCoordinate:other_user_location.coordinate toPointToView:nil];
   other_user_location.center = pt;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
   CGPoint pt = [mapView convertCoordinate:other_user_location.coordinate toPointToView:nil];
   other_user_location.center = pt;
}

- (IBAction) goHome
{
   MKCoordinateRegion my_home = {{35.697944f, 139.414398f}, {0.017914f, 0.018021f}};
   [self.map_view setRegion:my_home];
}

@end
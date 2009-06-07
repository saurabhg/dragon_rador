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
#import "SettingViewController.h"

@interface SandboxMapViewController (Private)
- (void) setupNetwork;
- (void) setupDummies;
@end

@implementation SandboxMapViewController
@synthesize map_view;

- (void) dealloc
{
   [friends release];
   [super dealloc];
}

- (void) viewDidLoad
{
   [super viewDidLoad];
   
   friends = [[NSMutableArray array] retain];
   
   const MKCoordinateRegion initial_region = {
#ifdef TARGET_IPHONE_SIMULATOR
      {35.697944f, 139.414398f},
#else // TARGET_IPHONE_SIMULATOR
      {map_view.userLocation.location.coordinate.latitude, map_view.userLocation.location.coordinate.longitude},
#endif // TARGET_IPHONE_SIMULATOR
      {0.1f, 0.1f}};
   map_view.region = initial_region;

   [self setupNetwork];
   [self setupDummies];
   
   for (UICUserLocation *ul in friends) {      
      [self.view addSubview:ul];      
   }
}

- (void) updateAll
{
   [UIView beginAnimations:nil context:NULL]; {
      [UIView setAnimationDuration:0.20f];
      [UIView setAnimationDelegate:self];

      for (UICUserLocation *ul in friends) {
         CGPoint pt = [map_view convertCoordinate:ul.location.coordinate toPointToView:nil];
         ul.center = pt;
      }
   } [UIView commitAnimations];
}

#pragma mark MapKit delegates

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
   [self updateAll];
}

#pragma mark IBActions

- (IBAction) goHome
{
   const MKCoordinateRegion my_home = {{35.697944f, 139.414398f}, {0.017914f, 0.018021f}};
   [self.map_view setRegion:my_home];
}

- (IBAction) moveOther
{
   /*
   CLLocation *cur = other_user_location.location;
   CLLocation *nxt = [[CLLocation alloc] initWithLatitude:cur.coordinate.latitude + 0.1f longitude:cur.coordinate.longitude + 0.1f];
   [other_user_location updateLocation:nxt];
   [nxt release];
   
   [self updateAll];
   */
}

- (IBAction) openSettings
{
   SettingViewController *svc = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
   UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
   [self presentModalViewController:nc animated:YES];
   [nc release];
   [svc release];
}

- (IBAction) showFriends
{
}

#pragma mark Network

- (void) setupNetwork
{
}

- (void) setupDummies
{
   CLLocation *loc = [[CLLocation alloc] initWithLatitude:35.697944f longitude:139.414398f];
   UICUserLocation *other_user_location = [[UICUserLocation alloc] initWithFrame:CGRectMake(32, 32, 16, 16) location:loc];
   [loc release];
   other_user_location.user_name = @"> <";
   [friends addObject:other_user_location];
   [other_user_location release];   
}

@end
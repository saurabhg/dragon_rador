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
#import "DragonRador.h"
#import "FriendsPickViewController.h"

@interface SandboxMapViewController (Private)
- (void) setupNetwork;
- (void) setupDummies;
@end

@implementation SandboxMapViewController
@synthesize map_view;

- (void) dealloc
{
   [location_manager dealloc];
   [friends release];
   [super dealloc];
}

- (void) viewDidLoad
{
   [super viewDidLoad];
   
   NSArray *saved_friends = [[NSUserDefaults standardUserDefaults] arrayForKey:DR_FRIENDS];
   friends = saved_friends ? [NSMutableArray arrayWithArray:saved_friends] : [NSMutableArray array];
   [friends retain];
   
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

   location_manager = [[CLLocationManager alloc] init];
   location_manager.delegate = self;
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

- (IBAction) pickFriends
{
   FriendsPickViewController *fpvc = [[FriendsPickViewController alloc] initWithNibName:nil bundle:nil];
   UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:fpvc];
   [self presentModalViewController:nc animated:YES];
   [nc release];
   [fpvc release];
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

- (void) updateMyLocation
{
   NSDictionary *current_my_info = [[NSUserDefaults standardUserDefaults] dictionaryForKey:DR_MY_LOCATION];
	// Timestamp
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
   NSDate *timestamp_date = [current_my_info objectForKey:@"timestamp"];
   NSString *timestamp = [dateFormatter stringFromDate:timestamp_date];
	
   NSLog(@"lat=%f, long=%f, timestamp=%@",
      [[current_my_info objectForKey:@"latitude"] floatValue],
      [[current_my_info objectForKey:@"longitude"] floatValue],
      timestamp);

   NSString *post_str = [NSString stringWithFormat:@"name=%@&location=(%f,%f)&timestamp=%@",
      [[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_USER],
      [[current_my_info objectForKey:@"latitude"] floatValue],
      [[current_my_info objectForKey:@"longitude"] floatValue],
      timestamp];

   NSData *post_data = [post_str dataUsingEncoding:NSASCIIStringEncoding];

   NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/update", LOCATION_SERVER]]];
   [req setHTTPMethod:@"POST"];
   [req setHTTPBody:post_data];

   NSURLResponse *res = nil;
   NSError *err = nil;
   [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
   if (err) {
      NSLog(@"error: %@", [err localizedDescription]);
   }
}

#pragma CLLocationManager

- (IBAction) showCurrentLocation
{
   [location_manager startUpdatingLocation];
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
   NSArray *keys = [NSArray arrayWithObjects:@"latitude", @"longitude", @"timestamp", nil];
   NSArray *vals = [NSArray arrayWithObjects:[NSNumber numberWithFloat:newLocation.coordinate.latitude], [NSNumber numberWithFloat:newLocation.coordinate.longitude], newLocation.timestamp, nil];
   NSDictionary *current_my_info = [NSDictionary dictionaryWithObjects:vals forKeys:keys];
   [[NSUserDefaults standardUserDefaults] setObject:current_my_info forKey:DR_MY_LOCATION];
   [self updateMyLocation];
#if 0
	// Horizontal coordinates
	if (signbit(newLocation.horizontalAccuracy)) {
		// Negative accuracy means an invalid or unavailable measurement
		//[update appendString:LocStr(@"LatLongUnavailable")];
	} else {
		// CoreLocation returns positive for North & East, negative for South & West
		[update appendFormat:LocStr(@"LatLongFormat"), // This format takes 4 args: 2 pairs of the form coordinate + compass direction
       fabs(newLocation.coordinate.latitude), signbit(newLocation.coordinate.latitude) ? LocStr(@"South") : LocStr(@"North"),
       fabs(newLocation.coordinate.longitude),	signbit(newLocation.coordinate.longitude) ? LocStr(@"West") : LocStr(@"East")];
		[update appendString:@"\n"];
		[update appendFormat:LocStr(@"MeterAccuracyFormat"), newLocation.horizontalAccuracy];
	}
	[update appendString:@"\n\n"];
   
	// Altitude
	if (signbit(newLocation.verticalAccuracy)) {
		// Negative accuracy means an invalid or unavailable measurement
		[update appendString:LocStr(@"AltUnavailable")];
	} else {
		// Positive and negative in altitude denote above & below sea level, respectively
		[update appendFormat:LocStr(@"AltitudeFormat"), fabs(newLocation.altitude),	(signbit(newLocation.altitude)) ? LocStr(@"BelowSeaLevel") : LocStr(@"AboveSeaLevel")];
		[update appendString:@"\n"];
		[update appendFormat:LocStr(@"MeterAccuracyFormat"), newLocation.verticalAccuracy];
	}
	[update appendString:@"\n\n"];
	
	// Calculate disatance moved and time elapsed, but only if we have an "old" location
	//
	// NOTE: Timestamps are based on when queries start, not when they return. CoreLocation will query your
	// location based on several methods. Sometimes, queries can come back in a different order from which
	// they were placed, which means the timestamp on the "old" location can sometimes be newer than on the
	// "new" location. For the example, we will clamp the timeElapsed to zero to avoid showing negative times
	// in the UI.
	//
	if (oldLocation != nil) {
		CLLocationDistance distanceMoved = [newLocation getDistanceFrom:oldLocation];
		NSTimeInterval timeElapsed = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
		
		[update appendFormat:LocStr(@"LocationChangedFormat"), distanceMoved];
		if (signbit(timeElapsed)) {
			[update appendString:LocStr(@"FromPreviousMeasurement")];
		} else {
			[update appendFormat:LocStr(@"TimeElapsedFormat"), timeElapsed];
		}
		[update appendString:@"\n\n"];
	}
	
	// Send the update to our delegate
	[self.delegate newLocationUpdate:update];
#endif // 0
}

#if 0
// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
   
	if ([error domain] == kCLErrorDomain) {
      
		// We handle CoreLocation-related errors here
      
		switch ([error code]) {
            // This error code is usually returned whenever user taps "Don't Allow" in response to
            // being told your app wants to access the current location. Once this happens, you cannot
            // attempt to get the location again until the app has quit and relaunched.
            //
            // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
            // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            //
			case kCLErrorDenied:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
				break;
            
            // This error code is usually returned whenever the device has no data or WiFi connectivity,
            // or when the location cannot be determined for some other reason.
            //
            // CoreLocation will keep trying, so you can keep waiting, or prompt the user.
            //
			case kCLErrorLocationUnknown:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
				break;
            
            // We shouldn't ever get an unknown error code, but just in case...
            //
			default:
				[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
   
	// Send the update to our delegate
	[self.delegate newLocationUpdate:errorString];
}
#endif // 0
@end

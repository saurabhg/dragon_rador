//
//  UICUserLocation.h
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <MapKit/MapKit.h>

/**
 * similar to MKUserLocation.
 */
@interface UICUserLocation : UIView <MKAnnotation>
{
   NSString *user_name;
   CLLocation *location;
//   BOOL updating;
   CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *user_name;
@property (nonatomic, retain) CLLocation *location;
//@property (readonly, nonatomic, getter=isUpdating) BOOL updating;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
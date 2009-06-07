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
}

@property (nonatomic, retain) NSString *user_name;
@property (nonatomic, retain) CLLocation *location;

- (id) initWithFrame:(CGRect)frame location:(CLLocation *)loc;
- (void) updateLocation:(CLLocation *)loc;

@end
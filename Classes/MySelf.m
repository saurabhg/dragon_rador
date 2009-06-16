//
//  MySelf.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MySelf.h"
#import "TwitterFriends.h"
#import "DragonRador.h"

@interface MySelf (Private)
@end // MySelf (Private)

@implementation MySelf
@synthesize visible;

- (id) initWithName:(NSString *)name password:(NSString *)pw
{
   if (self = [super init]) {
      twitter_user_name = [name retain];
      twitter_password = [pw retain];
      friends = [[NSMutableSet set] retain];
      visible = YES; // visible by default
   }
   return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
   twitter_user_name = [[decoder decodeObjectForKey:@"twitter_user_name"] retain];
   twitter_password = [[decoder decodeObjectForKey:@"twitter_password"] retain];
   friends = [[decoder decodeObjectForKey:@"friends"] retain];
   visible = YES; // visible by default
   return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
   NSAssert(NO, @"not implemented yet");
   // TODO
}

- (void) dealloc
{
   [friends release];
   [twitter_password release];
   [twitter_user_name release];
   [super dealloc];
}

- (void) toggleVisible
{
   visible = ! visible;
   // TODO: do something with updating view..
}

- (void) sendCurrentLocation:(CLLocation *)location
{
   // Timestamp
   NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
   [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
   [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
   NSString *timestamp = [dateFormatter stringFromDate:location.timestamp];

   NSLog(@"lat=%f, long=%f, timestamp=%@",
      location.coordinate.latitude, location.coordinate.longitude, timestamp);

   NSString *post_str = [NSString stringWithFormat:@"name=%@&location=(%f,%f)&timestamp=%@",
      twitter_user_name,
      location.coordinate.latitude, location.coordinate.longitude,
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

- (NSArray *) twitterFriends
{
   TwitterFriends *tf = [[TwitterFriends alloc] initWithName:twitter_user_name];
   NSArray *twitter_friends = [[tf retrieveFriends] retain];
   [tf release];
   return twitter_friends;
}

@end

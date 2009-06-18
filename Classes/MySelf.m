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
- (void) loadFriends;
@end // MySelf (Private)

@implementation MySelf
@synthesize visible, friends;

#define FRIENDS_FILE @"friends.dat"

- (id) initWithName:(NSString *)name password:(NSString *)pw
{
   if (self = [super init]) {
      twitter_user_name = [name retain];
      twitter_password = [pw retain];

      [self loadFriends];
      NSLog(@"friends are %@", friends);

      visible = YES; // visible by default
   }
   return self;
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

   // construct POST request
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

@implementation MySelf (Private)

- (void) loadFriends
{
   /*
   NSFileManager *fm = [NSFileManager defaultManager];
   if ([fm fileExistsAtPath:FRIENDS_FILE]) {
      NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
      NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
      self.friends = [decoder decodeObjectForKey:@"friends"];
      [decoder finishDecoding];
      [decoder release];
   } else {
      self.friends = [NSMutableSet set];
   }
   */
}

@end

//
//  Friend.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "Friend.h"
#import "DragonRador.h"
#import <CoreLocation/CoreLocation.h>

@implementation Friend

@synthesize name, image_url, image, location, last_update;

- (id) initWithName:(NSString *)nm
{
   if (self = [super init]) {
      self.name = nm;
   }
   return self;
}

- (void) dealloc
{
   [name release];
   if (image) [image release];
   if (location) [location release];
   if (last_update) [last_update release];
   [super dealloc];
}

#pragma mark NSCoding

- (id) initWithCoder:(NSCoder *) decoder
{
   self.name = [decoder decodeObjectForKey:@"name"];
   self.image_url = [decoder decodeObjectForKey:@"image_url"];
   self.location = [decoder decodeObjectForKey:@"location"];
   self.last_update = [decoder decodeObjectForKey:@"last_update"];

   return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
   [encoder encodeObject:name forKey:@"name"];
   [encoder encodeObject:image_url forKey:@"image_url"];
   [encoder encodeObject:location forKey:@"location"];
   [encoder encodeObject:last_update forKey:@"last_update"];
}

#pragma mark --
- (void) update
{
   NSLog(@"update for user=%@", name);
   NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user?name=%@", LOCATION_SERVER, name]]];
   NSURLResponse *res = nil;
   NSError *err = nil;
   NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
   if (err) {
      NSLog(@"error: %@", [err localizedDescription]);
   }
   NSString *result_str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
   NSLog(@"Friend:update: %@", result_str);
   NSArray *comps = [result_str componentsSeparatedByString:@"&"];
   NSAssert([[comps objectAtIndex:0] isEqualToString:name], @"name should be equal");

   NSArray *loc = [[comps objectAtIndex:1] componentsSeparatedByString:@","];
   CLLocation *new_loc = [[CLLocation alloc] initWithLatitude:[[loc objectAtIndex:0] floatValue] longitude:[[loc objectAtIndex:1] floatValue]];
   self.location = new_loc;

   // Timestamp
   NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
   [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
   [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];


   NSDate *lu = [dateFormatter dateFromString:[comps objectAtIndex:2]];
   NSLog(@"last update = %@ from %@", lu, [comps objectAtIndex:2]);
   self.last_update = lu;

   NSLog(@"Friend is now %@", self);
}

- (void) cacheImage
{
}

- (BOOL) isEqual:(id) other
{
   NSLog(@"Friend:isEqual");
   Friend *other_friend = (Friend *)other;
   return [name isEqualToString:other_friend.name];
}

- (NSString *) description
{
   return [NSString stringWithFormat:@"Friend %p: name=%@, location=%@,  last_update=%@, image_url=%@", self, name, location, last_update, image_url];
}

@end

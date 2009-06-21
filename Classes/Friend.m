//
//  Friend.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "Friend.h"

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
   return [NSString stringWithFormat:@"Friend %p: name=%@", self, name];
   //return [NSString stringWithFormat:@"Friend %p: name=%@", self, @"hoge"];
}

@end

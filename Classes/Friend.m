//
//  Friend.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize name, image, location, last_update;

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

- (void) update
{
}

@end

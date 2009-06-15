//
//  MySelf.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "MySelf.h"

@implementation MySelf
@synthesize visible;

- (id) initWithName:(NSString *)name password:(NSString *)pw
{
   if (self = [super init]) {
      twitter_user_name = [name retain];
      twitter_password = [pw retain];
      friends = [[NSMutableSet set] retain];
      visible = YES;
   }
   return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
   // TODO
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

- (void) sendCurrentLocation
{
   // TODO
}

@end

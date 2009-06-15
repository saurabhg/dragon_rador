//
//  MySelf.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "MySelf.h"
#import "TwitterFriends.h"

@interface MySelf (Private)
- (NSArray *) retrieveFriends;
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

- (NSArray *) twitterFriends
{
   TwitterFriends *tf = [[TwitterFriends alloc] initWithName:twitter_user_name];
   NSArray *twitter_friends = [[tf retrieveFriends] retain];
   [tf release];
   return twitter_friends;
}

@end

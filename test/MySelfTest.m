//
//  MySelfTest.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/16/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "MySelfTest.h"
#import "MySelf.h"
#import "PrivateInfo.h"

@implementation MySelfTest

- (void) setUp
{
   my_self = [[MySelf alloc] initWithName:PRIV_TWITTER_USER password:PRIV_TWITTER_PASS];
}

- (void) tearDown
{
   [my_self release];
}

- (void) testInstance
{
   STAssertNotNil(my_self, @"instance check");
}

- (void) testInitWithCoder
{
   MySelf *another_me = [[MySelf alloc] initWithCoder:nil];
   STAssertNotNil(another_me, @"instance check");
   [another_me release];
}

- (void) testToggleVisible
{
   STAssertTrue(my_self.visible, @"default is visible");
}

- (void) testTwitterFriends
{
   NSArray *twitter_friends = [my_self twitterFriends];
   STAssertTrue(twitter_friends.count > 0, @"at least one twitter friend exist");
}

- (void) testSendCurrentLocation
{
   //STAssertTrue(NO, @"not yet");
}

@end

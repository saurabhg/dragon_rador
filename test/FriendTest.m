//
//  FriendTest.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/21/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "FriendTest.h"
#import "Friend.h"
#import <CoreLocation/CoreLocation.h>

@implementation FriendTest

- (void) testInitWithName
{
   NSString *name = @"my friend";
   Friend *f = [[Friend alloc] initWithName:name];
   STAssertNotNil(f, @"instance check");
   STAssertTrue([name isEqualToString:f.name], @"name check");
}

- (void) testArchiver
{
   NSString *archive_path = @"/tmp/friend_test.dat";

   // create instance
   NSString *name       = @"test archiver";
   NSString *image_url  = @"archiver image url";
   CLLocation *location = [[CLLocation alloc] initWithLatitude:1.0f longitude:1.0f];
   NSDate *date         = [NSDate date];
   Friend *friend = [[Friend alloc] initWithName:name];
   friend.image_url = image_url;
   friend.location = location;
   friend.last_update = date;

   // encode it
   NSMutableData *the_data = [NSMutableData data];
   NSKeyedArchiver *encoder = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:the_data] autorelease];

   [friend encodeWithCoder:encoder];
   [encoder finishEncoding];
   [the_data writeToFile:archive_path atomically:YES];

   // decode it
   NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:the_data];
   Friend *decoded_friend = [[Friend alloc] initWithCoder:decoder];

   // check properties
   STAssertTrue([friend.name isEqualToString:decoded_friend.name], @"property check");
   STAssertTrue([friend.image_url isEqualToString:decoded_friend.image_url], @"property check");
   STAssertTrue(friend.location.coordinate.latitude == decoded_friend.location.coordinate.latitude, @"property check");
   STAssertTrue(friend.location.coordinate.longitude == decoded_friend.location.coordinate.longitude, @"property check");
   STAssertTrue([friend.last_update isEqualToDate:decoded_friend.last_update], @"property check");
}

@end

//
//  MySelf.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend, CLLocation;

@interface MySelf : NSObject <NSCoding>
{
   NSString *twitter_user_name;
   NSString *twitter_password;

   NSMutableArray *friends;  // collection of Friend
   BOOL visible;
}

@property (readonly) BOOL visible;
@property (nonatomic,readonly) NSMutableArray *friends;

- (id) initWithName:(NSString *)name password:(NSString *)pw;

- (void) toggleVisible;
// POST current location to the app server.
- (void) sendCurrentLocation:(CLLocation *)location;
- (NSArray *) twitterFriends; // friends on Twitter
- (void) addFriend:(Friend *)friend;
- (void) removeFriend:(Friend *)friend;

@end

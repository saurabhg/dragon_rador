//
//  MySelf.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend;

@interface MySelf : NSObject <NSCoding>
{
   NSString *twitter_user_name;
   NSString *twitter_password;

   NSMutableSet *friends;  // collection of Friend
   BOOL visible;
}

@property (readonly) BOOL visible;

- (id) initWithName:(NSString *)name password:(NSString *)pw;

- (void) toggleVisible;
- (void) sendCurrentLocation;
- (NSArray *) twitterFriends; // friends on Twitter
- (void) addFriend:(Friend *)friend;
- (void) removeFriend:(Friend *)friend;

@end

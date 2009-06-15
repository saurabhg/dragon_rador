//
//  TwitterFriends.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/16/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterFriends : NSObject
{
   enum state_t {
      STATE_NULL,
      STATE_ID,
      STATE_SCREEN_NAME,
      STATE_IMAGE
   } state;

   NSString *me;
   NSMutableArray *friends;
   NSMutableDictionary *friend;
}

- (id) initWithName:(NSString *)name;
- (NSArray *) retrieveFriends;        // retrieve at most 100 friends at once

@end // TwitterFriends

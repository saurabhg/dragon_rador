//
//  Friend.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

@class CLLocation;

@interface Friend : NSObject
{
   NSString *name;
   UIImage *image;
   CLLocation *location;
   NSDate *last_update;
}

- (void) update;

@end

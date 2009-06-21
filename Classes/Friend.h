//
//  Friend.h
//  DragonRador
//
//  Created by Motohiro Takayama on 6/15/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class UIImage;

@interface Friend : NSObject <NSCoding>
{
   NSString *name;
   NSString *image_url;
   UIImage *image;
   CLLocation *location;
   NSDate *last_update;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSDate *last_update;

- (id) initWithName:(NSString *)nm;
- (void) update; // retrieve latest information from the server
- (void) cacheImage; // retrieve image from image_url and cache it

@end

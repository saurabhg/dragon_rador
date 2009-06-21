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

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *image_url;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) CLLocation *location;
@property (nonatomic, assign) NSDate *last_update;

- (id) initWithName:(NSString *)nm;
- (void) update; // retrieve latest information from the server
- (void) cacheImage; // retrieve image from image_url and cache it

@end

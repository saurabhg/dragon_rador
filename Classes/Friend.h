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

@interface Friend : NSObject
{
   NSString *name;
   UIImage *image;
   CLLocation *location;
   NSDate *last_update;
}

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) CLLocation *location;
@property (nonatomic, assign) NSDate *last_update;

- (id) initWithName:(NSString *)nm;
- (void) update; // retrieve latest information from the server

@end

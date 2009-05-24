//
//  UICUserLocation.m
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//
#import "UICUserLocation.h"

@implementation UICUserLocation
@synthesize user_name, location, coordinate;

const CGFloat initial_color[] = {0.0f, 51.0f/256.0f, 102.0f/256.0f, 1.0f};
CGFloat current_color[] = {0.0f, 51.0f/256.0f, 102.0f/256.0f, 1.0f};

- (id)initWithFrame:(CGRect)aRect
{
   if (self = [super initWithFrame:aRect]) {
      self.opaque = NO;
      self.alpha = 1.0f;
      NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.06f target:self selector:@selector(move) userInfo:nil repeats:YES];
   }
   return self;
}

- (void) dealloc
{
   if (user_name) [user_name release];
   if (location) [location release];
   [super dealloc];
}

- (void) move
{
   static const int MAX = 20;
   static int delta = 1;
   //NSLog(@"move coord = (%f, %f) center = (%f, %f), %p", self.coordinate.latitude, self.coordinate.longitude, self.center.x, self.center.y, self);
//   self.location = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude + 1.0f longitude:location.coordinate.longitude + 1.0f];
//   self.frame = CGRectMake(self.frame.origin.x + 1.0f, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
   if (current_color[0] > 0.6f) {
      current_color[0] = initial_color[0];
      current_color[1] = initial_color[1];
      current_color[2] = initial_color[2];
   }
   current_color[0] += (float)delta / MAX;
   current_color[1] += (float)delta / MAX;
   current_color[2] += (float)delta / MAX;
   [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetTextDrawingMode(context, kCGTextFill);

   CGContextSetRGBStrokeColor(context, 0.0f, 51.0f/256.0f, 102.0f/256.0f, 1.0);
   CGContextSetLineWidth(context, 1.0f);

   CGContextSetFillColor(context, current_color);
   CGContextFillEllipseInRect(context, rect);   
   
   CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
   /*
   [user_name drawInRect:CGRectMake(8, 8, rect.size.width, rect.size.height)
           withFont:[UIFont systemFontOfSize:12]
      lineBreakMode:UILineBreakModeTailTruncation];
    */
}

@end
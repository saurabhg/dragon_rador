//
//  UICUserLocation.m
//  MapSandbox
//
//  Created by mootoh on 5/24/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//
#import "UICUserLocation.h"

@implementation UICUserLocation
@synthesize user_name, location;

const CGFloat initial_color[] = {0.0f, 51.0f/256.0f, 102.0f/256.0f, 1.0f};
CGFloat current_color[] = {0.0f, 51.0f/256.0f, 102.0f/256.0f, 1.0f};

- (id)initWithFrame:(CGRect)aRect location:(CLLocation *) loc
{
   if (self = [super initWithFrame:aRect]) {
      self.opaque = NO;
      self.alpha = 1.0f;
      self.location = loc;
      //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.06f target:self selector:@selector(animate_color) userInfo:nil repeats:YES];
   }
   return self;
}

- (void) dealloc
{
   if (user_name) [user_name release];
   if (location) [location release];
   [super dealloc];
}

- (void) animate_color
{
   static const int MAX = 20;
   static int delta = 1;

   if (current_color[0] > 0.6f) {
      current_color[0] = initial_color[0];
      current_color[1] = initial_color[1];
      current_color[2] = initial_color[2];
   }
   current_color[0] += (float)delta / MAX;
   current_color[1] += (float)delta / MAX;
   current_color[2] += (float)delta / MAX;

   self.center = CGPointMake(self.center.x + 1.0f, self.center.y + 1.0f);
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
}

@end
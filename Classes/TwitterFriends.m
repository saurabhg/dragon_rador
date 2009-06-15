//
//  TwitterFriends.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/16/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "TwitterFriends.h"

@implementation TwitterFriends

- (id) initWithName:(NSString *)name
{
   if (self = [super init]) {
      state = STATE_NULL;
      me = [name retain];
      friends = [[NSMutableArray alloc] init];
   }
   return self;
}

- (void) dealloc
{
   [friends release];
   [me release];
   [super dealloc];
}

- (NSArray *) retrieveFriends
{
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/statuses/friends/%@.xml", me]];
   NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:url] autorelease];
   parser.delegate = self;
   if (! [parser parse]) {
      return nil;
   }
   return friends;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
   if ([elementName isEqualToString:@"user"]) {
      NSAssert(state == STATE_NULL, @"check state");
      friend = [[NSMutableDictionary alloc] init];
   } else if ([elementName isEqualToString:@"id"]) {
      state = STATE_ID;
   } else if ([elementName isEqualToString:@"screen_name"]) {
      state = STATE_SCREEN_NAME;
   } else if ([elementName isEqualToString:@"profile_image_url"]) {
      state = STATE_IMAGE;
   }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
   if ([elementName isEqualToString:@"user"]) {
      [friends addObject:friend];
      [friend release];
   }
   state = STATE_NULL;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)chars
{
   switch (state) {
      case STATE_ID:
         [friend setObject:chars forKey:@"id"];
         break;
      case STATE_SCREEN_NAME:
         [friend setObject:chars forKey:@"screen_name"];
         break;
      case STATE_IMAGE:
         [friend setObject:chars forKey:@"image_url"];
         break;
      default:
         break;
   }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
   NSLog(@"error occurred: %@", [parseError localizedDescription]);
}

@end // TwitterFriends



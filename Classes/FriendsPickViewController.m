//
//  FriendsPickViewController.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/14/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "FriendsPickViewController.h"
#import "DragonRador.h"

#pragma mark TwitterFriends

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

@end // TwitterFriends

@implementation TwitterFriends

- (id) init:(NSString *)name
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

#pragma mark FriendsPickViewController

@implementation FriendsPickViewController

- (UIImage *) getIcon:(NSDictionary *)user
{
   NSURL *url = [NSURL URLWithString:[user objectForKey:@"image_url"]];

   NSURLRequest *req = [NSURLRequest requestWithURL:url];
   NSURLResponse *res = nil;
   NSError *err = nil;
   NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
   if (err) {
      NSLog(@"error: %@", [err localizedDescription]);
   }
   UIImage *img = [UIImage imageWithData:data];
   return [img retain];
}

#pragma mark ViewController
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad
{
   [super viewDidLoad];
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
   self.navigationItem.leftBarButtonItem = backButton;
   [backButton release];

   NSArray *saved_friends = [[NSUserDefaults standardUserDefaults] arrayForKey:DR_FRIENDS];
   selected_friends = saved_friends ? [NSMutableArray arrayWithArray:saved_friends] : [NSMutableArray array];
   [selected_friends retain];

   NSLog(@"saved friends are %@", saved_friends);

   TwitterFriends *tf = [[TwitterFriends alloc] init:[[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_USER]];
   friends = [[tf retrieveFriends] retain];
   [tf release];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return friends.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"FriendsPickViewCell";

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   }

   NSDictionary *user = [friends objectAtIndex:indexPath.row];
   UIImage *img = [self getIcon:user];
   cell.imageView.image = img;
   cell.textLabel.text = [user objectForKey:@"screen_name"];
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *user = [friends objectAtIndex:indexPath.row];
   [selected_friends addObject:[user objectForKey:@"screen_name"]]; 
   [[NSUserDefaults standardUserDefaults] setObject:selected_friends forKey:DR_FRIENDS];
   [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc
{
   [friends release];
   [super dealloc];
}

- (void) done
{
   [self dismissModalViewControllerAnimated:YES];  
}

@end


//
//  SettingViewController.m
//  DragonRador
//
//  Created by Motohiro Takayama on 6/7/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "SettingViewController.h"
#import "DragonRador.h"
#import "AppDelegate.h"

@interface SettingViewController (Private)
- (BOOL) authorize; // authorize via Twitter verify_credentials
- (BOOL) registToServer; // regist authorized user to the server.
@end // SettingViewController (Private)

@implementation SettingViewController
@synthesize table_view;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
   self.title = @"Setting";
   
   //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
   //self.navigationItem.leftBarButtonItem = backButton;
   //[backButton release];

   userField     = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 128, 22)];
   NSString *user_name = [[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_USER];
   if (user_name)
      userField.text = user_name;

   passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 128, 22)];
   passwordField.secureTextEntry = YES;
   NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:DR_TWITTER_PASSWORD];
   if (password)
      passwordField.text = password;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) dealloc
{
   [userField release];
   [passwordField release];
   [super dealloc];
}

- (void) done
{
   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DR_TWITTER_AUTHORIZED];

   // [self dismissModalViewControllerAnimated:YES];  
   AppDelegate *app = [UIApplication sharedApplication].delegate;
   [self.view removeFromSuperview];
   [app authorized];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (section == 0) {
      return 3;
   } else if (section == 1) {
      return 1;
   }
   
   return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   static NSString *CellIdentifier = @"SettingViewCell";
   
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   }
   
   // Set up the cell...
	
   if (indexPath.section == 0) {
      CGRect cellFrame = cell.frame;

      switch (indexPath.row) {
         case 0:
            cell.textLabel.text = @"Username";
            [cell.contentView addSubview:userField];
            break;
         case 1:
            cell.textLabel.text = @"Password";
            [cell.contentView addSubview:passwordField];
            break;
         case 2: {
            UIButton *commitUserInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            commitUserInfoButton.frame = CGRectMake(cellFrame.size.width/2-72/2, 2, 72, 40);
            [commitUserInfoButton setTitle:@"OK" forState:UIControlStateNormal];
            [commitUserInfoButton addTarget:self action:@selector(commitUserInfo) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:commitUserInfoButton];
            break;
         }
         default:
            break;
      }
   } else if (indexPath.section == 1) {
      cell.textLabel.text = @"Reset";
   }
   
   return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 1) {
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:DR_MY_LOCATION];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:DR_FRIENDS];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:DR_TWITTER_USER];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:DR_TWITTER_PASSWORD];
   }
   // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if (section == 0) {
      return @"Twitter account";
   } else if (section == 1) {
      return @"Add friends";
   }
   return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
   if (section == 0) {
      return @"We use your Twitter account information only for finding your friends.";
   }
   return nil;
}

@end // SettingViewController

@implementation SettingViewController (Private)

- (void) commitUserInfo
{
   NSLog(@"commitUserInfo");
   [[NSUserDefaults standardUserDefaults] setObject:userField.text forKey:DR_TWITTER_USER];
   [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:DR_TWITTER_PASSWORD];

   if ([self authorize]) {
      if ([self registToServer]) {
         [self done];
      } else {
         // Alert
      }
   } else {
      // Alert
   }
}

- (BOOL) authorize
{
   // start activity indicator

   // call Twitter verify_credentials API
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@@twitter.com/account/verify_credentials.xml", userField.text, passwordField.text]];
   NSURLRequest *req = [NSURLRequest requestWithURL:url];
   NSHTTPURLResponse *res = nil;
   NSError *err = nil;
   [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];

   // stop activity indicator

   if (err) {
      // show alert
      NSLog(@"error: %@", [err localizedDescription]);
      return NO;
   }

   return res.statusCode == 200;
}

- (BOOL) registToServer
{
   NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/register?user_name=%@", LOCATION_SERVER, userField.text]]];
   [req setHTTPMethod:@"POST"];
   //[req setHTTPBody:post_data];
   NSHTTPURLResponse *res = nil;
   NSError *err = nil;
   [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
   if (err) {
      NSLog(@"error: %@", [err localizedDescription]);
      return NO;
   }

   // check response
   return YES;
}

@end // SettingViewController (Private)

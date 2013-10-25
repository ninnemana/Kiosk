//
//  MakeViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "MakeViewController.h"
#import "ModelViewController.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "NSString_Encode.h"
#import "JSONKit.h"
#import "UIColorExtensions.h"


@implementation MakeViewController
@synthesize mount, year;
@synthesize makeTableView;


- (void)dealloc
{
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

 	self.tableView.backgroundColor = [UIColor fcext_colorWithHexString:@"343434"];
    self.tableView.separatorColor = [UIColor fcext_colorWithHexString:@"dddddd"];

	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setNavigationBarTintColor:[UIColor blackColor]];
	[self.navigationItem setHidesBackButton:NO animated:YES];
}


- (void)loadItems
{
	NSString* make_query = [NSString stringWithFormat:@"http://api.curtmfg.com/v2/getmake?mount=%@&year=%@&dataType=JSON",
                            [mount encodeString:NSUTF8StringEncoding],
                            [year encodeString:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL* makeURL = [NSURL URLWithString:make_query];
    
    [request setURL:makeURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    [activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
	 ^(NSURLResponse *response, NSData *make_data, NSError *err)
	 {
		 [activityIndicator stopAnimating];
		 if (err) {
			 if ([err code] == NSURLErrorNotConnectedToInternet)
				 [self showAlert:@"No internet connection available."];
			 else
				 [self showAlert:@"Failed to find makes for your vehicle year."];
		 } else {
			 NSMutableArray *results = [make_data objectFromJSONData];
			 int i;
			 for(i = 0; i < [results count]; i++) {
				 NSString *make = (NSString*)[results objectAtIndex:i];
				 [items addObject:make];
			 }
			 
			 UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
			 label.backgroundColor = [UIColor clearColor];
			 label.font = [UIFont boldSystemFontOfSize:20.0];
			 label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
			 label.textAlignment = UITextAlignmentCenter;
			 label.textColor = [UIColor fcext_colorWithHexString:@"ff581c"];
			 self.navigationItem.titleView = label;
			 label.text = @"Select Make";
			 [label sizeToFit];
			 
			 [self.tableView reloadData];
			 [self.view fcext_fade];
		 }
	 }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    // Set the cell's text to be the year at index of indexPath.row
    NSString *make = (NSString *)[items objectAtIndex:indexPath.row];
    NSString *formatted_make = [NSString stringWithFormat:@"%@",make];
    cell.textLabel.text = formatted_make;
    
    // Style the cell's background color to be black and text color to be orange
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor fcext_colorWithHexString:@"ff581c"];
    
    // We need to set  the styles for the selected cell
    
    // Create new UIView
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
    
    // Create new UILabel
    UILabel *selectedCell = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    [selectedCell setTextColor:[UIColor fcext_colorWithHexString:@"343434"]];
    [selectedCell setBackgroundColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
    
    // Add the UILabel to the UIView
    [bgColorView addSubview:selectedCell];
    [selectedCell release];
    [cell setSelectedBackgroundView:bgColorView];
    [cell sizeToFit];
    
    // Variable release
    [bgColorView release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the vehicle make
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *vehicle_make = selectedCell.textLabel.text;

    // Gain reference to the next level and push the view to it
    ModelViewController *modelViewController = [[ModelViewController alloc]init];
    modelViewController.mount = mount;
    modelViewController.year = year;
    modelViewController.make = vehicle_make;
    [self.navigationController pushViewController:modelViewController animated:YES];
    
    // Style the back button in our navigation bar to display year
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Make" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [backButton release];
    [modelViewController release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	RootViewController *rootViewController = [[RootViewController alloc]init];
    [rootViewController setHideBackButton:YES];
    [self.navigationController pushViewController:rootViewController animated:YES];
    [rootViewController release];
}


- (void) showAlert:(NSString*)msg
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


@end
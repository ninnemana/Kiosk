//
//  PartViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/11/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import "PartViewController.h"
#import "StyleViewController.h"
#import "DetailViewController.h"
#import "PartDetailController.h"
#import "RootViewController.h"
#import "KSDAppDelegate.h"
#import "JSONKit.h"
#import "NSString_Encode.h"
#import "UIColorExtensions.h"

@implementation PartViewController
@synthesize mount, year, make, model, style;


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


- (void)viewDidLoad
{
    [super viewDidLoad];

	selectedRow = NSNotFound;

    self.tableView.backgroundColor = [UIColor fcext_colorWithHexString:@"343434"];
    self.tableView.separatorColor = [UIColor fcext_colorWithHexString:@"dddddd"];

    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self setNavigationBarTintColor:[UIColor fcext_colorWithHexString:@"ed4e1a"]];
	[self.navigationController.navigationBar fcext_fade];
}


- (void)loadItems
{
    // We need to retrieve the Customer ID from the plist
    NSString *custIDString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"customerID"]];
    NSNumber *custID = [NSNumber numberWithInt:0];
    if([custIDString length] > 0){
        custID = (NSNumber *)custIDString;
    }

    // Create our string from vehicle data
    NSString *part_query = [NSString stringWithFormat:@"http://api.curtmfg.com/v2/getparts?dataType=JSON&mount=%@&year=%@&make=%@&model=%@&style=%@&cust_id=%@",
							[mount encodeString:NSUTF8StringEncoding],
							[year encodeString:NSUTF8StringEncoding],
							[make encodeString:NSUTF8StringEncoding],
							[model encodeString:NSUTF8StringEncoding],
							[style encodeString:NSUTF8StringEncoding],
							custID];
    
    // Compile the URL
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *partURL = [NSURL URLWithString:part_query];
    
    // Make the request to the CURT API
    [request setURL:partURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    // Parse out the response
	[activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
	 ^(NSURLResponse *response, NSData *part_data, NSError *err)
	 {
		 [activityIndicator stopAnimating];
		 if (err) {
			 if ([err code] == NSURLErrorNotConnectedToInternet)
				 [self showAlert:@"No internet connection available."];
			 else
				 [self showAlert:@"Failed to find parts for your vehicle."];
		 } else {
			 NSArray *unsorted_parts = [[JSONDecoder decoder] objectWithData:part_data];
			 
			 NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"pClass" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]autorelease];
			 
			 NSArray *descriptors = [NSArray arrayWithObject:descriptor];
			 NSArray *parts = [unsorted_parts sortedArrayUsingDescriptors:descriptors];
			 
			 int i;
			 for(i = ([parts count] - 1); i != -1; i--) {
				 [items addObject:[parts objectAtIndex:i]];
			 }
			 
			 // Format the UITableView header
			 UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
			 label.backgroundColor = [UIColor clearColor];
			 label.font = [UIFont boldSystemFontOfSize:20.0];
			 label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
			 label.textAlignment = UITextAlignmentCenter;
			 label.textColor = [UIColor fcext_colorWithHexString:@"343434"];
			 label.text = @"Available Parts";
			 self.navigationItem.titleView = label;
			 [label sizeToFit];
			 
			 [self.tableView reloadData];
			 [self.view fcext_fade];

			 if ([items count])
			 {
				 [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
				 
				 PartDetailController *partDetailController = [[PartDetailController alloc] init];
				 partDetailController.part = [items objectAtIndex:0];
				 partDetailController.mount = mount;
				 partDetailController.year = year;
				 partDetailController.make = make;
				 partDetailController.model = model;
				 partDetailController.style = style;
				 
				 UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];
				 self.splitViewController.viewControllers = [NSArray arrayWithObjects:lookupController, partDetailController, nil];
				 [partDetailController release];
			 }
		 }
	 }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	RootViewController *rootViewController = [[RootViewController alloc]init];
    [rootViewController setHideBackButton:YES];
    [self.navigationController pushViewController:rootViewController animated:YES];
    [rootViewController release];
}


- (void)showAlert:(NSString*)msg
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the relevant data for the part
    NSDictionary *part = [items objectAtIndex:indexPath.row];
    NSNumber *partID = (NSNumber *)[part objectForKey:@"partID"];
    NSString *desc = (NSString *)[part objectForKey:@"shortDesc"];
    NSString *class = [NSString stringWithFormat:@"%@", [part objectForKey:@"pClass"]];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    // Configure the cell...
    // Create the UIView
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor clearColor]];
    
    // Create UILabel with short description
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 75)];
    UILabel *descTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 265, 75)];
    descTextLabel.text = desc;
    descTextLabel.font = [UIFont boldSystemFontOfSize:18.0];
    descTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    descTextLabel.textAlignment = UITextAlignmentLeft;
    descTextLabel.numberOfLines = 0;
    [descTextLabel setBackgroundColor:[UIColor clearColor]];
    if([class length] == 0){
        [descLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"wiring_bg.png"]]];
    }else{
        [descLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hitch_bg.png"]]];
    }
    [descTextLabel setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
    [descLabel addSubview:descTextLabel];
    [descTextLabel release];
    [bgColorView addSubview:descLabel];
    [cell setBackgroundView:bgColorView];
    [bgColorView release];
    [descLabel release];
    
    // Set up the selected styling
    
    // Create the UIView
    UIView *selectedColorView = [[UIView alloc] init];
    //[selectedColorView setBackgroundColor:[UIColor clearColor]];
    if([class length] == 0){
        [selectedColorView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selected_wiring_bg.png"]]];
    }else{
        [selectedColorView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selected_hitch_bg.png"]]];
    }
    
    // Create UILabel with short description - selected
    UILabel *selecteddescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 75)];
    UILabel *selecteddescTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 265, 75)];
    selecteddescTextLabel.text = desc;
    selecteddescTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    selecteddescTextLabel.numberOfLines = 0;
    selecteddescTextLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [selecteddescTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [selecteddescTextLabel setTextColor:[UIColor fcext_colorWithHexString:@"343434"]];
    [selecteddescLabel addSubview:selecteddescTextLabel];
    [selectedColorView addSubview:selecteddescLabel];
    [selecteddescTextLabel release];
    [selecteddescLabel release];
    // Create UILabel with the Part #
    
    [cell setSelectedBackgroundView:selectedColorView];
    [selectedColorView release];
    [cell setAccessibilityValue:(NSString *)partID];
    
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == selectedRow)
		return;
	selectedRow = indexPath.row;

    NSDictionary *part = [items objectAtIndex:indexPath.row];

	PartDetailController *partDetailController = [[PartDetailController alloc] init];
    partDetailController.part = part;
    partDetailController.mount = mount;
    partDetailController.year = year;
    partDetailController.make = make;
    partDetailController.model = model;
    partDetailController.style = style;

    UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:lookupController, partDetailController, nil];
	[partDetailController release];

	KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.mainWindow fcext_fade];
}

@end

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
#import "JSONKit.h"
#import "NSString_Encode.h"

@implementation PartViewController
@synthesize detailViewController;
@synthesize year;
@synthesize make;
@synthesize model;
@synthesize style;
NSMutableArray *partList;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    partList = [[NSMutableArray alloc] init];
    NSArray *unsorted_parts;
    
    // We need to retrieve the Customer ID from the plist
    NSString *custIDString = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"customerID"]];
    NSNumber *custID = [NSNumber numberWithInt:0];
    if([custIDString length] > 0){
        custID = (NSNumber *)custIDString;
    }
    
    // Create our string from vehicle data
    NSString *part_query = [NSString stringWithFormat:@"http://docs.curthitch.biz/api/getparts?dataType=JSON&year=%@&make=%@&model=%@&style=%@&cust_id=%@",
                                        [year encodeString:NSUTF8StringEncoding],
                                        [make encodeString:NSUTF8StringEncoding],
                                        [model encodeString:NSUTF8StringEncoding],
                                        [style encodeString:NSUTF8StringEncoding],
                                        custID];
    
    // Compile the URL
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *partURL = [NSURL URLWithString:part_query];
    
    // Make the request to the CURT API
    [request setURL:partURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    // Parse out the response
    NSData *part_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if(err){
        [self showAlert:@"Failed to find parts for your vehicle."];
    }else{
        unsorted_parts = [[JSONDecoder decoder] objectWithData:part_data];
        
        NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"pClass" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]autorelease];
        
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        NSArray *parts = [unsorted_parts sortedArrayUsingDescriptors:descriptors];
        
        int i;
        for(i = 0; i < [parts count]; i++){
            [partList addObject:[parts objectAtIndex:i]];
        }
        
        // Format the UITableView header
        [self.navigationController.navigationBar setTintColor:[self colorWithHexString:@"ed4e1a"]];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [self colorWithHexString:@"343434"];
        label.text = @"Available Parts";
        self.navigationItem.titleView = label;
        [label sizeToFit];
    }
    
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    //[json_response release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [partList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the relevant data for the part
    NSDictionary *part = [partList objectAtIndex:indexPath.row];
    NSNumber *partID = (NSNumber *)[part objectForKey:@"partID"];
    NSString *desc = (NSString *)[part objectForKey:@"shortDesc"];
    NSString *class = [NSString stringWithFormat:@"%@",[part objectForKey:@"pClass"]];
    
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    tableView.separatorColor = [self colorWithHexString:@"dddddd"];
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
    [descTextLabel setTextColor:[self colorWithHexString:@"ff581c"]];
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
    
    [selecteddescTextLabel setTextColor:[self colorWithHexString:@"343434"]];
    [selecteddescLabel addSubview:selecteddescTextLabel];
    [selectedColorView addSubview:selecteddescLabel];
    [selecteddescTextLabel release];
    [selecteddescLabel release];
    // Create UILabel with the Part #
    
    [cell setSelectedBackgroundView:selectedColorView];
    [selectedColorView release];
    [cell setAccessibilityValue:(NSString *)partID];
    
    
    if(indexPath.row == 0){
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
        
        UIViewController *detailController = nil;
        
        PartDetailController *partDetailController = [[PartDetailController alloc] init];
        partDetailController.part = part;
        partDetailController.year = year;
        partDetailController.make = make;
        partDetailController.model = model;
        partDetailController.style = style;
        detailController = partDetailController;
        partDetailController = nil;
        [partDetailController release];
        
        UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:lookupController, detailController, nil];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *part = [partList objectAtIndex:indexPath.row];
    
    UIViewController *detailController = nil;
        
    PartDetailController *partDetailController = [[PartDetailController alloc] init];
    partDetailController.part = part;
    partDetailController.year = year;
    partDetailController.make = make;
    partDetailController.model = model;
    partDetailController.style = style;
    detailController = partDetailController;
    partDetailController = nil;
    [partDetailController release];
    
    UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];
    
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:lookupController, detailController, nil];
}

- (UIColor *) colorWithHexString: (NSString *) hex  
{  
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
    
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor grayColor];  
    
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
    
    if ([cString length] != 6) return  [UIColor grayColor];  
    
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
    
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
    
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
    
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
} 

@end

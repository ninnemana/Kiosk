//
//  StyleViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "StyleViewController.h"
#import "ModelViewController.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "PartViewController.h"
#import "JSONKit.h"
#import "NSString_Encode.h"

@implementation StyleViewController
@synthesize detailViewController;
@synthesize mount, year, make, model;

NSMutableArray *styleList;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)dealloc
{
    [detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    styleList = [[NSMutableArray alloc] init];
    
    // Create our string from vehicle data
    NSString *style_query = [NSString stringWithFormat:@"http://api.curtmfg.com/v2/getstyle?dataType=JSON&mount=%@&year=%@&make=%@&model=%@",
                             [mount encodeString:NSUTF8StringEncoding],
                             [year encodeString:NSUTF8StringEncoding],
                             [make encodeString:NSUTF8StringEncoding],
                             [model encodeString:NSUTF8StringEncoding]];
    
    // Comple URL
    NSError *err = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *styleURL = [NSURL URLWithString:style_query];
    
    // Make the request to CURT API
    [request setURL:styleURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    // Parse out the response
    NSData *style_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if(err){
        [self showAlert:@"Failed to find styles for your vehicle."];
    }else{
        NSMutableArray *results = [style_data objectFromJSONData];
        
        // Loop through the objects 
        int i;
        for(i = 0; i < [results count]; i++){
            NSString *style = (NSString *)[results objectAtIndex:i];
            [styleList addObject:style];
        }
        
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [self colorWithHexString:@"ff581c"];
        label.text = @"Select Style";
        self.navigationItem.titleView = label;
        [label sizeToFit];
    }
    
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [styleList count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    tableView.separatorColor = [self colorWithHexString:@"dddddd"];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
    }
    
    // Configure the cell.
    
    // Set the cell's text to be the style at index of indexPath.row
    NSString *style = (NSString *)[styleList objectAtIndex:indexPath.row];
    NSString *formatted_style = [NSString stringWithFormat:@"%@",style];
    cell.textLabel.text = formatted_style;
    
    // Style the cell's background color to be black and text color to be orange
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [self colorWithHexString:@"ff581c"];
    
    // We need to set  the styles for the selected cell
    
    // Create new UIView
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[self colorWithHexString:@"ff581c"]];
    
    // Create new UILabel
    UILabel *selectedCell = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
    [selectedCell setTextColor:[self colorWithHexString:@"343434"]];
    [selectedCell setBackgroundColor:[self colorWithHexString:@"ff581c"]];
    
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
    NSString *vehicle_style = selectedCell.textLabel.text;
    
    // Gain reference to the next level and push the view to it
    PartViewController *partsViewController = [[PartViewController alloc]init];
    partsViewController.mount = mount;
    partsViewController.year = year;
    partsViewController.make = make;
    partsViewController.model = model;
    partsViewController.style = vehicle_style;
    [self.navigationController pushViewController:partsViewController animated:YES];
    
    // Style the back button in our navigation bar to display year
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Style" style:UIBarButtonItemStylePlain target:nil action:nil];
    [backButton setTintColor:[self colorWithHexString:@"343434"]];
    self.navigationItem.backBarButtonItem = backButton;
    
    [backButton release];
    [partsViewController release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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

@end

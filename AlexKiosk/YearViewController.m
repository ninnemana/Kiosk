//
//  YearViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import "YearViewController.h"
#import "MakeViewController.h"
#import "ModelViewController.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "NSString_Encode.h"
#import "JSONKit.h"

@interface YearViewController ()

@end

@implementation YearViewController
@synthesize detailViewController;
@synthesize mount;
@synthesize yearTableView;

NSMutableArray *yearList;

- (void) dealloc{
    [detailViewController release];
    [super dealloc];
}

-(void) didReceiveMemoryWarning{
    /// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Releases any cached data, images, etc that aren't in use.
}

#pragma mark - View Lifecycle
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad{
    
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    yearList = [[NSMutableArray alloc] init];
    NSString *year_query = [NSString stringWithFormat:@"http://api.curtmfg.com/v2/getyear?mount=%@&dataType=JSON", 
                            [mount encodeString:NSUTF8StringEncoding]];
    
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL* yearURL = [NSURL URLWithString:year_query];
    
    [request setURL:yearURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData* year_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if(err){
        [self showAlert:@"Failed to find years for your chosen mount."];
    }else{
        NSMutableArray *results = [year_data objectFromJSONData];
        int i;
        for(i = 0; i < [results count]; i++){
            NSString *year = (NSString*)[results objectAtIndex:i];
            [yearList addObject:year];
        }
        
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [self colorWithHexString:@"ff581c"];
        self.navigationItem.titleView = label;
        label.text = @"Select Year";
        [label sizeToFit];
    }
    
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [yearList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    tableView.separatorColor = [self colorWithHexString:@"dddddd"];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    // Set the cell's text to be the year at index of indexPath.row
    NSString *year = (NSString *)[yearList objectAtIndex:indexPath.row];
    NSString *formatted_year = [NSString stringWithFormat:@"%@",year];
    cell.textLabel.text = formatted_year;
    
    // Style the cell's background color to be black and text color to be orange
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [self colorWithHexString:@"ff581c"];
    
    // We need to set  the styles for the selected cell
    
    // Create new UIView
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[self colorWithHexString:@"ff581c"]];
    
    // Create new UILabel
    UILabel *selectedCell = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the vehicle year
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *vehicle_year = selectedCell.textLabel.text;
    
    // Gain reference to the next level and push the view to it
    MakeViewController *makeViewController = [[MakeViewController alloc]init];
    makeViewController.mount = mount;
    makeViewController.year = vehicle_year;
    [self.navigationController pushViewController:makeViewController animated:YES];
    
    // Style the back button in our navigation bar to display year
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Year" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [backButton release];
    [makeViewController release];
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

//
//  RootViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "PartDetailController.h"
#import "YearViewController.h"
#import "JSONKit.h"

@implementation RootViewController
@synthesize detailViewController, hideBackButton, mountTableView;

NSMutableArray *mountList;

- (void)viewDidLoad
{
    
    if(hideBackButton){
        [self.navigationItem setHidesBackButton:YES animated:YES];
    }else{
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
    
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [self colorWithHexString:@"ff581c"];
    label.text = @"Select Mount";
    [label sizeToFit];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.titleView = label;
    
    mountList = [[NSMutableArray alloc] init];
    NSArray *mounts = [[NSArray alloc] initWithObjects:@"Front Mount",@"Rear Mount", nil];
    [mountList addObjectsFromArray:mounts];
    [mounts release];
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mountList count];
    		
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = [self colorWithHexString:@"343434"];
    tableView.separatorColor = [self colorWithHexString:@"dddddd"];
    tableView.backgroundView.hidden = YES;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    // Set the cell's text to be the year at index of indexPath.row
    NSString *mount = (NSString *)[mountList objectAtIndex:indexPath.row];
    NSString *formatted_mount = [NSString stringWithFormat:@"%@",mount];
    cell.textLabel.text = formatted_mount;
    
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
    
    // Variable release
    [bgColorView release];
    
    return cell;
}

-(IBAction)playMovie:(id)sender{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sema2011_CurtMfg" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    MPMoviePlayerController *mpController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.view addSubview:mpController.view];
    mpController.fullscreen = YES;
    [mpController play];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the vehicle year
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *vehicle_mount = selectedCell.textLabel.text;
    
    // Gain reference to the next level and push the view to it
    YearViewController *yearViewController = [[YearViewController alloc]init];
    yearViewController.mount = vehicle_mount;
    [self.navigationController pushViewController:yearViewController animated:YES];
    
    // Style the back button in our navigation bar to display year
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Mount" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [backButton release];
    [yearViewController release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [application setIdleTimerDisabled:YES];
    NSLog(@"didFinfishLaunching");
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"applicationWillTerminate");
}

- (void)dealloc
{
    [detailViewController release];
    [super dealloc];
}

@end

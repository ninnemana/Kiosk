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
#import "UIColorExtensions.h"

@implementation RootViewController
@synthesize detailViewController, hideBackButton, mountTableView;


- (void)dealloc
{
    [super dealloc];
}


- (void)viewDidLoad
{
    if (hideBackButton) {
        [self.navigationItem setHidesBackButton:YES animated:YES];
    } else {
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor fcext_colorWithHexString:@"ff581c"];
    label.text = @"Select Mount";
    [label sizeToFit];

    self.navigationItem.titleView = label;

    NSArray *mounts = [[NSArray alloc] initWithObjects:@"Front Mount", @"Rear Mount", nil];
    [items addObjectsFromArray:mounts];
    [mounts release];

    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setNavigationBarTintColor:[UIColor blackColor]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = [UIColor fcext_colorWithHexString:@"343434"];
    tableView.separatorColor = [UIColor fcext_colorWithHexString:@"dddddd"];
    tableView.backgroundView.hidden = YES;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    // Set the cell's text to be the year at index of indexPath.row
    NSString *mount = (NSString *)[items objectAtIndex:indexPath.row];
    NSString *formatted_mount = [NSString stringWithFormat:@"%@", mount];
    cell.textLabel.text = formatted_mount;
    
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
    
    // Variable release
    [bgColorView release];
    
    return cell;
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

@end
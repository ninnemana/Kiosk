//
//  DetailViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize detailDescriptionLabel=_detailDescriptionLabel;

@synthesize popoverController=_myPopoverController;

@synthesize partID;

UIImageView *imgView;
UIViewController *detail;
UIView *partDetailView;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    imgView.hidden = YES;

    UIView *detailView = [detail view];
    [detailView setBackgroundColor:[UIColor whiteColor]];

    //[detailView release];
    //self.detailDescriptionLabel.text = [self.detailItem description];
    //self.detailDescriptionLabel.text = @"CURT Hitch Finder";
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

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    detail = [self.splitViewController.viewControllers objectAtIndex:1];
    
    UIImage *atv = [UIImage imageNamed:@"ATV.jpg"];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 704, 768)];
    NSMutableArray * imageArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    [imageArray addObject:atv];
    [imageArray addObject:[UIImage imageNamed:@"Biker.jpg"]];
    [imageArray addObject:[UIImage imageNamed:@"Fish.jpg"]];
    [imageArray addObject:[UIImage imageNamed:@"Horse.jpg"]];
    imgView.animationImages = imageArray;
    [imageArray release];
    
    imgView.animationDuration = 20.0;
    imgView.animationRepeatCount = 0;
    [imgView startAnimating];
    
    [self.view addSubview:imgView];

    [super viewDidLoad];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    
    [super dealloc];
}

@end

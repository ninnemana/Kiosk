//
//  CartListController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/24/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import "CartListController.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "PartDetailController.h"
#import "KSDAppDelegate.h"
#import "KioskOrder.h"
#import "KioskOrderItem.h"
#import "JSONKit.h"
#import "NSString_Encode.h"
#import "UIColorExtensions.h"
#import "CartItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation CartListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    // We need to compile the total number of items and the total price
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSNumber *itemCount = [NSNumber numberWithInt:0];

    [scrollView setBackgroundColor:[UIColor fcext_colorWithHexString:@"d6d3d1"]];
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *cartItems = [NSArray arrayWithArray:[delegate.cartItems allValues]];
    int i;
    int starting_y = 125;
    for(i = 0; i < [cartItems count]; i++){
        UIView *view;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, starting_y, self.view.frame.size.width, 300)];
        starting_y += 300;

        CartItem *item = [cartItems objectAtIndex:i];
        NSDictionary *part = item.part;
        
        
        // Increment our item count;
        itemCount = [NSNumber numberWithInt:[itemCount intValue] + [item.quantity intValue]];
        
        // Add to our total price
        NSDecimalNumber *decQty = [NSDecimalNumber decimalNumberWithDecimal:[item.quantity decimalValue]];
        NSDecimalNumber *itemPrice = [NSDecimalNumber decimalNumberWithString:item.price];
        NSDecimalNumber *linePrice = [itemPrice decimalNumberByMultiplyingBy:decQty];
        totalPrice = [totalPrice decimalNumberByAdding:linePrice];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 450, 60)];
        label.text = [NSString stringWithFormat:@"%@",item.shortDesc];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor blackColor];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        [view addSubview:label];
        [label release];
        
        NSError *err = nil;
        NSURLResponse *resp = nil;
        NSMutableURLRequest *req = [[[NSMutableURLRequest alloc] init] autorelease];
        [req setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://docs.curthitch.biz/masterlibrary/%@/images/%@_300x225_a.jpg",[part objectForKey:@"partID"],[part objectForKey:@"partID"]]]];
        [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [req setTimeoutInterval:30];
        NSData *imgData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
        if(!err){
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, 150, 150)];
            [imgView setBackgroundColor:[UIColor whiteColor]];
            CALayer *imgLayer = [imgView layer];
            imgLayer.cornerRadius = 4.0;
            [imgView setImage:[UIImage imageWithData:imgData]];
            [view addSubview:imgView];
            [imgView release];
        }

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setGeneratesDecimalNumbers:TRUE];
        
        
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
        
        UILabel *itemPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 80, 500, 18)];
        itemPriceLabel.text = [NSString stringWithFormat:@"Item Price: $%@",[[itemPrice decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue]];
        itemPriceLabel.textColor = [UIColor blackColor];
        itemPriceLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:itemPriceLabel];
        [itemPriceLabel release];
        
        UILabel *qty = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 500, 18)];
        qty.text = [NSString stringWithFormat:@"Quantity: %@",item.quantity];
        qty.textColor = [UIColor blackColor];
        [qty setBackgroundColor:[UIColor clearColor]];
        [view addSubview:qty];
        [qty release];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(200, 120, 500, 18)];
        price.text = [NSString stringWithFormat:@"Line Price: $%@",[[linePrice decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue]];
        price.textColor = [UIColor blackColor];
        [price setBackgroundColor:[UIColor clearColor]];
        [view addSubview:price];
        [price release];
        
        [formatter release];

        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(500, 0, 1, 250)];
        border.backgroundColor = [UIColor fcext_colorWithHexString:@"efeeed"];
        [view addSubview:border];
        [border release];
        
        UIButton *detailsButton = [[UIButton alloc] initWithFrame:CGRectMake(540, 50, 115, 29)];
        [detailsButton setBackgroundImage:[UIImage imageNamed:@"details_button.png"] forState:UIControlStateNormal];
        [detailsButton setBackgroundImage:[UIImage imageNamed:@"details_button_down.png"] forState:UIControlEventTouchDown];
        [detailsButton setAccessibilityValue:[NSString stringWithFormat:@"%@",[part objectForKey:@"partID"]]];
        [detailsButton addTarget:self action:@selector(viewDetails:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:detailsButton];
        [detailsButton release];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(540, 120, 115, 29)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_button.png"] forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_button_down.png"] forState:UIControlEventTouchDown];
        [deleteButton setAccessibilityValue:[NSString stringWithFormat:@"%@",[part objectForKey:@"partID"]]];
        [deleteButton addTarget:self action:@selector(deleteCartItem:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteButton];
        [deleteButton release];
        

        UILabel *bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(5, 248, 490, 1)];
        [bottomBorder setBackgroundColor:[UIColor fcext_colorWithHexString:@"efeeed"]];
        [view addSubview:bottomBorder];
        [bottomBorder release];
        
        [scrollView addSubview:view];
        [view release];
    }
    
    /***** BUILD TOOLBAR ******/
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setTintColor:[UIColor whiteColor]];
    
    UILabel *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 44)];
    //toolbarLabel.text = [NSString stringWithFormat:@"Your shopping cart contains %@ items for a total of $%@",itemCount,totalPrice];
    toolbarLabel.text = @"Shopping Cart";
    toolbarLabel.textAlignment = UITextAlignmentCenter;
    [toolbarLabel setBackgroundColor:[UIColor clearColor]];
    [toolbarLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [toolbarLabel setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
    [toolbarLabel setShadowColor:[UIColor fcext_colorWithHexString:@"262626"]];
    [toolbarLabel setShadowOffset:CGSizeMake(0, -2.0)];
    UIBarButtonItem *toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:toolbarLabel];
    [toolbarLabel release];
    
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetApplication)];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:spacer, toolbarTitle, spacer2, resetButton, nil];
    [spacer release];
    [spacer2 release];
    [toolbarTitle release];
    [resetButton release];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar setItems:toolbarItems animated:YES];
    [scrollView addSubview:toolbar];
    [toolbar release];
    
    // BUILD top summary section
    UIView *topSection = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 704, 75)];
    UILabel *topSectionBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, 704, 1)];
    [topSectionBorder setBackgroundColor:[UIColor fcext_colorWithHexString:@"efeeed"]];
    [topSection addSubview:topSectionBorder];
    [topSectionBorder release];
    
    UILabel *itemCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    itemCountLabel.text = [NSString stringWithFormat:@"Number of Items: %@",itemCount];
    [itemCountLabel setBackgroundColor:[UIColor clearColor]];
    [itemCountLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    itemCountLabel.textColor = [UIColor blackColor];
    [topSection addSubview:itemCountLabel];
    [itemCountLabel release];
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 300, 20)];
    totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: $%@",totalPrice];
    [totalPriceLabel setBackgroundColor:[UIColor clearColor]];
    [totalPriceLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    totalPriceLabel.textColor = [UIColor blackColor];
    [topSection addSubview:totalPriceLabel];
    [totalPriceLabel release];
    
    UIButton *checkout = [[UIButton alloc] initWithFrame:CGRectMake(475, 10, 200, 50)];
    [checkout setBackgroundImage:[UIImage imageNamed:@"checkout_button.png"] forState:UIControlStateNormal];
    [checkout setBackgroundImage:[UIImage imageNamed:@"checkout_button_down.png"] forState:UIControlEventTouchDown];
    [checkout addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
    [topSection addSubview:checkout];
    [checkout release];
    
    [scrollView addSubview:topSection];
    [topSection release];
    
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width,([cartItems count] * 425))];
    
    [self.view addSubview:scrollView];
    [scrollView release];
    
}

- (void) checkout:(id)sender{
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *cartItems = [NSMutableDictionary dictionaryWithDictionary:delegate.cartItems];
    if([cartItems count] > 0){
        NSMutableDictionary *order = [[NSMutableDictionary alloc] init];
        [order setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"customerID"] forKey:@"acctID"];
        NSMutableArray *orderItems = [[NSMutableArray alloc] init];
        for(CartItem *item in [cartItems allValues]){
            NSMutableDictionary *orderItem = [[NSMutableDictionary alloc] init];
            [orderItem setValue:item.partID forKey:@"partID"];
            [orderItem setValue:item.quantity forKey:@"qty"];
            [orderItem setValue:item.price forKey:@"price"];
            [orderItems addObject:orderItem];
            [orderItem release];
        }
        [order setValue:orderItems forKey:@"OrderItems"];
        [orderItems release];
        NSString *jsonOrder = [NSString stringWithFormat:@"%@",[order JSONString]];
        [order release];
        
        NSString *query = [NSString stringWithFormat:@"http://koc.curthitch.biz/KioskOrder/Index?json=%@",[jsonOrder encodeString:NSUTF8StringEncoding]];
        
        NSError *err = nil;
        NSURLResponse *resp = nil;
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
        NSURL *orderURL = [NSURL URLWithString:query];
        
        [req setURL:orderURL];
        [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [req setTimeoutInterval:30];
        
        NSData *order_data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
        [req release];
        if(err){
            [self showAlert:@"Failed to submit the order. Please contact a sales associate at the service desk."];
        }else{
            NSDictionary *order_response = [[JSONDecoder decoder] objectWithData:order_data];
            if([order_response objectForKey:@"error"] != (id)[NSNull null] && [[order_response objectForKey:@"error"] length] > 0){
                [self showAlert:@"Failed to submit the order. Please contact a sale associate at the service desk."];
            }else{
                [self showSuccess:[NSString stringWithFormat:@"Order #%@ was submitted. Please contact a sales associate at the checkout counter to fulfill the rest of the order.",[order_response objectForKey:@"orderID"]]];
            }
        }
    }
    
}

- (void) viewDetails:(id)sender{
    
    UIButton *btn = sender;
    NSString *partID = [btn accessibilityValue];
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSArray *items = [delegate.cartItems allValues];
    NSDictionary *part = nil;
    int i;
    for(i = 0; i < [items count]; i++){
        CartItem *ci = [items objectAtIndex:i];
        if([ci.partID isEqualToString:partID]){
            part = ci.part;
        }
    }

	if (!part)
		part = [NSDictionary dictionary];

    UIViewController *detailController = nil;
    
    PartDetailController *partDetailController = [[PartDetailController alloc] init];
    partDetailController.part = part;
    
    
    partDetailController.year = @"";
    partDetailController.make = @"";
    partDetailController.model = @"";
    partDetailController.style = @"";
    detailController = partDetailController;
//    [partDetailController release];

    self.splitViewController.viewControllers = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], detailController, nil];
    [partDetailController release];
}

- (void)deleteCartItem:(id)sender{
    UIButton *btn = sender; 
    NSString *partID = [btn accessibilityValue];
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *cartItems = [[NSMutableDictionary alloc] initWithDictionary:delegate.cartItems];
    NSArray *items = [cartItems allValues];
    NSMutableDictionary *remainingItems = [[NSMutableDictionary alloc] init];
    int i;
    for(i = 0; i < [items count]; i++){
        CartItem *item = [items objectAtIndex:i];
        if(![item.partID isEqualToString:partID]){
            [remainingItems setObject:item forKey:item.partID];
        }
    }
    delegate.cartItems = [[[NSMutableDictionary alloc] initWithDictionary:remainingItems] autorelease];
    [cartItems release];
    [remainingItems release];
    
    CartListController *cartController = [[CartListController alloc] init];
    UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];
    
    [self.navigationController pushViewController:lookupController animated:YES];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], cartController, nil];
	[cartController release];
}

- (void)resetApplication{
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.cartItems = nil;
    
    RootViewController *yearController = [[RootViewController alloc] init];
    DetailViewController *detailController = [[DetailViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:yearController];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:navController, detailController, nil];
    
    [yearController release];
    [detailController release];
    [navController release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

- (void) showAlert:(NSString*)msg
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


- (void) showSuccess:(NSString*)msg
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    [self resetApplication];
}

@end

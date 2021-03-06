//
//  PartDetailController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/12/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import "KSDAppDelegate.h"
#import "RootViewController.h"
#import "PartDetailController.h"
#import "DetailViewController.h"
#import "CartListController.h"
#import "AsyncImageView.h"
#import "JSONKit.h"
#import "NSString_Encode.h"
#import "UIColorExtensions.h"
#import "CartItem.h"
#import "FCPDFView.h"


@implementation PartDetailController

@synthesize part, mount, year, make, model, style, cartButtonVisible;

UITabBar *tabBar;
UIToolbar *toolbar;


- (void)backgroundLoadImages:(NSArray*)img_indexes
{
	NSMutableArray *resultMutable = [[NSMutableArray alloc] init];

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i=0; i<[img_indexes count]; i++)
	{
        NSError *imgErr = nil;
        NSURLResponse *imgResponse = nil;
        NSMutableURLRequest *imgRequest = [[NSMutableURLRequest alloc] init];

		NSString *partID = [self.part objectForKey:@"partID"];
		NSString *index = [img_indexes objectAtIndex:i];
		NSString *urlString = [NSString stringWithFormat:@"http://docs.curthitch.biz/masterlibrary/%@/images/%@_300x225_%@.jpg", partID, partID, index];
        [imgRequest setURL:[NSURL URLWithString:urlString]];
        [imgRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [imgRequest setTimeoutInterval:30];

        NSData *imgData = [NSURLConnection sendSynchronousRequest:imgRequest returningResponse:&imgResponse error:&imgErr];
		[imgRequest release];
        if (!imgErr)
		{
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)imgResponse;
            if ([resp statusCode] == 200)
			{
                UIImage *img = [[UIImage alloc] initWithData:imgData];
                [resultMutable addObject:img];
                [img release];
            }
        }
    }
	[pool release];

	NSArray *result = [[NSArray alloc] initWithArray:resultMutable];
	[resultMutable release];

	[self performSelectorOnMainThread:@selector(didLoadImages:) withObject:result waitUntilDone:YES];
	[result release];
}


- (void)didLoadImages:(NSArray*)images
{
	if ([images count] > 0)
	{
        // Create a frame for our main image
        CGRect frame;
        frame.size.width = 300; frame.size.height = 225;
        frame.origin.x = 350; frame.origin.y = 100;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        [imgView setBackgroundColor:[UIColor whiteColor]];
        CALayer *imgLayer = [imgView layer];
        [imgLayer setMasksToBounds:YES];
        [imgLayer setCornerRadius:6.0];
        [imgLayer setBorderWidth:2.0];
        [imgLayer setBorderColor:[[UIColor fcext_colorWithHexString:@"232323"] CGColor]];
        
        imgView.animationImages = images;
        imgView.animationDuration = 20.0;
        imgView.animationRepeatCount = 0;
        [imgView startAnimating];
        [scrollView addSubview:imgView];
        [imgView release];
    }
	[scrollView fcext_fade];
}


- (void)openPDF:(UIGestureRecognizer*)recognizer
{
	UILabel *piece = (UILabel*) recognizer.view;

	[FCPDFView showInView:self.view withUrl:[NSURL URLWithString:piece.text] withStartingRect:CGRectNull];
}


- (void)dealloc
{
	[part release];
	[mount release];
	[year release];
	[make release];
	[model release];
	[style release];

	[scrollView release];

	[super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    // Assign the view to be referenced by variable
	[scrollView release];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Set the background color of our view
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = scrollView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor fcext_colorWithHexString:@"BBB8B0"] CGColor], (id)[[UIColor fcext_colorWithHexString:@"ffffff"] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];*/
    [self.view setBackgroundColor:[UIColor fcext_colorWithHexString:@"dddddd"]];
    
    // Build our toolbar to display the vehicle information.
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 44)];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];

    NSMutableArray *toolbarItems = [[NSMutableArray alloc] initWithCapacity:6];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setTintColor:[UIColor whiteColor]];
    [toolbarItems addObject:spacer];
    [spacer release];
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *cartItems = delegate.cartItems;
    if([cartItems count] > 0){
        // Create the UILabel to contain the vehicle text.
        UILabel *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 44)];
        toolbarLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", mount, year, make, model, style];
        toolbarLabel.textAlignment = UITextAlignmentLeft;
        [toolbarLabel setBackgroundColor:[UIColor clearColor]];
        [toolbarLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [toolbarLabel setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
        [toolbarLabel setShadowColor:[UIColor fcext_colorWithHexString:@"262626"]];
        [toolbarLabel setShadowOffset:CGSizeMake(0, -2.0)];
        UIBarButtonItem *toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:toolbarLabel];
        [toolbarLabel release];
        [toolbarItems addObject:toolbarTitle];
        [toolbarTitle release];
        
        UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [toolbarItems addObject:spacer3];
        [spacer3 release];
        
        UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithTitle:@"View Cart" style:UIBarButtonItemStyleDone target:self action:@selector(viewCart)];
        [toolbarItems addObject:cartButton];
        [cartButton release];
        
        [self setCartButtonVisible:YES];
    }else{
        // Create the UILabel to contain the vehicle text.
        UILabel *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 620, 44)];
        toolbarLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", mount, year, make, model, style];
        toolbarLabel.textAlignment = UITextAlignmentLeft;
        [toolbarLabel setBackgroundColor:[UIColor clearColor]];
        [toolbarLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [toolbarLabel setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
        [toolbarLabel setShadowColor:[UIColor fcext_colorWithHexString:@"262626"]];
        [toolbarLabel setShadowOffset:CGSizeMake(0, -2.0)];
        UIBarButtonItem *toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:toolbarLabel];
        [toolbarLabel release];
        [toolbarItems addObject:toolbarTitle];
        [toolbarTitle release];
        
        [self setCartButtonVisible:NO];
    }
    //[cartItems release];

    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [toolbarItems addObject:spacer2];
    [spacer2 release];
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetApplication)];
    [toolbarItems addObject:resetButton];
    [resetButton release];
    
    [toolbar setItems:toolbarItems animated:YES];
    [toolbarItems release];
    
    //Add the UIToolbar to our view
    [scrollView addSubview:toolbar];
     
    // Display the short description for this part at the top of the view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 700, 45)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 700, 2)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [titleView addSubview:bottomLine];
    [bottomLine release];
    
    UILabel *shortDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 500, 40)];
    shortDesc.text = [self.part objectForKey:@"shortDesc"];
    shortDesc.font = [UIFont boldSystemFontOfSize:18.0];
    shortDesc.backgroundColor = [UIColor clearColor];
    [titleView addSubview:shortDesc];
    [shortDesc release];
    
    UILabel *partNum = [[ UILabel alloc] initWithFrame:CGRectMake(550, 5, 150, 40)];
    partNum.text = [NSString stringWithFormat:@"Part #%@",[self.part objectForKey:@"partID"]];
    partNum.backgroundColor = [UIColor clearColor];
    [titleView addSubview:partNum];
    [partNum release];
    
    [scrollView addSubview:titleView];
    [titleView release];

    NSMutableArray *img_indexes = [[NSMutableArray alloc] initWithCapacity:5];
    [img_indexes addObject:[NSString stringWithFormat:@"a"]];
    /*[img_indexes addObject:[NSString stringWithFormat:@"b"]];
    [img_indexes addObject:[NSString stringWithFormat:@"c"]];
    [img_indexes addObject:[NSString stringWithFormat:@"d"]];
    [img_indexes addObject:[NSString stringWithFormat:@"e"]];*/

	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[scrollView addSubview:activityIndicator];
	[activityIndicator fcext_setOrigin:CGPointMake(490.0f, 202.5f)];
	[activityIndicator startAnimating];
	[activityIndicator release];
	[self performSelectorInBackground:@selector(backgroundLoadImages:) withObject:img_indexes];

    // We need to retrieve the Customer ID from the plist
    NSString *custIDString = [[NSUserDefaults standardUserDefaults] stringForKey:@"customerID"];
    NSNumber *custID = [NSNumber numberWithInt:0];
    if ([custIDString length] > 0)
	{
        custID = [NSNumber numberWithInt:[custIDString intValue]];
    }
    
    if ([custID intValue] > 0)
	{
        // Create a label for the price
        UILabel *listPrice = [[[UILabel alloc] initWithFrame:CGRectMake(20, 110, 150, 50)]autorelease];
        listPrice.text = [NSString stringWithFormat:@"%@",[self.part objectForKey:@"listPrice"]];
        listPrice.font = [UIFont boldSystemFontOfSize:40.0];
        listPrice.textAlignment = UITextAlignmentCenter;
        listPrice.numberOfLines = 0;
        listPrice.lineBreakMode = UILineBreakModeWordWrap;
        [listPrice setBackgroundColor:[UIColor clearColor]];
        [listPrice setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
        [scrollView addSubview:listPrice];
        //[listPrice release];

        // Create our Buy Now button
        UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
        [buy setFrame:CGRectMake(20, 175, 150, 75)];
        [buy setTitle:@"Buy Now" forState:UIControlStateNormal];
        buy.titleLabel.font = [UIFont boldSystemFontOfSize:32];
        [buy setTitleColor:[UIColor fcext_colorWithHexString:@"ff581c"] forState:UIControlStateNormal];
        [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        buy.backgroundColor = [UIColor fcext_colorWithHexString:@"343434"];
        buy.layer.cornerRadius = 10.0f;
        [buy addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:buy];
    }
    
    UIView *attributes = [[UIView alloc] init];
    NSMutableArray *part_attributes = [NSMutableArray arrayWithArray:[self.part objectForKey:@"attributes"]];
    int label_y = 0;
    if(part_attributes != nil){
        for(int i = 0; i < [part_attributes count]; i++){
            NSDictionary *part_attr = [[NSDictionary alloc] initWithDictionary:[part_attributes objectAtIndex:i]];
            
            UILabel *attr = [[UILabel alloc] initWithFrame:CGRectMake(20, label_y, 300, 35)];
            attr.numberOfLines = 0;
            attr.lineBreakMode = UILineBreakModeWordWrap;
            attr.layer.cornerRadius = 4;
            [attr setBackgroundColor:[UIColor clearColor]];
            
            UILabel *key_padding = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 35)];
            UILabel *key = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 115, 35)];
            key.text = [NSString stringWithFormat:@"%@",[part_attr objectForKey:@"key"]];
            [key_padding setBackgroundColor:[UIColor fcext_colorWithHexString:@"343434"]];
            [key setBackgroundColor:[UIColor clearColor]];
            key.textColor = [UIColor fcext_colorWithHexString:@"ff581c"];
            key.font = [UIFont boldSystemFontOfSize:12];
            [key_padding addSubview:key];
            [attr addSubview:key_padding];
            [key release];
            [key_padding release];
            
            UILabel *value_padding = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 175, 35)];
            UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 165, 35)];
            value.text = [NSString stringWithFormat:@"%@",[part_attr objectForKey:@"value"]];
            [value_padding setBackgroundColor:[UIColor whiteColor]];
            value_padding.textColor = [UIColor blackColor];
            [value_padding addSubview:value];
            [attr addSubview:value_padding];
            [value release];
            [value_padding release];
            
            [attributes addSubview:attr];
            [attr release];
            [part_attr release];
            
            label_y += 40;
        }
    }
    attributes.frame = CGRectMake(0, 350, 400, label_y);
    [scrollView addSubview:attributes];
    [attributes release];
    
    // Parse out the content pieces
    UIView *contentView = [[UIView alloc] init];
    int content_height = 0;
    
    NSMutableArray *content_pieces = [NSMutableArray arrayWithArray:[self.part objectForKey:@"content"]];
    if(content_pieces != nil){
        for(int i = 0; i < [content_pieces count]; i++){
            NSDictionary *content = [NSDictionary dictionaryWithDictionary:[content_pieces objectAtIndex:i]];

            UILabel *piece = [[UILabel alloc] init];
            piece.numberOfLines = 0;
            piece.lineBreakMode = UILineBreakModeWordWrap;
            [piece setBackgroundColor:[UIColor clearColor]];
            piece.text = [NSString stringWithFormat:@"%@", [content objectForKey:@"value"]];
            piece.font = [UIFont systemFontOfSize:16];

			if ((([piece.text rangeOfString:@"http://"].location == 0) || ([piece.text rangeOfString:@"https://"].location == 0)) && ([piece.text rangeOfString:@".pdf" options:NSCaseInsensitiveSearch].location == ([piece.text length] - 4)))
			{
				piece.userInteractionEnabled = YES;
				piece.textColor = [UIColor blueColor];
				[piece fcext_addTapRecognizerWithTarget:self withAction:@selector(openPDF:)];
			}

            CGSize expectedSize = [[NSString stringWithFormat:@"%@", [content objectForKey:@"value"]] sizeWithFont:piece.font constrainedToSize:CGSizeMake(350, 9999) lineBreakMode:UILineBreakModeWordWrap];

            piece.frame = CGRectMake(0, content_height, 350, expectedSize.height);

            [contentView addSubview:piece];
            [piece release];
            content_height = content_height + expectedSize.height + 20;
        }
    }
    contentView.frame = CGRectMake(350, 350, 375, content_height);
    [scrollView addSubview:contentView];
    [contentView release];

    // Check if this part has a related part count
    //NSNumber *relatedCount = (NSNumber *)[part objectForKey:@"relatedCount"];
    //if(relatedCount > 0){
        // We ndeed to retrieve the Customer ID from the plist
        /*NSString *custIDString = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"customerID"]]];
        NSNumber *custID = [[NSNumber alloc] initWithInt:0];
        if([custIDString length] > 0){
            custID = (NSNumber *)custIDString;
        }
        
        NSString *related_query = [NSString stringWithFormat:@"http://docs.curthitch.biz/api/getrelatedparts?dataType=JSON&partID=%@&cust_id=%@",[part objectForKey:@"partID"],custID];
        NSError *err = nil;
        NSURLResponse *resp = nil;
        NSMutableURLRequest *req = [[[NSMutableURLRequest alloc] init] autorelease];
        NSURL *relatedURL = [NSURL URLWithString:related_query];
        
        [req setURL:relatedURL];
        [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [req setTimeoutInterval:30];
        
        NSData *part_data = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
        if(!err){
            NSArray *parts = [[JSONDecoder decoder] objectWithData:part_data];
        }*/
        
        /*tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 400, view.frame.size.width, 100)];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithCapacity:2];
        UITabBarItem *hitchButton = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"hitches-30.png"] tag:0];

        [tabBarItems addObject:hitchButton];
        [hitchButton release];
        
        UITabBarItem *relatedButton = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"accessories-30.png"] tag:1];
        [tabBarItems addObject:relatedButton];
        [relatedButton release];
        
        [tabBar setItems:tabBarItems animated:YES];
        [tabBarItems release];
        
        tabBar.delegate = self;
        [view addSubview:tabBar];
        //[tabBar release];
    }*/

    if(content_height > label_y)
	{
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, content_height);
    } else
	{
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, label_y);
    }
    [self.view addSubview:scrollView];
}


- (void)addToCart
{
    NSNumber* partID;
    partID = (NSNumber*)[self.part objectForKey:@"partID"];
    
    NSString* shortDesc = [self.part objectForKey:@"shortDesc"];
    
    NSString *unformattedPrice = [[NSString alloc] initWithString:[self.part objectForKey:@"listPrice"]];
    NSString *formattedPrice = [unformattedPrice stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSDecimalNumber* price = [NSDecimalNumber decimalNumberWithString:formattedPrice];
    [unformattedPrice release];
    
    CartItem *item = [[CartItem alloc] init];
    item.partID = [NSString stringWithFormat:@"%@",partID];
    item.shortDesc = shortDesc;
    item.price = formattedPrice;
    item.quantity = [NSNumber numberWithInt:1];
    item.part = part;
    
    /*[shortDesc release];
    [price release];
    [quantity release];*/
    
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.cartItems != nil) {
        NSMutableDictionary *existingItems = [NSMutableDictionary dictionaryWithDictionary:delegate.cartItems];
        CartItem *existingItem = [existingItems objectForKey:(NSString*)partID];
        if(existingItem == nil) {
            [existingItems setValue:item forKey:(NSString*)partID];
            delegate.cartItems = [NSMutableDictionary dictionaryWithDictionary:existingItems];
        } else {
            NSNumber *numQty = (NSNumber*)existingItem.quantity;
            int intQty = [numQty intValue];
            numQty = [NSNumber numberWithInt:intQty + 1];
            existingItem.quantity = numQty;
        }
    } else {
        delegate.cartItems = [NSMutableDictionary dictionaryWithObject:item forKey:(NSString*)partID];
    }
    [item release];
    //[delegate.cartItems retain];
        
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Item Added" message:[NSString stringWithFormat:@"Successfully added Part #%@",partID] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    if (!cartButtonVisible)
	{
		// Add the ViewCart button to toolbar
        NSMutableArray *toolbarItems = [[NSMutableArray alloc] initWithCapacity:6];

        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [spacer setTintColor:[UIColor whiteColor]];
        [toolbarItems addObject:spacer];
        [spacer release];

        // Create the UILabel to contain the vehicle text.
        UILabel *toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 44)];
        toolbarLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", year, make, model, style];
        toolbarLabel.textAlignment = UITextAlignmentLeft;
        [toolbarLabel setBackgroundColor:[UIColor clearColor]];
        [toolbarLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [toolbarLabel setTextColor:[UIColor fcext_colorWithHexString:@"ff581c"]];
        [toolbarLabel setShadowColor:[UIColor fcext_colorWithHexString:@"262626"]];
        [toolbarLabel setShadowOffset:CGSizeMake(0, -2.0)];
        UIBarButtonItem *toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:toolbarLabel];
        [toolbarItems addObject:toolbarTitle];
        [toolbarTitle release];
        [toolbarLabel release];

        UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [toolbarItems addObject:spacer3];
        [spacer3 release];

        UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithTitle:@"View Cart" style:UIBarButtonItemStyleDone target:self action:@selector(viewCart)];
        [toolbarItems addObject:cartButton];
        [cartButton release];

        UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [toolbarItems addObject:spacer2];
        [spacer2 release];

        UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetApplication)];
        [toolbarItems addObject:resetButton];
        [resetButton release];

        [toolbar setItems:toolbarItems animated:YES];
        [toolbarItems release];

        [self setCartButtonVisible:NO];
    }
}


- (void)viewCart
{
    CartListController *cartController = [[CartListController alloc] init];
    UIViewController *lookupController = [self.splitViewController.viewControllers objectAtIndex:0];

    [self.navigationController pushViewController:lookupController animated:YES];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], cartController, nil];

	[cartController.view.superview fcext_fade];
    [cartController release];
}


- (void)resetApplication
{
    KSDAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.cartItems = nil;

    RootViewController *yearController = [[RootViewController alloc] init];
    DetailViewController *detailController = [[DetailViewController alloc] init];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:yearController];
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:navController, detailController, nil];

    [yearController release];
    [detailController release];
    [navController release];

	[delegate.mainWindow fcext_fade];
}

/*- (void) largeImageClick:(id)sender{
    UIButton *clickedImage = (UIButton *)sender;
    UIImage *img = [clickedImage imageForState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 768, 576);
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.contentMode = UIViewContentModeScaleAspectFit;
    [viewController setContentSizeForViewInPopover:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePopup)];
    
    [viewController addSubview:imageView];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:navController];
    [popController setPopoverContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    
    [popController presentPopoverFromRect:CGRectMake(10, 150, imageView.frame.size.width, imageView.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}*/


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
#import "BaseLeftViewController.h"
#import "NSString_Encode.h"
#import "JSONKit.h"


@interface BaseLeftViewController ()

@end

@implementation BaseLeftViewController

@synthesize detailViewController;

@synthesize items;


- (void) dealloc
{
    [detailViewController release];

	[items release];

	[activityIndicator release];

    [super dealloc];
}


- (id)init
{
	self = [super init];
	items = [[NSMutableArray alloc] init];
	return self;
}


- (id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	items = [[NSMutableArray alloc] init];
	return self;
}


- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.view addSubview:activityIndicator];
	activityIndicator.hidesWhenStopped = YES;
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

	[activityIndicator fcext_centerInSuperview];
	if (![items count])
		[self loadItems];
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


- (void)setNavigationBarTintColor:(UIColor*)color
{
	if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
		[self.navigationController.navigationBar setBarTintColor:color];
	else
		[self.navigationController.navigationBar setTintColor:color];
}


- (void)loadItems
{
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *item = (NSString *)[items objectAtIndex:indexPath.row];
	if ([item isKindOfClass:[NSNumber class]])
		item = [(NSNumber*)item stringValue];
	if (![item isKindOfClass:[NSString class]])
		return 40.0f;
	CGFloat contentHeight = [item sizeWithFont:[UIFont boldSystemFontOfSize:20.0] constrainedToSize:CGSizeMake(300.0f, 20000.0f)
								 lineBreakMode:UILineBreakModeWordWrap].height + 10.0f + 10.0f;
	contentHeight = MAX(40.0f, contentHeight);
	return contentHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
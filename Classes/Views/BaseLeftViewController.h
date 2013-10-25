#import "UIViewExtensions.h"

@class DetailViewController;

@interface BaseLeftViewController : UITableViewController
{
	NSMutableArray	*items;

	UIActivityIndicatorView	*activityIndicator;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray	*items;


- (void)setNavigationBarTintColor:(UIColor*)color;

- (void)loadItems;


@end

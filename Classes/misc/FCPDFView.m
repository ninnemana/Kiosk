#import "FCPDFView.h"

#import "UIViewExtensions.h"


@interface FCPDFView ()
@property (nonatomic, readonly) UIWebView	*webView;
@end


@interface FCPDFView (PrivateMethods)

- (void)closeButtonTouched;

@end


@implementation FCPDFView

@synthesize webView;


#pragma mark Private methods


- (void)closeButtonTouched
{
	[webView stopLoading];

	UIView* superview = self.superview;
	[self removeFromSuperview];
	[superview fcext_fade];
}


#pragma mark Public methods


- (void)dealloc
{
	[webView release];

	[activityIndicator release];

	[super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self != nil)
	{
		self.backgroundColor = [UIColor darkGrayColor];
		self.clipsToBounds = YES;

		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicator.hidesWhenStopped = YES;
		[self addSubview:activityIndicator];
		[activityIndicator fcext_centerInSuperview];

		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		webView.delegate = (id)self;
		[webView setScalesPageToFit:YES];
//		webView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:webView];
		webView.hidden = YES;

		UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		closeButton.frame = CGRectMake(frame.size.width - 50.0f, 20.0f, 30.0f, 30.0f);
		[closeButton setImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closeButtonTouched) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeButton];
//		[self addTarget:self action:@selector(webViewTouched) forControlEvents:UIControlEventTouchUpInside];
	}

	return self;
}


+ (void)showInView:(UIView*)view withUrl:(NSURL*)url withStartingRect:(CGRect)origin
{
	FCPDFView* pdfView = [[FCPDFView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];

	[pdfView.webView loadRequest:[NSURLRequest requestWithURL:url]];

	[view addSubview:pdfView];
	[pdfView release];

	[view fcext_fade];
//	[pdfView fcext_size:0.3f from:origin to:pdfView.frame];
}


#pragma mark UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView*)aWebView
{
	[activityIndicator startAnimating];
	[activityIndicator fcext_fade];
}


- (void)webViewDidFinishLoad:(UIWebView*)aWebView
{
	[activityIndicator stopAnimating];
	[activityIndicator fcext_fade];

	aWebView.hidden = NO;
	[aWebView fcext_fade];
}


- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
	NSString* msg = @"Failed to load the requested PDF. Please try again later.";
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];

	[self closeButtonTouched];
}


@end
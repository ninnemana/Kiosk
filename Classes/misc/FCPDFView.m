#import "FCPDFView.h"

#import "UIViewExtensions.h"


@interface FCPDFView ()
@property (nonatomic, readonly) UIWebView	*webView;
@end


@interface FCPDFView (PrivateMethods)

- (void)closeButtonTouched;

- (void)loadingTooLong;

@end


@implementation FCPDFView

@synthesize webView;


#pragma mark Private methods


- (void)closeButtonTouched
{
	if ([webView isLoading])
		[webView stopLoading];
	webView.delegate = nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	UIView* superview = self.superview;
	[self removeFromSuperview];
	[superview fcext_fade];
}


- (void)loadingTooLong
{
	[closeButton fcext_popIn:0.3f power:2.0f];

	[self performSelector:@selector(loadingTooLong) withObject:nil afterDelay:5.0f];
}


#pragma mark Public methods


- (void)dealloc
{
	if ([webView isLoading])
		[webView stopLoading];
	webView.delegate = nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[activityIndicator release];

	[webView release];
	[closeButton release];

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

		closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
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
	[pdfView autorelease];

	[view fcext_fade];
}


#pragma mark UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView*)aWebView
{
	[self retain];

	[activityIndicator startAnimating];
	[activityIndicator fcext_fade];

	[self performSelector:@selector(loadingTooLong) withObject:nil afterDelay:4.0f];
}


- (void)webViewDidFinishLoad:(UIWebView*)aWebView
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	[activityIndicator stopAnimating];
	[activityIndicator fcext_fade];

	aWebView.hidden = NO;
	[aWebView fcext_fade];

	[self release];
}


- (void)webView:(UIWebView*)aWebView didFailLoadWithError:(NSError*)error
{
	if (self.superview)
	{
		NSString* msg = @"Failed to load the requested PDF. Please try again later.";
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}

	[self closeButtonTouched];

	[self release];
}


@end
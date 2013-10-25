@interface FCPDFView : UIControl
{
	UIActivityIndicatorView	*activityIndicator;
	UIWebView	*webView;
}


+ (void)showInView:(UIView*)view withUrl:(NSURL*)url withStartingRect:(CGRect)origin;


@end
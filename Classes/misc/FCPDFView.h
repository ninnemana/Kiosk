@interface FCPDFView : UIControl
{
	UIActivityIndicatorView	*activityIndicator;
	UIWebView	*webView;
	UIButton	*closeButton;
}


+ (void)showInView:(UIView*)view withUrl:(NSURL*)url withStartingRect:(CGRect)origin;


@end
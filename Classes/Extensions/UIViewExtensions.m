#import "UIViewExtensions.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIView (fcext)


- (void)fcext_size:(float)duration from:(CGRect)from to:(CGRect)to withDelegate:(id)delegate
{
	CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	moveAnimation.duration = duration;
	CGPoint fromPoint = CGPointMake(from.origin.x+from.size.width/2, from.origin.y+from.size.height/2);
	CGPoint toPoint = CGPointMake(to.origin.x+to.size.width/2, to.origin.y+to.size.height/2);
	moveAnimation.fromValue = [NSValue value:&fromPoint withObjCType:@encode(CGPoint)];
	moveAnimation.toValue = [NSValue value:&toPoint withObjCType:@encode(CGPoint)];

	CABasicAnimation *sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
	sizeAnimation.duration = duration;
	sizeAnimation.fromValue = [NSValue value:&from.size withObjCType:@encode(CGPoint)];
	sizeAnimation.toValue = [NSValue value:&to.size withObjCType:@encode(CGPoint)];

	self.frame = to;

	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = [NSArray arrayWithObjects:moveAnimation, sizeAnimation, nil];
	animationGroup.duration = duration;
	animationGroup.delegate = delegate;

	[self.layer addAnimation:animationGroup forKey:@"fcext_size"];
}


- (void)fcext_size:(float)duration from:(CGRect)from to:(CGRect)to
{
	[self fcext_size:duration from:from to:to withDelegate:nil];
}


#pragma mark fade

- (void)fcext_fade:(float)duration
{
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	animation.duration = duration;
	[[self layer] addAnimation:animation forKey:@"fcext_fade"];
}


- (void)fcext_fade
{
	[self fcext_fade:0.3f];
}


#pragma mark pop


- (void)fcext_popIn:(float)duration
{
	CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	scale.duration = duration;
	scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.3f],
					[NSNumber numberWithFloat:0.85f], [NSNumber numberWithFloat:1.0f], nil];

	CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeIn.duration = duration * 0.4f;
	fadeIn.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeIn.toValue = [NSNumber numberWithFloat:1.0f];
	fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	fadeIn.fillMode = kCAFillModeForwards;

	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:scale, fadeIn, nil];

	[self.layer addAnimation:group forKey:@"fcext_popIn"];
}


- (void)fcext_popIn
{
	[self fcext_popIn:0.3f];
}


#pragma mark moveIn


- (void)fcext_moveInFrom:(NSString*)direction withDuration:(float)duration
{
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionMoveIn];
	[animation setSubtype:direction];
	animation.duration = duration;
	[[self layer] addAnimation:animation forKey:@"fcext_moveIn"];
}


- (void)fcext_moveInFromTop:(float)duration
{
	[self fcext_moveInFrom:kCATransitionFromBottom withDuration:duration];
}


- (void)fcext_moveInFromBottom:(float)duration
{
	[self fcext_moveInFrom:kCATransitionFromTop withDuration:duration];
}


- (void)fcext_moveInFromLeft:(float)duration
{
	[self fcext_moveInFrom:kCATransitionFromLeft withDuration:duration];
}


- (void)fcext_moveInFromRight:(float)duration
{
	[self fcext_moveInFrom:kCATransitionFromRight withDuration:duration];
}


- (void)fcext_moveInFromTop
{
	[self fcext_moveInFromTop:0.3f];
}


- (void)fcext_moveInFromBottom
{
	[self fcext_moveInFromBottom:0.3f];
}


- (void)fcext_moveInFromLeft
{
	[self fcext_moveInFromLeft:0.3f];
}


- (void)fcext_moveInFromRight
{
	[self fcext_moveInFromRight:0.3f];
}


#pragma mark reveal


- (void)fcext_revealFrom:(NSString*)direction withDuration:(float)duration
{
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionReveal];
	[animation setSubtype:direction];
	animation.duration = duration;
	[[self layer] addAnimation:animation forKey:@"fcext_reveal"];
}


- (void)fcext_revealFromTop:(float)duration
{
	[self fcext_revealFrom:kCATransitionFromBottom withDuration:duration];
}


- (void)fcext_revealFromBottom:(float)duration
{
	[self fcext_revealFrom:kCATransitionFromTop withDuration:duration];
}


- (void)fcext_revealFromLeft:(float)duration
{
	[self fcext_revealFrom:kCATransitionFromLeft withDuration:duration];
}


- (void)fcext_revealFromRight:(float)duration
{
	[self fcext_revealFrom:kCATransitionFromRight withDuration:duration];
}


- (void)fcext_revealFromTop
{
	[self fcext_revealFromTop:0.3f];
}


- (void)fcext_revealFromBottom
{
	[self fcext_revealFromBottom:0.3f];
}


- (void)fcext_revealFromLeft
{
	[self fcext_revealFromLeft:0.3f];
}


- (void)fcext_revealFromRight
{
	[self fcext_revealFromRight:0.3f];
}


#pragma mark push


- (void)fcext_pushFrom:(NSString*)direction withDuration:(float)duration
{
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:direction];
	animation.duration = duration;
	[[self layer] addAnimation:animation forKey:@"fcext_push"];
}


- (void)fcext_pushFromTop:(float)duration
{
	[self fcext_pushFrom:kCATransitionFromBottom withDuration:duration];
}


- (void)fcext_pushFromBottom:(float)duration
{
	[self fcext_pushFrom:kCATransitionFromTop withDuration:duration];
}


- (void)fcext_pushFromLeft:(float)duration
{
	[self fcext_pushFrom:kCATransitionFromLeft withDuration:duration];
}


- (void)fcext_pushFromRight:(float)duration
{
	[self fcext_pushFrom:kCATransitionFromRight withDuration:duration];
}


- (void)fcext_pushFromTop
{
	[self fcext_pushFromTop:0.3f];
}


- (void)fcext_pushFromBottom
{
	[self fcext_pushFromBottom:0.3f];
}


- (void)fcext_pushFromLeft
{
	[self fcext_pushFromLeft:0.3f];
}


- (void)fcext_pushFromRight
{
	[self fcext_pushFromRight:0.3f];
}


#pragma mark flip


- (void)fcext_flipFromLeft:(float)duration
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.superview cache:NO];
	[UIView commitAnimations];	
}


- (void)fcext_flipFromLeft
{
	[self fcext_flipFromLeft:0.5f];
}


- (void)fcext_flipFromRight:(float)duration
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.superview cache:NO];
	[UIView commitAnimations];	
}


- (void)fcext_flipFromRight
{
	[self fcext_flipFromRight:0.5f];
}


#pragma mark misc


- (void)fcext_setOrigin:(CGPoint)origin
{
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


- (void)fcext_setXOrigin:(CGFloat)xOrigin
{
	CGRect frame = self.frame;
	frame.origin.x = xOrigin;
	self.frame = frame;
}


- (void)fcext_setYOrigin:(CGFloat)yOrigin
{
	CGRect frame = self.frame;
	frame.origin.y = yOrigin;
	self.frame = frame;
}


- (void)fcext_alignCenterWithView:(UIView*)view
{
	CGRect frame = self.frame;
	CGRect otherFrame = view.frame;
	frame.origin.x = otherFrame.origin.x + (otherFrame.size.width - frame.size.width)/2.0f;
	frame.origin.y = otherFrame.origin.y + (otherFrame.size.height - frame.size.height)/2.0f;
	self.frame = frame;
}


- (void)fcext_alignCenterXWithView:(UIView*)view
{
	CGRect frame = self.frame;
	CGRect otherFrame = view.frame;
	frame.origin.x = otherFrame.origin.x + (otherFrame.size.width - frame.size.width)/2.0f;
	self.frame = frame;
}


- (void)fcext_centerInSuperview
{
	CGRect frame = self.frame;
	CGRect superviewFrame = self.superview.frame;
	frame.origin.x = (superviewFrame.size.width - frame.size.width)/2.0f;
	frame.origin.y = (superviewFrame.size.height - frame.size.height)/2.0f;
	self.frame = frame;
}


- (void)fcext_setSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}


- (void)fcext_setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


- (void)fcext_setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


- (void)fcext_maskWithCornerRadius:(float)cornerRadius
{
	CALayer *layer = [self layer];
	[layer setCornerRadius:cornerRadius];
	[layer setMasksToBounds:YES];
	[layer setBorderWidth:1.0f];	
}


- (void)fcext_addBorderWithWidth:(float)width withColor:(UIColor*)color
{
	CALayer *layer = [self layer];
	[layer setBorderWidth:width];
	[layer setBorderColor:[color CGColor]];
}


- (void)fcext_addBorderWithColor:(UIColor*)color
{
	[self fcext_addBorderWithWidth:1.0f withColor:color];
}


- (void)fcext_addBorder
{
	[self fcext_addBorderWithWidth:1.0f withColor:[UIColor greenColor]];
}


- (void)fcext_addTapRecognizerWithTarget:(id)target withAction:(SEL)action
{
	UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
	[self addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];
}


- (void)fcext_addSwipeRightRecognizerWithTarget:(id)target withAction:(SEL)action
{
	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:swipeRecognizer];
	[swipeRecognizer release];
}


- (void)fcext_removeAllGestureRecognizers
{
	NSArray *allGestureRecognizers = [self gestureRecognizers];
	for (UIGestureRecognizer *recognizer in allGestureRecognizers)
		[self removeGestureRecognizer:recognizer];
}


@end
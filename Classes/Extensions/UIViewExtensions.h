@interface UIView (fcext)

- (void)fcext_size:(float)duration from:(CGRect)from to:(CGRect)to withDelegate:(id)delegate;
- (void)fcext_size:(float)duration from:(CGRect)from to:(CGRect)to;

- (void)fcext_fade:(float)duration;
- (void)fcext_fade;

- (void)fcext_popIn:(float)duration power:(float)power;
- (void)fcext_popIn;

- (void)fcext_moveInFromTop:(float)duration;
- (void)fcext_moveInFromBottom:(float)duration;
- (void)fcext_moveInFromLeft:(float)duration;
- (void)fcext_moveInFromRight:(float)duration;
- (void)fcext_moveInFromTop;
- (void)fcext_moveInFromBottom;
- (void)fcext_moveInFromLeft;
- (void)fcext_moveInFromRight;

- (void)fcext_revealFromTop:(float)duration;
- (void)fcext_revealFromBottom:(float)duration;
- (void)fcext_revealFromLeft:(float)duration;
- (void)fcext_revealFromRight:(float)duration;
- (void)fcext_revealFromTop;
- (void)fcext_revealFromBottom;
- (void)fcext_revealFromLeft;
- (void)fcext_revealFromRight;

- (void)fcext_pushFromTop:(float)duration;
- (void)fcext_pushFromBottom:(float)duration;
- (void)fcext_pushFromLeft:(float)duration;
- (void)fcext_pushFromRight:(float)duration;
- (void)fcext_pushFromTop;
- (void)fcext_pushFromBottom;
- (void)fcext_pushFromLeft;
- (void)fcext_pushFromRight;

- (void)fcext_flipFromLeft:(float)duration;
- (void)fcext_flipFromLeft;
- (void)fcext_flipFromRight:(float)duration;
- (void)fcext_flipFromRight;

- (void)fcext_setOrigin:(CGPoint)origin;
- (void)fcext_setXOrigin:(CGFloat)xOrigin;
- (void)fcext_setYOrigin:(CGFloat)yOrigin;
- (void)fcext_alignCenterWithView:(UIView*)view;
- (void)fcext_alignCenterXWithView:(UIView*)view;
- (void)fcext_centerInSuperview;

- (void)fcext_setSize:(CGSize)size;
- (void)fcext_setWidth:(CGFloat)width;
- (void)fcext_setHeight:(CGFloat)height;
- (void)fcext_maskWithCornerRadius:(float)cornerRadius;

- (void)fcext_addBorderWithWidth:(float)width withColor:(UIColor*)color;
- (void)fcext_addBorderWithColor:(UIColor*)color; //defaults width to 1
- (void)fcext_addBorder; //defaults width to 1 and color to green

- (void)fcext_addTapRecognizerWithTarget:(id)target withAction:(SEL)action;
- (void)fcext_addSwipeRightRecognizerWithTarget:(id)target withAction:(SEL)action;
- (void)fcext_removeAllGestureRecognizers;

@end
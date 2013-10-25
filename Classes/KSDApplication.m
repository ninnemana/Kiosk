//
//  KSDApplication.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import "KSDApplication.h"
#import "KSDAppDelegate.h"
#import "VideoViewController.h"

NSString * const KSDIdlingWindowIdleNotification   = @"KSDIdlingWindowIdleNotification";
NSString * const KSDIdlingWindowActiveNotification = @"KSDIdlingWindowActiveNotification";

@interface KSDApplication (PrivateMethods)
- (void)windowIdleNotification;
- (void)windowActiveNotification;


@end

#define maxIdleTime 90000.0

@implementation KSDApplication
@synthesize idleTimer, idleTimeInterval;

#pragma mark activity timer

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    NSSet *allTouches = [event allTouches];
    //if ([allTouches count] > 0) {
        
        // To reduce timer resets only reset the timer on a Began or Ended touch.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
            [self resetIdleTimer];
        }
    //}
}

- (void)resetIdleTimer{
    if(idleTimer){
        [idleTimer invalidate];
        [idleTimer release];
    }
    idleTimer = [[NSTimer scheduledTimerWithTimeInterval:maxIdleTime target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO] retain];
}

- (void)idleTimerExceeded{
    NSLog(@"idle time exceeded");
    
    VideoViewController *videoController = [[VideoViewController alloc] initWithNibName:@"VideoView" bundle:nil];
    
    KSDAppDelegate *delegate = (KSDAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.splitViewController.view addSubview:videoController.view];
}

- (void)dealloc {
	if (self.idleTimer) {
		[self.idleTimer invalidate];
		self.idleTimer = nil;
	}
    [super dealloc];
}


@end

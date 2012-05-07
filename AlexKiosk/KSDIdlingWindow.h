//
//  KSDIdlingWindow.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

extern NSString * const KSDIdlingWindowIdleNotification;
extern NSString * const KSDIdlingWindowActiveNotification;

@interface KSDIdlingWindow : UIApplication {
	NSTimer *idleTimer;
	NSTimeInterval idleTimeInterval;
}

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (assign) NSTimeInterval idleTimeInterval;

@property (nonatomic, retain) NSTimer *idleTimer;

@end
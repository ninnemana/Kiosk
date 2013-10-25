//
//  AlexKioskAppDelegate.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDApplication.h"

@class RootViewController;

@class DetailViewController;

@interface KSDAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    NSMutableDictionary *cartItems;
}

@property (nonatomic, readonly) UIWindow *mainWindow;

@property (nonatomic, retain) IBOutlet KSDApplication *ksdApplication;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableDictionary *cartItems;

@end
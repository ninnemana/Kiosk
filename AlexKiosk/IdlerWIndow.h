//
//  IdlerWIndow.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const IdlerNotification;
extern NSString * const ActiveNotification;

@interface IdlerWindow : UIWindow{
    NSTimer *idleTimer;
    NSTimeInterval ideTimeInterval;
}

@property (assign) NSTimeInterval idleTimeInterval;
@property (nonatomic, retain) NSTimer *idleTimer;

@end
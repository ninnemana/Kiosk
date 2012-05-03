//
//  PartDetailController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/12/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartDetailController : UIViewController{
    NSDictionary *part;
    NSString *mount;
    NSString *year;
    NSString *make;
    NSString *model;
    NSString *style;
    BOOL cartButtonVisible;
}

@property (nonatomic, retain) NSDictionary *part;

@property (nonatomic, retain) NSString *mount;

@property (nonatomic, retain) NSString *year;

@property (nonatomic, retain) NSString *make;

@property (nonatomic, retain) NSString *model;

@property (nonatomic, retain) NSString *style;

@property BOOL cartButtonVisible;

@end

//
//  StyleViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "BaseLeftViewController.h"

@class DetailViewController;

@interface StyleViewController : BaseLeftViewController {
    NSString *mount;
    NSString *year;
    NSString *make;
    NSString *model;
}

@property (nonatomic, retain) IBOutlet UITableView *styleTableView;

@property (nonatomic, retain) NSString *mount;

@property (nonatomic, retain) NSString *year;

@property (nonatomic, retain) NSString *make;

@property (nonatomic, retain) NSString *model;

@end

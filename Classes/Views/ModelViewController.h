//
//  ModelViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "BaseLeftViewController.h"

@class DetailViewController;

@interface ModelViewController : BaseLeftViewController {
    NSString *mount;
    NSString *year;
    NSString *make;
}

@property (nonatomic, retain) IBOutlet UITableView *modelTableView;

@property (nonatomic, retain) NSString *mount;

@property (nonatomic, retain) NSString *year;

@property (nonatomic, retain) NSString *make;

@end

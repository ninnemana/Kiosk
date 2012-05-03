//
//  ModelViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface ModelViewController : UITableViewController {
    NSString *mount;
    NSString *year;
    NSString *make;
}

@property (nonatomic, retain) IBOutlet UITableView *modelTableView;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSString *mount;

@property (nonatomic, retain) NSString *year;

@property (nonatomic, retain) NSString *make;

@end

//
//  YearViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface YearViewController : UITableViewController{
    NSString *mount;
}

@property (nonatomic, retain) IBOutlet UITableView *yearTableView;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSString *mount;

@end

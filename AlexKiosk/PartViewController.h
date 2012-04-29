//
//  PartViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/11/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface PartViewController : UITableViewController{
    NSString *year;
    NSString *make;
    NSString *model;
    NSString *style;
}

@property (nonatomic,retain) IBOutlet UITableView *partTableView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *make;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *style;

@end

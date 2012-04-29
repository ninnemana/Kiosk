//
//  MakeViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;


@interface MakeViewController : UITableViewController {
    NSString *year;
}
@property (nonatomic, retain) IBOutlet UITableView *makeTableView;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSString *year;

@end

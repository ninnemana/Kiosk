//
//  PartViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/11/11.
//  Copyright (c) 2011 CURT Manufacturing. All rights reserved.
//

#import "BaseLeftViewController.h"

@class DetailViewController;

@interface PartViewController : BaseLeftViewController{
    NSString *mount;
    NSString *year;
    NSString *make;
    NSString *model;
    NSString *style;

	NSInteger selectedRow;
}

@property (nonatomic,retain) IBOutlet UITableView *partTableView;
@property (nonatomic, retain) NSString *mount;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *make;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *style;

@end

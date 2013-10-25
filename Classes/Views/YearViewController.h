//
//  YearViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/3/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import "BaseLeftViewController.h"

@class DetailViewController;

@interface YearViewController : BaseLeftViewController {
    NSString *mount;
}

@property (nonatomic, retain) IBOutlet UITableView *yearTableView;

@property (nonatomic, retain) NSString *mount;

@end

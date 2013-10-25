//
//  MakeViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import "BaseLeftViewController.h"

@class DetailViewController;


@interface MakeViewController : BaseLeftViewController {
    NSString *mount;
    NSString *year;
}
@property (nonatomic, retain) IBOutlet UITableView *makeTableView;

@property (nonatomic, retain) NSString *mount;

@property (nonatomic, retain) NSString *year;

@end

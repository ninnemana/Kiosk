//
//  RootViewController.h
//  AlexKiosk
//
//  Created by Alex Ninneman on 10/7/11.
//  Copyright 2011 CURT Manufacturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end

@class DetailViewController;

@interface RootViewController : UITableViewController {
    BOOL *hideBackButton;
}
@property (nonatomic, retain) IBOutlet UITableView *yearTableView;
		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, atomic) BOOL *hideBackButton;

@end

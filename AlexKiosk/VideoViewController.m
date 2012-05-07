//
//  VideoViewController.m
//  AlexKiosk
//
//  Created by Alex Ninneman on 5/4/12.
//  Copyright (c) 2012 CURT Manufacturing. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController


- (IBAction)playMovie:(id)sender{
//    UIButton *playButton = (UIButton *)sender;
    
    NSMutableArray *vidArray = [[[NSMutableArray alloc] initWithObjects:@"Company_Vision_HD", @"Detroit_HD", @"Distribution_HD", @"Electrical_HD", @"Engineering_HD", @"Fabrication_HD",@"Finishing_HD", @"First_to_Market_HD", @"Quality_HD", @"Welding_HD", @"Sema", nil] autorelease];
    
    NSUInteger randomIndex = arc4random() % [vidArray count];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[vidArray objectAtIndex:randomIndex] ofType:@"mp4" inDirectory:nil];
    
    //[vidArray release];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    MPMoviePlayerViewController *mpController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    //[filepath release];
    //[fileURL release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:[mpController moviePlayer]];
    
    [mpController.view setFrame:self.view.bounds];
    [self.view addSubview:mpController.view];
    
    MPMoviePlayerController *player = [mpController moviePlayer];
    player.shouldAutoplay = YES;
    player.controlStyle = MPMovieControlStyleNone;
    player.scalingMode = MPMovieScalingModeAspectFit;
    //player.repeatMode = MPMovieRepeatModeOne;
    [player play];
}

-(void)moviePlaybackComplete:(NSNotification *)notification{
    MPMoviePlayerController *mpController = [notification object];
    [mpController play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self playMovie:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end

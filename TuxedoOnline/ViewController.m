//
//  ViewController.m
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import "ViewController.h"
#import "ZDFragmentsImageView.h"
#import "DelaunayView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ZDFragmentsImageView *fragmentImageView;
@property (weak, nonatomic) IBOutlet DelaunayView *delaunaryView;
- (IBAction)breakTapped:(id)sender;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)breakTapped:(id)sender
{
    [_fragmentImageView createFragments];
    self.delaunaryView.triangulation = _fragmentImageView.triangulation;
    [self.delaunaryView setNeedsDisplay];
}
@end

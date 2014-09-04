//
//  ViewController.m
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import "ViewController.h"
#import "ZDFragmentsView.h"
#import "DelaunayView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ZDFragmentsView *fragmentImageView;
@property (weak, nonatomic) IBOutlet DelaunayView *delaunaryView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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
    [_fragmentImageView animateWithDuration: 0.5 animations:^{
    } completion:nil];
    self.imageView.image = nil;
    self.delaunaryView.triangulation = _fragmentImageView.triangulation;
    [self.delaunaryView setNeedsDisplay];
}
@end

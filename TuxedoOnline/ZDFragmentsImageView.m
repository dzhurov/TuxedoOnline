//
//  ZDFragmentsImageView.m
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import "ZDFragmentsImageView.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "VoronoiCell+GeometryAndImage.h"

@interface ZDFragmentsImageView ()
@property (nonatomic, strong) NSArray *fragmentsSublayers;
@end

@implementation ZDFragmentsImageView

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _numberOfVertex = 50;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

#pragma mark - Private

- (void)initTriangulation
{
    self.triangulation = [DelaunayTriangulation triangulationWithRect:self.bounds];
    
    for (int i = 0; i < _numberOfVertex; ++i) {
        CGPoint loc = CGPointMake(self.bounds.size.width * (arc4random() / (float)0x100000000),
                                  self.bounds.size.height * (arc4random() / (float)0x100000000));
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [self.triangulation addPoint:newPoint withColor:nil];
    }
}

- (void)splitByVoronoyCells
{
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];
    NSMutableArray *fragmentsSublayers = [NSMutableArray arrayWithCapacity:voronoiCells.count];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    int i = 0;
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        [cell restrictByFrame:self.bounds];
        CGRect cellFrame = CGRectZero;
        CGImageRef maskedImageRef = [cell maskedImage:image.CGImage cropedByFrame:&cellFrame];
        if ( !maskedImageRef )
            continue;
        NSLog(@"cellFrame: %@", NSStringFromCGRect(cellFrame));
            
        CALayer *sublayer = [CALayer layer];
//        CGRect layerFrame = cellFrame;
//        layerFrame.origin = CGPointMake(self.bounds.size.height - layerFrame.origin.x, layerFrame.origin.y);
        sublayer.frame = cellFrame;
        sublayer.backgroundColor = [UIColor clearColor].CGColor;
        sublayer.contents = (__bridge id)maskedImageRef;
        sublayer.borderColor = [UIColor magentaColor].CGColor;
        sublayer.borderWidth = 1.0;
        [self.layer addSublayer:sublayer];
        [fragmentsSublayers addObject:sublayer];
        i++;
    }
    self.image = nil;
}

#pragma mark - Public

- (void)createFragments
{
    [self initTriangulation];
    [self splitByVoronoyCells];
}


@end

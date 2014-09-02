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
    _numberOfVertex = 30;
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
    CGImageRef imageRef = self.image.CGImage;
    
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        CGRect cellFrame = CGRectZero;
        CGImageRef maskedImageRef = [cell maskedImage:imageRef cropedByFrame:&cellFrame];
        
        CALayer *sublayer = [CALayer layer];
        sublayer.frame = cellFrame;
        sublayer.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5].CGColor;
//        sublayer.contents = (__bridge id)maskedImageRef;
        sublayer.borderColor = [UIColor magentaColor].CGColor;
        sublayer.borderWidth = 1.0;
        [self.layer addSublayer:sublayer];
        [fragmentsSublayers addObject:sublayer];
        NSLog(@"cellFrame: %@", NSStringFromCGRect(cellFrame));
    }
}

#pragma mark - Public

- (void)createFragments
{
    [self initTriangulation];
    [self splitByVoronoyCells];
}


@end

//
//  ZDFragmentsImageView.m
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import "ZDFragmentsView.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "VoronoiCell+GeometryAndImage.h"

@interface ZDFragmentsView ()
@property (nonatomic, strong) NSArray *fragmentsSublayers;
@end

@implementation ZDFragmentsView

#pragma mark - Initialization

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
    _numberOfVertex = 20;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

#pragma mark - Private

- (void)initTriangulation
{
    self.triangulation = [DelaunayTriangulation triangulationWithRect:self.bounds];
    
    for (int i = 0; i < _numberOfVertex - 4; ++i) { // 4 angles of self rectangle bounds
        CGPoint loc = CGPointMake(self.bounds.size.width * (arc4random() / (float)0x100000000),
                                  self.bounds.size.height * (arc4random() / (float)0x100000000));
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [self.triangulation addPoint:newPoint withColor:nil];
    }
//    [self.triangulation addPoint:[DelaunayPoint pointAtX:3 andY:3] withColor:nil];
//    [self.triangulation addPoint:[DelaunayPoint pointAtX:3 andY:self.bounds.size.height - 3] withColor:nil];
//    [self.triangulation addPoint:[DelaunayPoint pointAtX:self.bounds.size.width - 3 andY:3] withColor:nil];
//    [self.triangulation addPoint:[DelaunayPoint pointAtX:self.bounds.size.width - 3 andY:self.bounds.size.height - 3] withColor:nil];
    
}

- (NSArray *)splitByVoronoyCells
{    
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];
    NSMutableArray *fragmentsSublayers = [NSMutableArray arrayWithCapacity:voronoiCells.count];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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
        [fragmentsSublayers addObject:sublayer];
    }
    return fragmentsSublayers;
}

#pragma mark - Public

- (void)createFragments
{
    [self initTriangulation];
}

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL))completion
{
    NSArray *startSubviewsHidden = [self.subviews valueForKey:@"hidden"];
    NSArray *startFragments = [self splitByVoronoyCells];
    for (CALayer *layer in startFragments) {
        [self.layer addSublayer:layer];
    }
    
    if (animations){
        animations();
        NSArray *endSubviewsHidden = [self.subviews valueForKey:@"hidden"];
        NSArray *endFragments = [self splitByVoronoyCells];
//        for (UIView *subview in self.subviews)
//            subview.hidden = YES;
        
        for (CALayer *layer in startFragments) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random() / (float)0x100000000) * duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGRect frame = layer.frame;
                frame.origin.x += 200;
                
                
                [CATransaction begin];
                [CATransaction setValue:@(duration /* (arc4random() / (float)0x100000000)*/) forKey:kCATransactionAnimationDuration];
                [CATransaction setCompletionBlock:^{
                    NSLog(@"COMPLETE : %f", CACurrentMediaTime());
                }];
                
                CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
                [myAnimation setToValue:[NSValue valueWithCGRect:frame]];
                [myAnimation setFromValue:[NSValue valueWithCGRect:layer.frame]];
                myAnimation.duration = 2;
                myAnimation.beginTime =CACurrentMediaTime() + 2; //(arc4random() / (float)0x100000000) * duration ;
                [myAnimation setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                
                [layer setFrame:frame];
                [layer addAnimation:myAnimation forKey:@"frameAnimation"];
                
                [CATransaction commit];
            });
        }
        
//        [UIView animateWithDuration:duration / 2 animations:^{ //animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//            // out animation
//            
////            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.9 animations:^{
//                UIView* view = self.subviews.firstObject;
//                CGRect frame = view.frame;
//                frame.origin.y += 500;
//                view.frame = frame;
////            }];
//            
//        } completion:^(BOOL finished) {
//            
//            [startFragments makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//            if (completion)
//                completion(finished);
//        }];
    }
}

@end

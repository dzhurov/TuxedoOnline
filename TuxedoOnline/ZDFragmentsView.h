//
//  ZDFragmentsImageView.h
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelaunayTriangulation;

@interface ZDFragmentsView : UIView
@property (nonatomic, strong) DelaunayTriangulation *triangulation;
@property (nonatomic) NSUInteger numberOfVertex;

- (void)createFragments;

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion; // animates only views do not use for layers animation directly


@end

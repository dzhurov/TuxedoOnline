//
//  ZDFragmentsImageView.h
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelaunayTriangulation;

@interface ZDFragmentsImageView : UIImageView
@property (nonatomic, strong) DelaunayTriangulation *triangulation;
@property (nonatomic) NSUInteger numberOfVertex;

- (void)createFragments;

@end

//
//  VoronoiCell+VoroninCell_GeometryAndImage.h
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

#import "VoronoiCell.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VoronoiCell (GeometryAndImage)

- (CGRect)frame;
- (void)restrictByFrame:(CGRect)frame;
- (CGImageRef)maskedImage:(CGImageRef)image cropedByFrame:(out CGRect*)frame;

@end

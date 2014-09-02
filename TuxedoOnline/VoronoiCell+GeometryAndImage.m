//
//  VoronoiCell+VoroninCell_GeometryAndImage.m
//  TuxedoOnline
//
//  Created by DZhurov on 9/2/14.
//  Copyright (c) 2014 The Men's Wearhouse. All rights reserved.
//

@import UIKit;
#import "VoronoiCell+GeometryAndImage.h"

@implementation VoronoiCell (GeometryAndImage)

- (CGRect)frame
{
    NSValue *pointValue = [self.nodes firstObject];
    CGPoint point = [pointValue CGPointValue];
    
    CGPoint topLeftPoint = point;
    CGPoint bottomRightPoint = point;
    
    for (pointValue in self.nodes) {
        CGPoint point = [pointValue CGPointValue];
        if (point.x < topLeftPoint.x)
            topLeftPoint.x = point.x;
        if (point.y < topLeftPoint.y)
            topLeftPoint.y = point.y;
        if (point.x > bottomRightPoint.x)
            bottomRightPoint.x = point.x;
        if (point.y > bottomRightPoint.y)
            bottomRightPoint.y = point.y;
    }
    return CGRectMake(topLeftPoint.x, topLeftPoint.y, (bottomRightPoint.x - topLeftPoint.x), (bottomRightPoint.y - topLeftPoint.y));
}

- (CGImageRef)maskedImage:(CGImageRef)image cropedByFrame:(out CGRect *)frame
{
    CGRect selfFrame = [self frame];
    
    // Cut the original image
    CGImageRef rectImage = CGImageCreateWithImageInRect(image, selfFrame);
    
    // Draw VoronCell to create a mask
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, selfFrame.size.width, selfFrame.size.height, 8, selfFrame.size.width, colorSpace, 0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0f);
    [self drawInContext:context];
    
    CGImageRef cgImageMask = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGImageRef maskedImage = CGImageCreateWithMask(rectImage, cgImageMask);
    
    if (frame){
        *frame = selfFrame;
    }
    return maskedImage;
}

@end

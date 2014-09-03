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

- (void)restrictByFrame:(CGRect)frame
{
//    CGPoint topLeftPoint = frame.origin;
//    CGPoint bottomRightPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
//    NSMutableArray *newNodes = [NSMutableArray arrayWithCapacity:self.nodes.count];
//    
//    for (NSValue *pointValue in self.nodes) {
//        CGPoint point = [pointValue CGPointValue];
//        if (point.x < topLeftPoint.x)
//            point.x = topLeftPoint.x;
//        if (point.y < topLeftPoint.y)
//            point.y = topLeftPoint.y;
//        if (point.x > bottomRightPoint.x)
//            point.x = bottomRightPoint.x;
//        if (point.y > bottomRightPoint.y)
//            point.y = bottomRightPoint.y;
//        
//        [newNodes addObject:[NSValue valueWithCGPoint:point]];
//    }
//    self.nodes = newNodes;
}

- (CGRect)frame
{
    NSValue *pointValue = [self.nodes firstObject];
    CGPoint point = [pointValue CGPointValue];
    
    CGPoint topLeftPoint = point;
    CGPoint bottomRightPoint = point;
    
    for (pointValue in self.nodes) {
        point = [pointValue CGPointValue];
        if (point.x < topLeftPoint.x)
            topLeftPoint.x = point.x;
        if (point.y < topLeftPoint.y)
            topLeftPoint.y = point.y;
        if (point.x > bottomRightPoint.x)
            bottomRightPoint.x = point.x;
        if (point.y > bottomRightPoint.y)
            bottomRightPoint.y = point.y;
    }
    return CGRectMake(topLeftPoint.x, topLeftPoint.y, fabs(bottomRightPoint.x - topLeftPoint.x), fabs(bottomRightPoint.y - topLeftPoint.y));
}

- (CGImageRef)maskedImage:(CGImageRef)image cropedByFrame:(out CGRect *)frame
{
    CGPoint topLeftPoint = CGPointMake(0, 0);
    CGPoint bottomRightPoint = CGPointMake(768, 1029);
    
    for (NSValue *pointValue in self.nodes) {
        CGPoint point = [pointValue CGPointValue];
        if (point.x < topLeftPoint.x)
            return nil;
        if (point.y < topLeftPoint.y)
            return nil;
        if (point.x > bottomRightPoint.x)
            return nil;
        if (point.y > bottomRightPoint.y)
            return nil;
    }

    
    CGRect selfFrame = [self frame];
    
    // Cut the original image
    CGImageRef rectImage = CGImageCreateWithImageInRect(image, selfFrame);
    
    // Draw VoronCell to create a mask
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, selfFrame.size.width, selfFrame.size.height, 8, selfFrame.size.width, colorSpace, 0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetGrayFillColor(context, 1, 1);
//    CGContextFillRect(context, CGRectMake(20, 20, 100, 100));
    
//    CGContextSetLineWidth(context, 1.0f);
    
    NSValue *prevPoint = [self.nodes lastObject];
    CGPoint p = [prevPoint CGPointValue];
    CGContextMoveToPoint(context, p.x -  selfFrame.origin.x, p.y -  selfFrame.origin.y);
    for ( NSValue *point in self.nodes)
    {
        CGPoint p = [point CGPointValue];
        CGContextAddLineToPoint(context, p.x - selfFrame.origin.x, p.y - selfFrame.origin.y);
    }
    CGContextFillPath(context);
    
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

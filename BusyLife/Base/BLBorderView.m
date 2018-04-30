//
//  BLBorderView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/30.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLBorderView.h"
#import "UIView+Common.h"

@implementation BLBorderView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* fillColor = self.backgroundColor ?: [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    if (self.borderColor && self.borderWidth > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, self.height);
        CGPathAddLineToPoint(path, NULL, self.width, self.height);
        
        [self.borderColor setStroke];
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

@end

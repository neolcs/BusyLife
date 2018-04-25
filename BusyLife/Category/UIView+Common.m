//
//  UIView+Common.m
//  tradeshiftHome
//
//  Created by Chuan Li on 7/3/14.
//  Copyright (c) 2014 Tradeshift. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)removeAllSubview{
    for ( UIView* subview in [self subviews]){
        [subview removeFromSuperview];
    }
}

- (void)setWidth:(float)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (float)width{
    return self.frame.size.width;
}

- (void)setHeight:(float)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (float)height{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setLeft:(float)left{
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (float)left{
    return self.frame.origin.x;
}

- (void)setRight:(float)right{
    float left = right - self.frame.size.width;
    self.left = left;
}

- (float)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTop:(float)top{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}

- (float)top{
    return self.frame.origin.y;
}

- (float)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(float)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)setCenterX:(float)centerX{
    self.frame = CGRectMake(centerX - self.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (float)centerX{
    return self.center.x;
}

- (void)setCenterY:(float)centerY{
    self.frame = CGRectMake(self.frame.origin.x, centerY - self.height/2, self.frame.size.width, self.frame.size.height);
}

- (float)centerY{
    return self.center.y;
}

- (void)makeRound
{
    self.layer.cornerRadius = MIN(self.width, self.height)/2.0f;
    self.clipsToBounds = YES;
}

- (UIImage *)toImage{
    UIGraphicsBeginImageContextWithOptions(self.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearFrameConstraints{
    NSMutableArray* consArray = [NSMutableArray array];
    for (NSLayoutConstraint* cons in self.constraints){
        if (cons.firstAttribute == NSLayoutAttributeWidth || cons.firstAttribute == NSLayoutAttributeHeight) {
            [consArray addObject:cons];
        }
    }
    [self removeConstraints:consArray];
    
    [consArray removeAllObjects];
    for (NSLayoutConstraint* cons in self.superview.constraints){
        if (cons.firstItem == self || cons.secondItem == self) {
            [consArray addObject:cons];
        }
    }
    [self.superview removeConstraints:consArray];
}

@end

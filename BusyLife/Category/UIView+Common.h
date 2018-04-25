//
//  UIView+Common.h
//  tradeshiftHome
//
//  Created by Chuan Li on 7/3/14.
//  Copyright (c) 2014 Tradeshift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float left;
@property (nonatomic, assign) float right;
@property (nonatomic, assign) float top;
@property (nonatomic, assign) float bottom;
@property (nonatomic, assign) float centerX;
@property (nonatomic, assign) float centerY;

- (void)setLeft:(float)left;
- (float)left;
- (void)setRight:(float)right;
- (float)right;
- (float)bottom;
- (void)setBottom:(float)bottom;

- (void)setTop:(float)top;
- (float)top;

- (void)setCenterX:(float)centerX;
- (float)centerX;
- (void)setCenterY:(float)centerY;
- (float)centerY;

- (void)setSize:(CGSize)size;
- (CGSize)size;
- (void)setHeight:(float)height;
- (float)height;
- (void)setWidth:(float)width;
- (float)width;
- (void)removeAllSubview;

- (void)makeRound;
- (UIImage *)toImage;

- (void)clearFrameConstraints;

@end

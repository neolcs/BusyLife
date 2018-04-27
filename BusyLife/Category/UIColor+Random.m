//
//  UIColor+Random.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)random{
    return [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
}

@end

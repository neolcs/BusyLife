//
//  BLLocation.h
//  BusyLife
//
//  Created by ChuanLi on 2018/5/4.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLLocation : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

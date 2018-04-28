//
//  BLSectionInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLSectionInfo<NSObject>

@property (nonatomic, strong) NSArray* cellInfoArray;

- (id<BLSectionInfo>)previous;
- (id<BLSectionInfo>)next;

@end

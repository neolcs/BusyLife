//
//  BLSectionInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLSectionInfo : NSObject

@property (nonatomic, strong) NSMutableArray* cellInfoArray;

- (BLSectionInfo *)previous;
- (BLSectionInfo *)next;

@end

//
//  BLAgendaSectionInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLSectionInfo.h"
#import "BLDateViewModel.h"

@interface BLAgendaSectionInfo : NSObject <BLSectionInfo>

@property (nonatomic, readonly) BLDateViewModel* dateVM;

+ (BLAgendaSectionInfo *)current;
- (instancetype)initWithDateVM:(BLDateViewModel *)dateVM;

@end

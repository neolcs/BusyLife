//
//  BLEvent.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLLocation.h"

@interface BLEvent : NSObject

@property (nonatomic, strong) NSDate* startDate;        //UTC time
@property (nonatomic, assign) NSTimeInterval range;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSArray* attends;
@property (nonatomic, strong) BLLocation* location;

@end

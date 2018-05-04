//
//  BLEventViewModel.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEvent.h"

//typedef void (^BLEventViewModelUpdateHandler)(void);

@interface BLEventViewModel : NSObject

@property (nonatomic, readonly) BLEvent* event;
@property (nonatomic, readonly) NSString* startTime;
@property (nonatomic, readonly) NSString* range;
@property (nonatomic, readonly) UIColor* typeColor;
@property (nonatomic, readonly) NSString* location;

- (instancetype)initWithEvent:(BLEvent *)event;

@end

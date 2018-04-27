//
//  BLDateViewModel.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/27.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BLDayGridViewHighlight  @"BLDayGridViewHighlight"

typedef void (^DateVMUpdateHandler)(void);

@interface BLDateViewModel : NSObject

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, copy) DateVMUpdateHandler updateHandler;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) int lineNumber;
@property (nonatomic, readonly) UIColor* backColor;
@property (nonatomic, readonly) UIColor* dayBackColor;
@property (nonatomic, readonly) UIColor* dayTextColor;

- (instancetype)initWithDate:(NSDate *)date;

@end

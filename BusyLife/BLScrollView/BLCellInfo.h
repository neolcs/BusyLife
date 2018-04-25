//
//  BLCellInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLCellInfo : NSObject

- (BLCellInfo *)previous;
- (BLCellInfo *)next;

@end

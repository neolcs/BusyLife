//
//  BLWeather.m
//  BusyLife
//
//  Created by ChuanLi on 2018/5/4.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLWeather.h"

@implementation BLWeather

+ (BOOL)supportsSecureCoding {
    return true;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeDouble:self.temperatureMin forKey:@"min"];
    [aCoder encodeDouble:self.temperatureMax forKey:@"max"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.time = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"time"];
        self.summary = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"summary"];
        self.icon = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"icon"];
        self.temperatureMax = [aDecoder decodeDoubleForKey:@"max"];
        self.temperatureMin = [aDecoder decodeDoubleForKey:@"min"];
    }
    return self;
}

@end

//
//  BLWeatherView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/5/4.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLWeatherView.h"
#import "BLDataProvider.h"
#import "BLWeather.h"
#import "BLParser.h"
#import "NSDate+Helper.h"

@interface BLWeatherView()

@property (nonatomic, strong) UIImageView* iconView;

- (void)_updateCache:(NSArray *)weatherArray;

@end

@implementation BLWeatherView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        UIImageView* iconView = [[UIImageView alloc] init];
        iconView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:iconView];
        
        [iconView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [iconView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
        [iconView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
        [iconView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
        
        self.iconView = iconView;
    }
    return self;
}


- (void)displayWeatcherForDate:(NSDate *)date atLocation:(BLLocation *)location {
    BLWeather* weather = [[BLDataProvider sharedInstance] weatherForDate:date];
    if (weather) {
        self.iconView.image = [UIImage imageNamed:weather.icon];
    }
    else {
        if ([date compare:[NSDate date]] == NSOrderedAscending) {
            return;
        }
        NSURLSession* session = [[BLDataProvider sharedInstance] session];
        NSString* url = [NSString stringWithFormat:@"https://api.darksky.net/forecast/3147ce9f0b7992e57d6270ca9478efd4/%f,%f?exclude=[currently,minutely,hourly,alerts,flags]", location.latitude, location.longitude];
        
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask* task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse* res = (NSHTTPURLResponse *)response;
            if (res.statusCode >= 200 && res.statusCode < 300) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSArray* dailyArray = [dict valueForKeyPath:@"daily.data"];
                BLParser* parser = [[BLParser alloc] init];
                NSMutableArray* weatherArray = [NSMutableArray array];
                for (NSDictionary* dict in dailyArray){
                    BLWeather* weather = [parser parseDict:dict toClass:[BLWeather class]];
                    if (weather) {
                        [weatherArray addObject:weather];
                        if ([weather.time isEqual:[date resetTo0]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.iconView.image = [UIImage imageNamed:weather.icon];
                            });
                        }
                    }
                }
                [weakSelf _updateCache:weatherArray];
            }
        }];
        
        [task resume];
    }
}

- (void)_updateCache:(NSArray *)weatherArray {
    [[BLDataProvider sharedInstance] saveWeatherArray:weatherArray];
}

@end

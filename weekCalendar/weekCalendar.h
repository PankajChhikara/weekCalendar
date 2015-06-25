//
//  weekCalendar.h
//  weeklyCalendar
//
//  Created by Pankaj Chhikara on 25/06/15.
//  Copyright (c) 2015 pankajchhikara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weekCalendar : NSObject
@property(nonatomic, strong) NSLocale    *locale;
@property(nonatomic, copy)   NSCalendar   *calendar;
@property (nonatomic, strong) NSDate *date;


-(NSMutableDictionary *)currentWeekDays;
-(NSMutableDictionary *)nextWeekDates;
-(NSMutableDictionary *)previousWeekDates;

@end

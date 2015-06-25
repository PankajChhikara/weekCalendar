//
//  weekCalendar.m
//  weeklyCalendar
//
//  Created by Pankaj Chhikara on 25/06/15.
//  Copyright (c) 2015 pankajchhikara. All rights reserved.
//

#import "weekCalendar.h"

@implementation weekCalendar
-(id)init{
    
    self=[super init];
    
    if (self) {
        _locale = [NSLocale currentLocale];
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
        [_calendar setLocale:_locale];
        _date = [NSDate date];
    }
    return self;
    
}

-(NSMutableDictionary *)currentWeekDays{
    // NSUInteger daysPerWeek = [self daysPerWeekUsingReferenceDate:[self date]];
    NSMutableArray *currentweek =[[NSMutableArray alloc]init];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    
    for (int x=0; x<7; x++) {
        [currentweek addObject:[self dateByAddingDays:x toDate:[self firstDayOfTheWeek]]];
    }
    [dict setObject:currentweek forKey:@"currentweek"];
    [dict setObject:[self _firstVisibleDateForDisplayMode] forKey:@"firstweekday"];
    [dict setObject:[self _lastVisibleDateForDisplayMode] forKey:@"lastweekday"];
    return dict;
}

-(NSMutableDictionary *)nextWeekDates{
    NSMutableArray *nextweek =[[NSMutableArray alloc]init];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    NSDate *date =_date;
    date = [self dateByAddingWeeks:1 toDate:date];                   //  Add a week
    NSUInteger dayOfWeek = [self weekdayInDate:date];
    date = [self  dateBySubtractingDays:dayOfWeek-self.calendar.firstWeekday fromDate:date];   //  Jump to sunday
    
    // NSLog(@"%@",date);
    [nextweek addObject:date];
    for (int x=1; x<7; x++) {
        // NSLog(@"%@",[self dateByAddingDays:x toDate:date]);
        [nextweek addObject:[self dateByAddingDays:x toDate:date]];
    }
    _date=date;
    [dict setObject:nextweek forKey:@"currentweek"];
    [dict setObject:[self _firstVisibleDateForDisplayMode] forKey:@"firstweekday"];
    [dict setObject:[self _lastVisibleDateForDisplayMode] forKey:@"lastweekday"];
    
    return dict;
}

-(NSMutableDictionary *)previousWeekDates{
    NSMutableArray *previousweek =[[NSMutableArray alloc]init];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    NSDate *date =_date;
    date = [self dateBySubtractingWeeks:1 fromDate:date];                   //  Add a week
    NSUInteger dayOfWeek = [self weekdayInDate:date];
    date = [self  dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
    
    
    [previousweek addObject:date] ;  //  NSLog(@"previous %@",date);
    for (int x=1; x<7; x++) {
        //  NSLog(@"---%@",[self dateByAddingDays:x toDate:date]);
        [previousweek addObject:[self dateByAddingDays:x toDate:date]];
    }
    _date=date;
    [dict setObject:previousweek forKey:@"currentweek"];
    [dict setObject:[self _firstVisibleDateForDisplayMode] forKey:@"firstweekday"];
    [dict setObject:[self _lastVisibleDateForDisplayMode] forKey:@"lastweekday"];
    
    return dict;
}

- (NSDate *)firstDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    return [self firstDayOfTheWeekUsingReferenceDate:date andStartDay:1];
}
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date andStartDay:(NSInteger)day
{
    NSInteger weekday = [self weekdayInDate:date]-day;
    return [self dateBySubtractingDays:weekday fromDate:date];
}
- (NSInteger)weekdayInDate:(NSDate*)date
{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitWeekday fromDate:date];
    return [comps weekday];
}
- (NSDate *)dateBySubtractingDays:(NSUInteger)days fromDate:(NSDate *)date
{
    NSDateComponents *c = [NSDateComponents new];
    [c setDay:-days];
    return [_calendar dateByAddingComponents:c toDate:date options:0];
}

- (NSDate *)_firstVisibleDateForDisplayMode
{
    return [self firstDayOfTheWeekUsingReferenceDate:[self date] andStartDay:self.calendar.firstWeekday];
}

- (NSDate *)_lastVisibleDateForDisplayMode
{
    return [self lastDayOfTheWeekUsingReferenceDate:[self date]];
}
- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    
    NSDate *d = [self firstDayOfTheWeekUsingReferenceDate:date];
    NSUInteger daysPerWeek = [self daysPerWeekUsingReferenceDate:d];
    return [self dateByAddingDays:daysPerWeek-1 toDate:d];
}
- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date
{
    NSDate *weekLater = [self dateByAddingWeeks:1 toDate:date];
    return [[_calendar components:NSCalendarUnitDay fromDate:date toDate:weekLater options:0] day];
}

//- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar
//{
//    NSDateFormatter *f = [NSDateFormatter new];
//    [f setCalendar:calendar];
//    [f setDateFormat:@"MMMM yyyy"];
//    return [f stringFromDate:_date];
//}

//- (BOOL)date:(NSDate*)firstDate isSameMonthAs:(NSDate *)anotherDate
//{
//
//    NSInteger firstMonth = [self monthsInDate:firstDate];
//    NSInteger secondMonth = [self monthsInDate:anotherDate];
//
//    BOOL sameMonth = firstMonth == secondMonth;
//    BOOL sameYear = [self date:firstDate isSameYearAs:anotherDate];
//
//    return sameYear && sameMonth;
//}
- (BOOL)date:(NSDate *)firstDate isSameYearAs:(NSDate *)anotherDate
{
    NSInteger firstYear = [self yearsInDate:firstDate];
    NSInteger secondYear = [self yearsInDate:anotherDate];
    
    BOOL sameYear = firstYear == secondYear;
    BOOL sameEra =  [self date:firstDate isSameEraAs:anotherDate];
    
    return sameEra && sameYear;
}
//- (NSInteger)monthsInDate:(NSDate*)date
//{
//    NSDateComponents *comps = [_calendar components:NSCalendarUnitMonth fromDate:date];
//    return [comps month];
//}
- (NSInteger)yearsInDate:(NSDate*)date
{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitYear fromDate:date];
    return [comps year];
}

- (BOOL)date:(NSDate *)firstDate isSameEraAs:(NSDate *)anotherDate
{
    NSInteger firstEra = [self eraInDate:firstDate];
    NSInteger secondEra = [self eraInDate:anotherDate];
    return firstEra == secondEra;
}
- (NSInteger)eraInDate:(NSDate*)date
{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitEra fromDate:date];
    return [comps era];
}
//- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar
//{
//    NSDateFormatter *f = [NSDateFormatter new];
//    [f setCalendar:calendar];
//    [f setDateFormat:@"MMM yyyy"];
//    return [f stringFromDate:_date];
//}
- (NSDate *)dateByAddingWeeks:(NSUInteger)weeks toDate:(NSDate *)date
{
    NSDateComponents *c = [NSDateComponents new];
    [c setWeekOfYear:weeks];
    return [_calendar dateByAddingComponents:c toDate:date options:0];
}

- (BOOL)date:(NSDate*)firstDate isSameWeekAs:(NSDate *)anotherDate
{
    
    NSInteger firstMonth = [self weekOfYearInDate:firstDate];
    NSInteger secondMonth = [self weekOfYearInDate:anotherDate];
    
    BOOL sameMonth = firstMonth == secondMonth;
    BOOL sameYear = [self date:firstDate isSameYearAs:anotherDate];
    
    return sameYear && sameMonth;
}
- (NSInteger)weekOfYearInDate:(NSDate*)date
{
    NSDateComponents *comps = [_calendar components:NSCalendarUnitWeekOfYear fromDate:date];
    return [comps weekOfYear];
}
- (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate *)date
{
    NSDateComponents *c = [NSDateComponents new];
    [c setDay:days];
    return [_calendar dateByAddingComponents:c toDate:date options:0];
}
- (NSDate *)dateBySubtractingWeeks:(NSUInteger)weeks fromDate:(NSDate *)date
{
    NSDateComponents *c = [NSDateComponents new];
    [c setWeekOfYear:-weeks];
    return [_calendar dateByAddingComponents:c toDate:date options:0];
}


@end

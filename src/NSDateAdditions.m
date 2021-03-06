#import "Three20/TTGlobal.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global 

static NSDateFormatter* dayFormatter = nil;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSDate (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (NSDate*)dateWithToday {
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  formatter.dateFormat = @"yyyy-d-M";
  
  NSString* time = [formatter stringFromDate:[NSDate date]];
  NSDate* date = [formatter dateFromString:time];
  return date;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (NSDate*)dateAtMidnight {
  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  formatter.dateFormat = @"yyyy-d-M";
  
  NSString* time = [formatter stringFromDate:self];
  NSDate* date = [formatter dateFromString:time];
  return date;
}

- (NSString*)formatTime {
  static NSDateFormatter* timeFormatter = nil;
  if (!timeFormatter) {
    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = TTLocalizedString(@"h:mm a", @"");
    timeFormatter.locale = TTCurrentLocale();
  }
  return [timeFormatter stringFromDate:self];
}

- (NSString*)formatDate {
  static NSDateFormatter* fullDateFormatter = nil;
  if (!fullDateFormatter) {
    fullDateFormatter = [[NSDateFormatter alloc] init];
    fullDateFormatter.dateFormat = TTLocalizedString(@"EEEE, LLLL d, YYYY", @"");
    fullDateFormatter.locale = TTCurrentLocale();
  }
  return [fullDateFormatter stringFromDate:self];
}

- (NSString*)formatShortTime {
  NSTimeInterval diff = abs([self timeIntervalSinceNow]);
  if (diff < TT_DAY) {
    return [self formatTime];
  } else if (diff < TT_WEEK) {
    static NSDateFormatter* shortTimeFormatterWeek = nil;
    if (!shortTimeFormatterWeek) {
      shortTimeFormatterWeek = [[NSDateFormatter alloc] init];
      shortTimeFormatterWeek.dateFormat = TTLocalizedString(@"EEEE", @"");
      shortTimeFormatterWeek.locale = TTCurrentLocale();
    }
    return [shortTimeFormatterWeek stringFromDate:self];
  } else {
    static NSDateFormatter* shortTimeFormatterYear = nil;
    if (!shortTimeFormatterYear) {
      shortTimeFormatterYear = [[NSDateFormatter alloc] init];
      shortTimeFormatterYear.dateFormat = TTLocalizedString(@"M/d/yy", @"");
      shortTimeFormatterYear.locale = TTCurrentLocale();
    }
    return [shortTimeFormatterYear stringFromDate:self];
  }
}

- (NSString*)formatDateTime {
  NSTimeInterval diff = abs([self timeIntervalSinceNow]);
  if (diff < TT_DAY) {
    return [self formatTime];
  } else if (diff < TT_WEEK) {
    static NSDateFormatter* shortTimeFormatterWeek = nil;
    if (!shortTimeFormatterWeek) {
      shortTimeFormatterWeek = [[NSDateFormatter alloc] init];
      shortTimeFormatterWeek.dateFormat = TTLocalizedString(@"EEE h:mm a", @"");
      shortTimeFormatterWeek.locale = TTCurrentLocale();
    }
    return [shortTimeFormatterWeek stringFromDate:self];
  } else {
    static NSDateFormatter* shortTimeFormatterYear = nil;
    if (!shortTimeFormatterYear) {
      shortTimeFormatterYear = [[NSDateFormatter alloc] init];
      shortTimeFormatterYear.dateFormat = TTLocalizedString(@"MMM d h:mm a", @"");
      shortTimeFormatterYear.locale = TTCurrentLocale();
    }
    return [shortTimeFormatterYear stringFromDate:self];
  }
}

- (NSString*)formatRelativeTime {
  NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
  if (elapsed <= 1) {
    return TTLocalizedString(@"just a moment ago", @"");
  } else if (elapsed < TT_MINUTE) {
    int seconds = (int)(elapsed);
    return [NSString stringWithFormat:TTLocalizedString(@"%d seconds ago", @""), seconds];
  } else if (elapsed < 2*TT_MINUTE) {
    return TTLocalizedString(@"about a minute ago", @"");
  } else if (elapsed < TT_HOUR) {
    int mins = (int)(elapsed/TT_MINUTE);
    return [NSString stringWithFormat:TTLocalizedString(@"%d minutes ago", @""), mins];
  } else if (elapsed < TT_HOUR*1.5) {
    return TTLocalizedString(@"about an hour ago", @"");
  } else if (elapsed < TT_DAY) {
    int hours = (int)((elapsed+TT_HOUR/2)/TT_HOUR);
    return [NSString stringWithFormat:TTLocalizedString(@"%d hours ago", @""), hours];
  } else {
    return [self formatDateTime];
  }
}

- (NSString*)formatDay:(NSDateComponents*)today yesterday:(NSDateComponents*)yesterday {
  if (!dayFormatter) {
    dayFormatter = [[NSDateFormatter alloc] init];
    dayFormatter.dateFormat = TTLocalizedString(@"MMMM d", @"");
    dayFormatter.locale = TTCurrentLocale();
  }

  NSCalendar* cal = [NSCalendar currentCalendar];
  NSDateComponents* day = [cal components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                               fromDate:self];

  if (day.day == today.day && day.month == today.month && day.year == today.year) {
    return TTLocalizedString(@"Today", @"");
  } else if (day.day == yesterday.day && day.month == yesterday.month
             && day.year == yesterday.year) {
    return TTLocalizedString(@"Yesterday", @"");
  } else {
    return [dayFormatter stringFromDate:self];
  }
}

@end

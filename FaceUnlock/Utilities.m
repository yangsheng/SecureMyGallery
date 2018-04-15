//
//  Utilities.m
//

#import "Utilities.h"
#import <math.h>

@implementation Utilities

#pragma mark - Geometry

+(float) getPolarVectorDX: (float) dx DY: (float) dy {
	return sqrt(dx*dx + dy*dy);
}

+(float) getPolarUngleDX: (float) dx DY: (float) dy {
	if (dx > 0 && dy >= 0)
		return [self rad2Deg: atan(dy/dx)];
	else if (dx > 0 && dy < 0)
		return [self rad2Deg: atan(dy/dx)] + 360;
	else if (dx  < 0)
		return [self rad2Deg: atan(dy/dx)] + 180;
	else if (dx == 0 && dy > 0)
		return 90;
	else if (dx == 0 && dy < 0)
		return 270;
	return 0;
}

+(float) deg2Rad: (float) degrees{
	return degrees * M_PI / 180;
}

+(float) rad2Deg: (float) radians{
	return radians * 180 / M_PI;
}

#pragma mark - DateTime

+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    if ([date compare:endDate] == NSOrderedDescending) 
        return NO;
	
    return YES;
}

+(NSDate *) timeFromHour: (int) h Minute: (int) m {
    //Calendar
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [Utilities dateComponentsFromDate: [NSDate date]];
    [components setHour: h];
    [components setMinute: m];
    [components setSecond: 0];
    
    NSDate *result = [calendar dateFromComponents: components];
    
    
    return result;
}

+(int) yearFromTime: (NSDate *) date {
    NSDateComponents *components = [Utilities dateComponentsFromDate: date];
    return [components year]; 
}

+(int) hourFromTime: (NSDate *) date {
    NSDateComponents *components = [Utilities dateComponentsFromDate: date];
    return [components hour];
}

+(int) minuteFromTime: (NSDate *) date {
    NSDateComponents *components = [Utilities dateComponentsFromDate: date];
    return [components minute];
}

+(NSString *) localizedTimeStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    
    return formattedDateString;
}

+(NSString *) localizedDateStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
       
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    
    return formattedDateString;
}

+(NSString *) localizedShortDateStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    
    return formattedDateString;
}

+(NSString *) localizedLongDateStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    
    return formattedDateString;
}

+(NSDateComponents *) dateComponentsFromDate: (NSDate *) date {
	//Calendar
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	
    //Date components
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate: date];
	
    //Release
	
	return dateComponents;
}

+(NSDate *) dateFromDateComponents: (NSDateComponents *) comps {
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *resDate = [calendar dateFromComponents: comps];
    
    
    return  resDate;
}

+(NSDate *) getWeekStartDate: (NSDate *) date {
    NSDate *temp = date;
    
    do {
        NSDateComponents *comps = [Utilities dateComponentsFromDate: temp];
        
        //Check first day of week
        if ([comps weekday] == 1)
            break;
            
        //Go back
        temp = [temp dateByAddingTimeInterval: -3600 * 24];
    } while (TRUE);
    
    return temp;
}

+(NSDate *) getWeekEndDate : (NSDate *) date {
    NSDate *temp = date;
    
    do {
        NSDateComponents *comps = [Utilities dateComponentsFromDate: temp];
        
        //Check last day of week
        if ([comps weekday] == 7)
            break;
        
        //Go back
        temp = [temp dateByAddingTimeInterval: 3600 * 24];
    } while (TRUE);
    
    return temp;
}

+(NSDate *) getMonthStartDate: (NSDate *) date {
    //Calendar
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Calculate first day
    NSDateComponents *comps = [Utilities dateComponentsFromDate: date];
    [comps setDay: 1];
    NSDate *temp = [calendar dateFromComponents: comps];
    
    //Release
    
    return temp;
}

+(NSDate *) getMonthEndDate: (NSDate *) date {
    //Calendar
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Calculate last day
    NSDateComponents *comps = [Utilities dateComponentsFromDate: date];
    
    int tempMonth = [comps month];
    int tempYear = [comps year];
    
    tempMonth++;
    if (tempMonth == 13) {
        tempMonth = 1;
        tempYear++;
    }
    
    [comps setDay: 1];
    [comps setMonth: tempMonth];
    [comps setYear: tempYear];
    
    NSDate *temp = [calendar dateFromComponents: comps];
    
    temp = [temp dateByAddingTimeInterval: -3600 * 24];
    
    //Release
    
    return temp;
}

+(NSDate *) getDateStart: (NSDate *) date {
    //Calendar
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	//Get components
	NSDateComponents *dateComponents = [Utilities dateComponentsFromDate: date];
    
	//Start of the day
	[dateComponents setHour: 0];
	[dateComponents setMinute: 0];
	[dateComponents setSecond: 0];
	
    //Resulting date
    NSDate *temp = [calendar dateFromComponents: dateComponents];
    
    //Release
	
    //Return
	return temp;
}

+(NSDate *) getDateMiddle: (NSDate *) date {
    //Calendar
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	//Get components
	NSDateComponents *dateComponents = [Utilities dateComponentsFromDate: date];
    
	//Start of the day
	[dateComponents setHour: 12];
	[dateComponents setMinute: 0];
	[dateComponents setSecond: 0];
	
    //Resulting date
    NSDate *temp = [calendar dateFromComponents: dateComponents];
    
    //Release
	
    //Return
	return temp;
}


+(NSDate *) getDateEnd: (NSDate *) date {
    //Calendar
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	//Get components
	NSDateComponents *dateComponents = [Utilities dateComponentsFromDate: date];
    
	//Start of the day
	[dateComponents setHour: 23];
	[dateComponents setMinute: 59];
	[dateComponents setSecond: 59];
	
    //Resulting date
    NSDate *temp = [calendar dateFromComponents: dateComponents];
    
    //Release
	
    //Return
	return temp;
}

#pragma mark - XML Date

+(NSDate *) dateFromXMLString: (NSString *) text {
    //Verification
    if (text == nil || [text isKindOfClass: [NSNull class]])
        return nil;
    
	NSDateFormatter *xmlDateFromat = [[NSDateFormatter alloc] init];
    xmlDateFromat.timeStyle = NSDateFormatterFullStyle;
    xmlDateFromat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *date = [xmlDateFromat dateFromString: text];
	
	return date;
}

+(NSString *) XMLStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}


#pragma mark - SQL Date

+(NSDate *) dateFromSQLString: (NSString *) text {
    //Verification
    if (text == nil || [text isKindOfClass: [NSNull class]])
        return nil;
    
	NSDateFormatter *sqlDateFormat = [[NSDateFormatter alloc] init];
    sqlDateFormat.timeStyle = NSDateFormatterFullStyle;
    if ([text rangeOfString: @" "].location == NSNotFound)
        sqlDateFormat.dateFormat = @"yyyy-MM-dd";
    else
        sqlDateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [sqlDateFormat dateFromString: text];
	
	return date;
}

+(NSString *) SQLStringFromDate: (NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}

#pragma mark - Number formatting

+(NSString *) getShortString: (float) number decimals: (int) decimals unit: (int) u {
	NSString *result;
	
	//Formatter
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	
	//Decimals
	if (decimals == 0) {
		[numberFormatter setPositiveFormat: @"#,##0"];
		[numberFormatter setNegativeFormat: @"-#.##0"];
	} else if (decimals == 1) {
		[numberFormatter setPositiveFormat: @"#,##0.0"];
		[numberFormatter setNegativeFormat: @"-#,##0.0"];
	} else if (decimals == 2) {
		[numberFormatter setPositiveFormat: @"#,##0.00"];
		[numberFormatter setNegativeFormat: @"-#.##0.00"];
	}
	
	//Transformation
	if (u == 2) {
		result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000000]];
	} else if (u == 1) {
		result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000]];
	} else {
		result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number]];
	}
	
	//Result
	return result;	
}

+(NSString *) getShortString: (float) number decimals: (int) decimals {
	NSString *result;
	
	//Formatter
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	
	//Decimals
	if (decimals == 0) {
		[numberFormatter setPositiveFormat: @"#,##0"];
		[numberFormatter setNegativeFormat: @"-#.##0"];
	} else if (decimals == 1) {
		[numberFormatter setPositiveFormat: @"#,##0.0"];
		[numberFormatter setNegativeFormat: @"-#,##0.0"];
	} else if (decimals == 2) {
		[numberFormatter setPositiveFormat: @"#,##0.00"];
		[numberFormatter setNegativeFormat: @"-#.##0.00"];
	}
	
	//Transformation
	if (number >= 1000000) {
		//Millions +
		result = [NSString stringWithFormat: @"%@ M", [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000000]]];
	} else if (number >= 1000) {
		//Thousands +
		result = [NSString stringWithFormat: @"%@ K", [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000]]];
	} else if (number > -1000) {
		//Normal
		result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number]];
	} else if (number > -1000000) {
		//Thousands -
		result = [NSString stringWithFormat: @"%@ K", [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000]]];
	} else {
		//Millions -
		result = [NSString stringWithFormat: @"%@ M", [numberFormatter stringFromNumber:[NSNumber numberWithFloat: number/1000000]]];
	}
	
	//Result
	return result;
}

+(NSString *) getString: (float) number decimals: (int) decimals {
	NSString *result;
	
	//Formatter
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	
	//Decimals
	if (decimals == 0) {
		[numberFormatter setPositiveFormat: @"#,##0"];
		[numberFormatter setNegativeFormat: @"-#.##0"];
	} else if (decimals == 1) {
		[numberFormatter setPositiveFormat: @"#,##0.0"];
		[numberFormatter setNegativeFormat: @"-#,##0.0"];
	} else if (decimals == 2) {
		[numberFormatter setPositiveFormat: @"#,##0.00"];
		[numberFormatter setNegativeFormat: @"-#.##0.00"];
	}
	
	//Transformation
	result = [numberFormatter stringFromNumber: [NSNumber numberWithFloat: number]];
	
	//Result
	return result;
}

#pragma mark - Other

+ (NSString *) generateGUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+(NSString *) getTwoDigits: (int) number {
	if (number < 10)
		return [NSString stringWithFormat: @"0%i", number];
	else
		return [NSString stringWithFormat: @"%i", number];
}

+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

+(NSString *)encodeURL: (NSString *) text {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)text,
                                                                           NULL,
                                                                           CFSTR(":/=,!$& '()*+;[]@#?"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

@end

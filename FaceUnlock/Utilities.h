//
//  Utilities.h
//

#import <Foundation/Foundation.h>
#import <math.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utilities : NSObject {
	
}

//Geometry

+(float) getPolarVectorDX: (float) dx DY: (float) dy;

+(float) getPolarUngleDX: (float) dx DY: (float) dy;

+(float) deg2Rad: (float) degrees;

+(float) rad2Deg: (float) radians;

//Date and Time

+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

+(NSDate *) timeFromHour: (int) h Minute: (int) m;

+(int) yearFromTime: (NSDate *) date;

+(int) hourFromTime: (NSDate *) date;

+(int) minuteFromTime: (NSDate *) date; 

+(NSDate *) dateFromXMLString: (NSString *) text;

+(NSString *) localizedTimeStringFromDate: (NSDate *) date;

+(NSString *) localizedDateStringFromDate: (NSDate *) date;

+(NSString *) localizedShortDateStringFromDate: (NSDate *) date;

+(NSString *) localizedLongDateStringFromDate: (NSDate *) date;

+(NSDateComponents *) dateComponentsFromDate: (NSDate *) date;

+(NSDate *) dateFromDateComponents: (NSDateComponents *) comps;

+(NSDate *) getWeekStartDate: (NSDate *) date;

+(NSDate *) getWeekEndDate : (NSDate *) date;

+(NSDate *) getMonthStartDate: (NSDate *) date;

+(NSDate *) getMonthEndDate: (NSDate *) date;

+(NSDate *) getDateStart: (NSDate *) date;

+(NSDate *) getDateMiddle: (NSDate *) date;

+(NSDate *) getDateEnd: (NSDate *) date;

//XML Date

+(NSDate *) dateFromXMLString: (NSString *) text;

+(NSString *) XMLStringFromDate: (NSDate *) date;

//SQL Date

+(NSDate *) dateFromSQLString: (NSString *) text;

+(NSString *) SQLStringFromDate: (NSDate *) date;

//Number formatting

+(NSString *) getShortString: (float) number decimals: (int) decimals unit: (int) u;

+(NSString *) getShortString: (float) number decimals: (int) decimals;

+(NSString *) getString: (float) number decimals: (int) decimals;

+(NSString *) getTwoDigits: (int) number;

//Other

+ (NSString *) generateGUID;

+(NSString *) md5:(NSString *)str;

+(NSString *)encodeURL: (NSString *) text;

@end

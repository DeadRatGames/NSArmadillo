////////////////////////////////////////////////////////////////////////////////////////////////
//
//  XL.h
//
//  Created by Christopher Larsen
//
////////////////////////////////////////////////////////////////////////////////////////////////


/*   How to use XL Helper Class functions
 
 1. Include XL.h everywhere you want to use it
 2. All the helpers can be called from the XL object as class methods, like this:    [XL random:5];
 
 What you get:
 
 - AND, OR and NOT are back! Put away your !((this)||(this)&&(this)) now use NOT(this OR this AND this)
 - Random numbers
 - converters for radians and degrees
 - Check if a file exists
 - hit testing for points and rects
 - isEmpty static function to check if a pointer is pointing at ANYTHING, even works for empty strings and arrays
 - Added simple methods isPortrait and isLandscape to detect current Device orientation
 
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XLDebug.h"
#import "XLFramerate.h"
#import "XLCoreGeometry.h"
#import "XLHTTPStatusCodes.h"

//#import "Class Extensions.h"


#define OR  ||
#define AND &&
#define NOT !
#define TEMP

#define currentOrientation [[UIApplication sharedApplication] statusBarOrientation]
#define isLandscape UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define isPortrait  UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])


@interface XL : NSObject

+ (void)sleepThreadForTimeInterval:(float)seconds;
+ (NSString *)documentsDirectoryPath;
+ (NSURL *)documentsDirectoryURL;
+ (float)radToDeg:(float)rad;
+ (float)degToRad:(float)deg;
+ (void)seedRandom;
+ (int)random:(int)max;
+ (CGPoint)midpointOfPoint1:(CGPoint)pointOne Point2:(CGPoint)pointTwo;
+ (BOOL)hitTestPoint:(CGPoint)pointTest InRect:(CGRect)hit_rect;
+ (BOOL)hitTestRect:(CGRect)rectTest InRect:(CGRect)rectHit;
+ (NSDate *)dateFromUnixTimestamp:(NSString *)timestamp;
+ (long long)unixTimestampCurrentTime;
+ (BOOL)fileExists:(NSString *)stringFile;
+ (BOOL)intersectionPoint:(CGPoint *)pointIntersection
              SegmentAOne:(CGPoint)pointSegmentAOne
              SegmentATwo:(CGPoint)pointSegmentATwo
              SegmentBOne:(CGPoint)pointSegmentBOne
              SegmentBTwo:(CGPoint)pointSegmentBTwo;
+ (NSString *)determineApplicationID:(NSString *)original;
+ (long long unsigned int)sizeOfFileAtPath:(NSString *)path;
+ (id)loadObjectWithClass:(Class)objectClass fromXIB:(NSString *)xib withOwner:(id)owner;
+ (UIView *)loadViewWithTag:(int)tag fromXibNamed:(NSString *)xib withOwner:(id)owner;
+ (CGRect)frameToAspectFitRect:(CGRect)rectOriginal inRect:(CGRect)rectFit;
+ (CGPathRef)pathForRoundedRect:(CGRect)rect radius:(CGFloat)radius;
+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
+ (NSString *)mimeTypeOfFileAtPath:(NSString *)pathFile;
+ (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range;
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (float)limitFloat:(float)f toValueBetweenLowerLimit:(float)lowerLimit andUpperLimit:(float)upperLimit;
+ (void) cacheResponse:(NSDictionary *)response;
+ (NSDictionary *) dictionaryFromCachedResponse;

@end






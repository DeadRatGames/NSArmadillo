////////////////////////////////////////////////////////////////////
//
//  XL.m
//
//  Created by Christopher Larsen
//
////////////////////////////////////////////////////////////////////////////////////////////////

#import "XL.h"

//#import "NSString+Extensions.h"
#import <QuartzCore/CoreAnimation.h>
#import <CommonCrypto/CommonDigest.h>


@implementation XL

+ (void)sleepThreadForTimeInterval:(float)seconds
{
	[NSThread sleepForTimeInterval:seconds];
}

+ (NSString *)documentsDirectoryPath
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)documentsDirectoryURL
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [searchPaths lastObject];
    
	return [NSURL fileURLWithPath:documentPath];
}

+ (NSString *)determineApplicationID:(NSString *)original
{
	NSRange range = [original rangeOfString:@"/Documents"];
	if (range.location != NSNotFound) {
		NSString *firstHalf = [original substringToIndex:range.location];
		NSArray *arrayComps = [firstHalf componentsSeparatedByString:@"/"];
		NSString *directoryID = [arrayComps lastObject];
		if (directoryID) {
			return directoryID;
		}
	}
    
	return nil;
}

+ (void)seedRandom
{
	srand( [NSDate timeIntervalSinceReferenceDate] );
}

+ (int)random:(int)max
{
	if (max <= 0) return 0;
    
	int random_number = rand() % max;
    
	return random_number;
}

+ (CGPoint)midpointOfPoint1:(CGPoint)pointOne Point2:(CGPoint)pointTwo
{
	CGFloat new_x = (pointOne.x + pointTwo.x) / 2.0;
	CGFloat new_y = (pointOne.y + pointTwo.y) / 2.0;
	CGPoint pointNew = CGPointMake(new_x, new_y);
    
	return pointNew;
}

+ (float)radToDeg:(float)x
{
	return (1.0f * x * 180.0f / M_PI );
}

+ (float)degToRad:(float)x
{
	return (1.0f * x / 180.0f * M_PI );
}

+ (BOOL)hitTestPoint:(CGPoint)pointTest InRect:(CGRect)rectHit
{
	if (pointTest.x < rectHit.origin.x) return FALSE;
	if (pointTest.y < rectHit.origin.y) return FALSE;
	if (pointTest.x > rectHit.origin.x + rectHit.size.width) return FALSE;
	if (pointTest.y > rectHit.origin.y + rectHit.size.height) return FALSE;
	return TRUE;
}

+ (BOOL)hitTestRect:(CGRect)rectTest InRect:(CGRect)rectHit
{
	if (rectTest.origin.x > rectHit.origin.x + rectHit.size.width) return FALSE;
	if (rectTest.origin.y > rectHit.origin.y + rectHit.size.height) return FALSE;
	if (rectTest.origin.x + rectTest.size.width  < rectHit.origin.x) return FALSE;
	if (rectTest.origin.y + rectTest.size.height < rectHit.origin.y) return FALSE;
	return TRUE;
}

+ (NSDate *)dateFromUnixTimestamp:(NSString *)timestamp
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setFormatterBehavior:NSDateFormatterBehavior10_4];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *convertedDate = [df dateFromString:timestamp];
    
	return convertedDate;
}

+ (NSString *)howLongSinceDate:(NSDate *)date
{
	if (date == nil) return @"Unknown";
    
	double t_then = [date timeIntervalSince1970];
	double t_now  = [[NSDate dateWithTimeIntervalSinceNow:0]  timeIntervalSince1970];
	double ti = t_now - t_then;
    
	if (ti < 0) {
		return @"Future date";
	} else if (ti < 120) {
		return @"Less than 1 minute ago";
	} else if (ti < 60 * 60) {
		int diff = round(ti / 60);
		return [NSString stringWithFormat:@"%d min ago", diff];
	} else if (ti < (60 * 60 * 24 * 2) ) {
		int diff = round(ti / 60 / 60);
		return [NSString stringWithFormat:@"%d hrs ago", diff];
	} else if (ti < 2629743) {
		int diff = round(ti / 60 / 60 / 24);
		return [NSString stringWithFormat:@"%d days ago", diff];
	} else {
		return @"A week ago";
	}
}

+ (long long)unixTimestampCurrentTime
{
	long long timestamp = (1000000 *[NSDate timeIntervalSinceReferenceDate]);
	return timestamp;
}

+ (BOOL)fileExists:(NSString *)stringFile
{
    
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsPath stringByAppendingPathComponent:stringFile];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
	if (fileExists) XLLog(@"file %@ exists in the documents directory", stringFile);
    
	if (fileExists) return YES;
    
	if ([stringFile rangeOfString:@"."].location != NSNotFound) {
		XLLog(@"file %@ does not exist", stringFile);
		exit(1);
		return NO;
	}
    
	NSString *fileName = [stringFile stringByDeletingPathExtension];
	NSString *fileExtension = [stringFile pathExtension];
    
	NSString *stringInBundle = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:stringInBundle];
    
	if (fileExists) XLLog(@"file %@ exists in the bundle directory", stringFile);
    
	if (fileExists) return YES;
    
	XLError(@"file %@ does not exist", stringFile);
    
	return NO;
}

+ (BOOL)intersectionPoint:(CGPoint *)pointIntersection
              SegmentAOne:(CGPoint)pointSegmentAOne
              SegmentATwo:(CGPoint)pointSegmentATwo
              SegmentBOne:(CGPoint)pointSegmentBOne
              SegmentBTwo:(CGPoint)pointSegmentBTwo
{
    
	float p0_x = pointSegmentAOne.x;
	float p0_y = pointSegmentAOne.y;
	float p1_x = pointSegmentATwo.x;
	float p1_y = pointSegmentATwo.y;
	float p2_x = pointSegmentBOne.x;
	float p2_y = pointSegmentBOne.y;
	float p3_x = pointSegmentBTwo.x;
	float p3_y = pointSegmentBTwo.y;
    
	float s1_x = p1_x - p0_x;
	float s1_y = p1_y - p0_y;
	float s2_x = p3_x - p2_x;
	float s2_y = p3_y - p2_y;
    
	float r0x, r0y;
    
	float s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
	float t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
    
	if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
		r0x = p0_x + (t * s1_x);
		r0y = p0_y + (t * s1_y);
		if (pointIntersection != nil) *pointIntersection = CGPointMake(r0x, r0y);
        
		return TRUE; // Intersection exists
	}
    
	return FALSE; // No collision
}

+ (long long unsigned int)sizeOfFileAtPath:(NSString *)path
{
	NSError *error;
    
	NSDictionary *itemAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    
	NSString *stringFileType = [itemAttributes valueForKey:@"NSFileType"];
    
	if ([stringFileType isEqualToString:@"NSFileTypeDirectory"]) {
        
		return 0;
        
	} else {
        
		if ([itemAttributes objectForKey:@"NSFileSize"]) {
			NSNumber *fileSize = [itemAttributes valueForKey:@"NSFileSize"];
			return fileSize.intValue;
		}
        
	}
    
	return 0;
}

+ (id)loadObjectWithClass:(Class)objectClass fromXIB:(NSString *)xib withOwner:(id)owner
{
	NSArray *arrayXibObjects = nil;
    
	@try {
		arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:xib owner:owner options:nil];
	}
	@catch (NSException *e)
	{
		if ([e.name isEqualToString:@"NSUnknownKeyException"]) {
			XLLog(@"The xib for %@ has a broken IB connection %@", xib, e.description);
		} else {
			[e raise];
		}
	}
    
	if (arrayXibObjects) {
		for (id object in arrayXibObjects) {
			if ([object isKindOfClass:objectClass]) return object;
		}
	}
    
	XLError(@"Failed to load class %@ from nib file: %@", NSStringFromClass(objectClass), xib);
    
	return nil;
}

+ (UIView *)loadViewWithTag:(int)tag fromXibNamed:(NSString *)xib withOwner:(id)owner
{
	NSArray *arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:xib owner:owner options:nil];
    
	if (arrayXibObjects) {
		for (id object in arrayXibObjects) {
			if ([object isKindOfClass:[UIView class]]) {
				UIView *viewLoading = (UIView *)object;
				if (viewLoading.tag == tag) return object;
			}
		}
	}
    
	XLError(@"Failed to load a view with tag %d from nib file: %@", tag, xib);
    
	return nil;
}

+ (CGRect)frameToAspectFitRect:(CGRect)rectOriginal inRect:(CGRect)rectFit
{
	if ((rectOriginal.size.height == 0) || (rectFit.size.height == 0) || (rectOriginal.size.width == 0)) {
		return rectFit;
	}
    
	float imageRatio = rectOriginal.size.width / rectOriginal.size.height;
	float viewRatio  = rectFit.size.width / rectFit.size.height;
    
	if (imageRatio < viewRatio) {
		float scale = rectFit.size.height / rectOriginal.size.height;
		float width = scale * rectOriginal.size.width;
		float topLeftX = (rectFit.size.width - width) * 0.5;
		return CGRectMake(topLeftX, 0, width, rectFit.size.height);
	} else   {
		float scale = rectFit.size.width / rectOriginal.size.width;
		float height = scale * rectOriginal.size.height;
		float topLeftY = (rectFit.size.height - height) * 0.5;
		return CGRectMake(0, topLeftY, rectFit.size.width, height);
	}
}

+ (CGPathRef)pathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	CGPathRelease(retPath);
    
	return retPath;
}

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
	int64_t delayInNanoseconds = delay * NSEC_PER_SEC;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInNanoseconds);
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

+ (NSString *)mimeTypeOfFileAtPath:(NSString *)pathFile
{
	NSURL *fileUrl = [NSURL fileURLWithPath:pathFile];
	NSURLRequest *fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:.1];
    
	NSError *error = nil;
	NSURLResponse *response = nil;
    
	[NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
    
	NSString *mimeType = [response MIMEType];
    
	NSLog(@"mime type is: %@", mimeType);
    
	return mimeType;
}

+ (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range
{
	UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
	UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
	[input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

+ (UIColor *)colorWithHexString:(NSString *)hex
{
	NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
	// String should be 6f or 8 characters
	if ([cString length] < 6) return [UIColor grayColor];
    
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
	if ([cString length] != 6) return [UIColor grayColor];
    
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
    
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
    
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
    
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
    
	return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

+ (int)limitInt:(int)anInteger toValueBetweenLowerLimit:(int)lowerLimit andUpperLimit:(int)upperLimit
{
	anInteger = (int)(fmax(lowerLimit, fmin(anInteger, upperLimit)));
	return anInteger;
}

+ (float)limitFloat:(float)f toValueBetweenLowerLimit:(float)lowerLimit andUpperLimit:(float)upperLimit
{
    float limited_f = f;
    if (limited_f < lowerLimit) limited_f = lowerLimit;
    if (limited_f > upperLimit) limited_f = upperLimit;
	return limited_f;
}

+ (void) cacheResponse:(NSDictionary *)response {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:response forKey:@"dictionaryKey"];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"KEY_FOR_CACHING_RESPONSE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *) dictionaryFromCachedResponse {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_FOR_CACHING_RESPONSE"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *responseDictionary = [unarchiver decodeObjectForKey:@"dictionaryKey"];
    [unarchiver finishDecoding];
    return responseDictionary;
}

@end

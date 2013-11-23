////////////////////////////////////////////////////////////////////////////////////////////////
//
//  XLDebug.m
//
//  Created by Christopher Larsen
//  Copyright (c) 2012 DeadRatGames. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////

#import "XLDebug.h"

#define MAX_COLUMN_WIDTH  (75)  // Limits the maximum number of characters used in the console display for function name


BOOL flareHasFired;
BOOL disableLogging;
int timesRemainingBeforeBreak;


@implementation XLDebug

+ (void)log:(NSString*)output
{
	NSLog(@"%@", output);
}

+ (void)disableLogging:(BOOL)loggingDisabled
{
	disableLogging = loggingDisabled;
}

+ (void)log:(char*)fileName
 lineNumber:(int)lineNumber
   function:(const char*)stringFunction
      input:(NSString*)input, ...
{
	if (disableLogging == YES) return;
    
	va_list argList;
	NSString *filePath, *formatStr;
    
	filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName) encoding:NSUTF8StringEncoding];
    
	va_start(argList, input);
	formatStr = [[NSString alloc] initWithFormat:input arguments:argList];
	va_end(argList);
    
	NSString *stringLine = [NSString stringWithFormat:@"<%3.0d>: ", lineNumber];
    
	NSMutableString *string_out = [NSMutableString stringWithString:[NSString stringWithFormat:@"%s", stringFunction]];
	while (string_out.length > MAX_COLUMN_WIDTH - stringLine.length) [string_out deleteCharactersInRange:NSMakeRange(string_out.length - 1, 1)];
    
	[string_out appendString:stringLine];
	[string_out appendString:formatStr];
    
	[XLDebug log:string_out];
}

+ (void)error:(char*)fileName
   lineNumber:(int)lineNumber
     function:(const char*)stringFunction
        input:(NSString*)input, ...
{
	if (disableLogging == YES) return;
    
	va_list argList;
	NSString *filePath, *formatStr;
    
	filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName) encoding:NSUTF8StringEncoding];
    
	va_start(argList, input);
	formatStr = [[NSString alloc] initWithFormat:input arguments:argList];
	va_end(argList);
    
	NSLog(@"\n\n ERROR\n  File: %s\n  Line: %d\n  File: %s\n Cause: %@ \n\n", [[filePath lastPathComponent] UTF8String], lineNumber, stringFunction, formatStr);
    
	XLBreakPoint;
    
	exit(1);
}


+ (void)assert:(int)evaluate
        output:(char*)fileName
    lineNumber:(int)lineNumber
      function:(const char*)stringFunction
         input:(NSString*)input, ...
{
	if (evaluate == TRUE) return;
    
	va_list argList;
	NSString *filePath, *formatStr;
    
	filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName) encoding:NSUTF8StringEncoding];
    
	va_start(argList, input);
	formatStr = [[NSString alloc] initWithFormat:input arguments:argList];
	va_end(argList);
    
	NSString *stringOut = [NSString stringWithFormat:@"\n\nASSERTION ERROR\n File: %s\n  Line: %d \n%s \n  Cause: %@ \n\n",
	                       [[filePath lastPathComponent] UTF8String],
	                       lineNumber,
	                       stringFunction,
	                       formatStr];
    
	[XLDebug log:stringOut];
    
	XLBreakPoint;
    
	exit(1);
}

+ (void)assert:(id)object
        output:(char*)fileName
    lineNumber:(int)lineNumber
      function:(const char*)stringFunction
{
	if (object != nil) return;
    
	NSString *filePath, *formatStr;
    
	filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName) encoding:NSUTF8StringEncoding];
    
	formatStr = @"object cannot be nil";
    
	NSString *stringOut = [NSString stringWithFormat:@"\n\nASSERTION ERROR\n File: %s\n  Line: %d \n%s \n  Cause: %@ \n\n",
	                       [[filePath lastPathComponent] UTF8String],
	                       lineNumber,
	                       stringFunction,
	                       formatStr];
    
	[XLDebug log:stringOut];
    
	XLBreakPoint;
    
	exit(1);
}

+ (void)pointer:(void*)pointer
         output:(char*)fileName
     lineNumber:(int)lineNumber
       function:(const char*)stringFunction
{
	if (pointer != nil) return;
    
	NSLog(@"XL_Assert Null Pointer");
	NSLog(@"Filename: %s", fileName);
	NSLog(@"Line: %d", lineNumber);
	NSString *filePath = [[NSString alloc] initWithBytes:fileName length:strlen(fileName) encoding:NSUTF8StringEncoding];
	NSLog(@"filePath: %@", [filePath lastPathComponent]);
    
	exit(1);
}

+ (void)trace:(const char*)stringFunction
{
	if (disableLogging == YES) return;
    
	NSString *string_out = [NSString stringWithFormat:@"%s", stringFunction];
	[XLDebug log:string_out];
}

+ (void)beacon:(NSString*)input, ...
{
	NSString *beaconString = [@">>>>>>>>>>>>>>>>>>>>>> Beacon: " stringByAppendingString : input];
	[XLDebug log:@" "];
	[XLDebug log:beaconString];
	[XLDebug log:@" "];
	[NSThread sleepForTimeInterval:1.5];
}


+ (void)flare
{
	if(flareHasFired == TRUE) return;
    
	flareHasFired = TRUE;
	[XLDebug log:@" "];
	[XLDebug log:@">>>>>>>>>>>>>>>>>>>>>> Flare"];
	[XLDebug log:@" "];
	[NSThread sleepForTimeInterval:1.5];
}

+ (void)breakAfter:(int)thisManyTimes
{
	if (timesRemainingBeforeBreak == 0) {
		timesRemainingBeforeBreak = thisManyTimes;
	}
    
	timesRemainingBeforeBreak--;
    
	if (timesRemainingBeforeBreak == 0) {
		XLBreakPoint;
	}
}

+ (void)logTransform:(CGAffineTransform)transform
{
	[XLDebug log:[NSString stringWithFormat:@"Transform: tx:%f, ty:%f, a:%f, b:%f, c:%f, d:%f ", transform.tx, transform.ty, transform.a, transform.b, transform.c, transform.d]];
}

@end





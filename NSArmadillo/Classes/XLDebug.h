////////////////////////////////////////////////////////////////////////////////////////////////
//
//  XLDebug.h
//
//  Created by Christopher Larsen
//  Copyright (c) 2012 DeadRatGames. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////

#import "XL.h"

/*
 
 XLDebug is a logging alternative to NSLog
 
 ** Console output will be formatted include File Name, Line Number and Function it was called from. **
 
 
 Compare                    Output
 -------                    ------
 NSLog(@"example");         2013-07-31 13:53:33.573 MyApp[34761:c07] example
 XLLog(@"example");         2013-07-31 13:53:33.573 MyApp[34761:c07] -[AppDelegate runAtStartup]<205>: example
 
 
 Installation:
 ============
 
 1. Include XLDebug.h and XLDebug.m in your project. Import XLDebug.h in any files where you wish to use XLDebug.
 
 Usage:
 =====
 
 1. Use XLLog(@"example"); instead of NSLog(@"example");
 2. Try some of the useful logging commands:
 
 COMMAND            EFFECT
 =======            ======
 
 XLLog              - Log some text
 XLTrace            - Log a message. Indicates the current function, line number and path by default
 XLError            - Log an error and exit
 XLAssert           - Assert the supplied condition is TRUE, if not cite the cause and break program execution
 XLBeacon           - Logs a message and pause program execution for a moment so you can see it in the log
 XLFlare            - Logs a message ONCE only and pause program execution for a moment. Flares fire one time only.
 XLDisableLogging   - Stop logging to the console until XLEnableLogging is called
 XLEnableLogging    - Resume logging to the console. By default, logging is enabled.
 XLBreakAfter       - Break program execution at this point after it has been called thisManyTimes.
 XLBreakPoint       - This inserts a programatic breakpoint.
 
 */

#if DEBUG

#define XLLog(format, ...)          [XLDebug log: __FILE__ lineNumber: __LINE__ function: __PRETTY_FUNCTION__ input: (format), ## __VA_ARGS__]
#define XLTrace                     [XLDebug trace:__PRETTY_FUNCTION__]
#define XLError(format, ...)        [XLDebug error: __FILE__ lineNumber : __LINE__ function : __PRETTY_FUNCTION__ input: (format), ## __VA_ARGS__]
#define XLAssert(eval, format, ...) [XLDebug assert: eval output: __FILE__ lineNumber: __LINE__ function: __PRETTY_FUNCTION__ input: (format), ## __VA_ARGS__]
#define XLAssertNotNil(object)      [XLDebug assert: object output: __FILE__ lineNumber: __LINE__ function: __PRETTY_FUNCTION__ ]
#define XLBeacon(format)            [XLDebug beacon: (format)]
#define XLFlare                     [XLDebug flare]
#define XLBreakAfter(format)        [XLDebug breakAfter : (format)]
#define XLEnableLogging             [XLDebug disableLogging:NO]
#define XLDisableLogging            [XLDebug disableLogging:YES]
#define XLBreakPoint                kill(getpid(), SIGSTOP)

#else

#define XLTrace
#define XLLog(format, ...)
#define XLError(format, ...)
#define XLAssert(eval, format, ...)
#define XLAssertNotNil(object)
#define XLBeacon(format)
#define XLFlare
#define XLBreakAfter(format)
#define XLEnableLogging
#define XLDisableLogging
#define XLBreakPoint

#endif

@interface XLDebug : NSObject

+ (void)trace:(const char*)stringFunction;
+ (void)log:(char*)fileName lineNumber:(int)lineNumber function:(const char*)stringFunction input:(NSString*)input, ...;
+ (void)error:(char*)fileName lineNumber:(int)lineNumber function:(const char*)stringFunction input:(NSString*)input, ...;
+ (void)assert:(int)evaluate output:(char*)fileName lineNumber:(int)lineNumber function:(const char*)stringFunction input:(NSString*)input, ...;
+ (void)assert:(id)object output:(char*)fileName lineNumber:(int)lineNumber function:(const char*)stringFunction;
+ (void)beacon:(NSString*)input, ...;
+ (void)flare;
+ (void)breakAfter:(int)thisManyTimes;
+ (void)disableLogging:(BOOL)loggingDisabled;
+ (void)logTransform:(CGAffineTransform)transform;

@end





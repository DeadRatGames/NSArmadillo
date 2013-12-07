//
//  AppDelegate.m
//  NSArmadillo
//
//  Created by Christopher Larsen on 11/1/2013.
//  Copyright (c) 2013 DeadRatGames. All rights reserved.
//

#import "AppDelegate.h"
#import "NSArmadillo.h"
#import "XL.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self attemptEmptyArrayAccess];
    
    [self attemptInsertingNilObjectIntoArray];

    XLLog(@"If you see this message: SUCCESS!");
    
    // [NSArmadillo validateAllBundleXibs];
    
    return YES;
}

- (void)attemptEmptyArrayAccess
{
    NSArray* arrayEmpty = [NSArray array];
    
    id obj1 = [arrayEmpty objectAtIndex:0 failsafe:FailsafeReturnNil];
    
    XLLog(@"obj is: %@", NSStringFromClass([obj1 class]));
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"hi" forKey:nil failsafe:FailsafeReturnNil];
}

- (void)attemptInsertingNilObjectIntoArray
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:@"hi" forKey:nil failsafe:FailsafeReturnNil];
}


@end

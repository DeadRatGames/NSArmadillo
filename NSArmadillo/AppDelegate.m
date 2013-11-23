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
    
    [self emptyArrayAccess];

    XLLog(@"Success!");
    
    [NSArmadillo validateAllBundleXibs];
    
    return YES;
}

- (void)emptyArrayAccess
{
    NSArray* arrayEmpty = [NSArray array];

//    [arrayEmpty firstObject];
    
    id obj1 = [arrayEmpty objectAtIndex:0 failsafe:FailsafeReturnNil];
    
    XLLog(@"obj is: %@", NSStringFromClass([obj1 class]));
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"hi" forKey:nil failsafe:FailsafeReturnNil];
}

@end

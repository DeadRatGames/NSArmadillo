//
//  NSArmadillo.h
//  NSArmadillo
//
//  Created by Christopher Larsen on 11/1/2013.
//  Copyright (c) 2013 DeadRatGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArmadillo : NSObject

+ (BOOL)validateAllBundleXibs;

@end

typedef id (^ObjectReturned)(void);

#define FailsafeReturnNil           nil

@interface NSObject (Armadillo)
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay failsafe:(void(^)(void))blockFailsafe;
@end

@interface NSArray (Armadillo)
- (id)objectAtIndex:(NSUInteger)index failsafe:(void(^)(void))blockFailsafe;
- (id)objectAtIndex:(NSUInteger)index expectedClass:(Class)classExpected;
@end

@interface NSMutableArray (Armadillo)
- (void)addObject:(id)anObject failsafe:(void(^)(void))blockFailsafe;
@end

@interface NSMutableDictionary (Armadillo)
- (void)setObject:(id)value forKey:(NSString *)key failsafe:(void(^)(void))blockFailsafe;
- (id)objectForKey:(id)aKey expectedClass:(Class)classExpected;
@end

@interface NSNotificationCenter (Armadillo)
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject failsafe:(void(^)(void))blockFailsafe;
@end

@interface UIControl (Armadillo)
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents failsafe:(void(^)(void))blockFailsafe;
@end

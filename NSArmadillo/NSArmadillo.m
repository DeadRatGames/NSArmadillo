//
//  NSArmadillo.m
//  NSArmadillo
//
//  Created by Christopher Larsen on 11/1/2013.
//  Copyright (c) 2013 DeadRatGames. All rights reserved.
//

#import "NSArmadillo.h"

@implementation NSArmadillo

#pragma mark - Nibs

+ (BOOL)validateAllBundleXibs
{
    NSArray* arrayMainXibFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"nib" inDirectory:nil];
    
    NSLog(@"Found %d xib files", arrayMainXibFiles.count);
    
    BOOL badNibFound = NO;
    
    for (NSURL* url in arrayMainXibFiles) {
     
        NSArray *arrayXibObjects = nil;
        @try {
            arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:url.lastPathComponent owner:nil options:nil];
        }
        @catch (NSException *e)
        {
            if ([e.name isEqualToString:@"NSUnknownKeyException"] || [e.name isEqualToString:@"NSInternalInconsistencyException"]) {
                NSLog(@"The xib for %@ has a broken IB connection %@", url.lastPathComponent, e.description);
                badNibFound = NO;
            } else {
                [e raise];
            }
        }
        arrayXibObjects = nil;
    }
    
    if (badNibFound) {
        exit(1);
    }
    
}

@end

#pragma mark - NSObject

@implementation NSObject (Armadillo)

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay failsafe:(void(^)(void))blockFailsafe
{
    if ([self respondsToSelector:aSelector]) {
        [self performSelector:aSelector withObject:anArgument afterDelay:delay];
    } else {
        if (blockFailsafe) {
            blockFailsafe();
        }
    }
}

@end

#pragma mark - NSArray

@implementation NSArray (Armadillo)

- (id)objectAtIndex:(NSUInteger)index failsafe:(void (^)(void))blockFailsafe
{
    if (index >= self.count) {
        if (blockFailsafe) {
            blockFailsafe();
        }
        return nil;
    }
    return [self objectAtIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index expectedClass:(Class)classExpected
{
    id object = [self objectAtIndex:index failsafe:nil];
    if ([object isKindOfClass:classExpected]) {
        return object;
    }
    return nil;
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (Armadillo)

- (void)addObject:(id)anObject failsafe:(void(^)(void))blockFailsafe
{
    if (anObject) {
        [self addObject:anObject];
    } else {
        if (blockFailsafe) {
            blockFailsafe();
        }
    }
}

@end

#pragma mark - NSMutableDictionary

@implementation NSMutableDictionary (Armadillo)

- (void)setObject:(id)object forKey:(NSString *)key failsafe:(void(^)(void))blockFailsafe
{
    if (key) {
        [self setObject:object forKey:key];
    } else {
        if (blockFailsafe) {
            blockFailsafe();
        }
    }
}

- (id)objectForKey:(id)aKey expectedClass:(Class)classExpected
{
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:classExpected]) {
        return object;
    }
    return nil;
}

@end

#pragma mark - NSNotificationCenter

@implementation NSNotificationCenter (Armadillo)

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject failsafe:(void(^)(void))blockFailsafe
{
    if ([observer respondsToSelector:aSelector]) {
        [self addObserver:observer selector:aSelector name:aName object:anObject];
    } else {
        if (blockFailsafe) {
            blockFailsafe();
        }
    }
}

@end

#pragma mark - UIControl

@implementation UIControl (Armadillo)
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents failsafe:(void(^)(void))blockFailsafe
{
    if ([target respondsToSelector:action]) {
        [self addTarget:target action:action forControlEvents:controlEvents];
    } else {
        if (blockFailsafe) {
            blockFailsafe();
        }
    }
}

@end


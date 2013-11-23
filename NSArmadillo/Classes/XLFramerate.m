////////////////////////////////////////////////////////////////////////////////////////////////
//
//  XL_Framerate.m
//
//  Created by Christopher Larsen
//
////////////////////////////////////////////////////////////////////////////////////////////////

#import "XLFramerate.h"


@implementation XL_Framerate

// ---------------------------------------------------------------------------------------------
+ (XL_Framerate *)showFramerate:(UIView *)view
{
    
	if (framerate == nil) {
		framerate = [[XL_Framerate alloc] initWithFrame:CGRectMake(10, 10, 80, 24)];
		[view addSubview:framerate];
		[framerate tick];
	}
	return framerate;
}

// ---------------------------------------------------------------------------------------------
+ (void)hideFramerate
{
	[framerate removeFromSuperview];
}

// ---------------------------------------------------------------------------------------------
+ (XL_Framerate *)framerate
{
	if (framerate) return framerate;
	return nil;
}

// ---------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    
	self = [super initWithFrame:frame];
	if (self) {
		arrayTicks = [[NSMutableArray alloc] initWithCapacity:0];
		[self setFont:[UIFont systemFontOfSize:16]];
		[self setBackgroundColor:[UIColor blueColor]];
		[self setTextColor:[UIColor whiteColor]];
		[self setShadowColor:[UIColor blackColor]];
		self.shadowOffset = CGSizeMake(1, 1);
		self.textAlignment = NSTextAlignmentCenter;
		self.numberOfLines = 1;
		self.adjustsFontSizeToFitWidth = YES;
	}
	return self;
}

// ---------------------------------------------------------------------------------------------
- (void)tick
{
    
	if (dateLastTick) {
        
		NSTimeInterval timeSinceLastTick = [[NSDate date] timeIntervalSinceDate:dateLastTick];
		NSNumber *numberTick = [NSNumber numberWithDouble:timeSinceLastTick];
		[arrayTicks insertObject:numberTick atIndex:0];
        
#ifdef  ARC_DISABLED
		[dateLastTick release];
#endif
        
		dateLastTick = [NSDate date];
        
#ifdef ARC_DISABLED
		[dateLastTick retain];
#endif
        
		if ([arrayTicks count] > 15) {
			float fps = 0.0;
			for (NSNumber *num in arrayTicks) fps += [num doubleValue];
			fps /= [arrayTicks count];
			fps = 1.0 / fps;
			[self setText:[NSString stringWithFormat:@"FPS: %0.0f", fps]];
			if (fps < 20) [self setTextColor:[UIColor redColor]];
			else [self setTextColor:[UIColor whiteColor]];
			[arrayTicks removeAllObjects];
		}
        
	} else {
        
		[arrayTicks removeAllObjects];
		dateLastTick = [NSDate date];
        
#ifdef ARC_DISABLED
		[dateLastTick retain];
#endif
        
		[self setText:@" "];
        
	}
    
	[self performSelector:@selector(dirty)withObject:self afterDelay:1.0f / 60];
    
}

// ---------------------------------------------------------------------------------------------
- (void)layoutSubviews
{
	[self tick];
	[super layoutSubviews];
}

// ---------------------------------------------------------------------------------------------
- (void)dirty
{
	[self setNeedsLayout];
}

@end

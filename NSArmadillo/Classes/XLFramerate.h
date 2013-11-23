//////////////////////////////////////////////////////////////////////////////////////////////// 
//
//  XL_Framerate.h
//
//  Created by Christopher Larsen
//
//////////////////////////////////////////////////////////////////////////////////////////////// 

#import "XL.h"

/*      How to use XL_Framerate
 
  1. Include XL.h anywhere you want to use it
  2. Call showFramerate and give it the UIView you want the FPS marker on, like this: [XL_Framerate showFramerate: viewYouWantToAddItTo];
  3. The XL_Framerate object is just a subclass of UILabel so you can modify it's appearance like a standard UILabel
  4. Kill it by removing it from the host view, or by calling:  [XL_Framerate hideFramerate];
  5. Note if you are using/not using ARC, you either need to include XL_ArcCompatibility.h which takes care of it all for you or you need to hard code the release/retains that ArcCompatability nerfs.
 
 */

@interface XL_Framerate : UILabel {
  
  NSMutableArray* arrayTicks;
  NSDate* dateLastTick;
}

+(XL_Framerate*) showFramerate:(UIView*)view;
+(XL_Framerate*) framerate;
+(void) hideFramerate;
-(void) tick;

@end


XL_Framerate* framerate;
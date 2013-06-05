//
//  UIView+Snapshot.m
//  Sketchy
//
//	A category extension to the UIView class so you can take a UIImage snapshot of it
//

/*
 The MIT License
 
 This is a version of the popular kids Etcha-A-Sketch game. I wrote this app originally for 
 sale in the App Store, where it eventually ended up. However, I thought the game was old enough 
 to be out of copyright. I was wrong and they (The Ohio Art Company, and Freeze Tag) told me so 
 and I pulled it.
 
 It is important to note that this is still the case. You cannot, you must not, try to release 
 this app or they will, quite rightly, try to sue you. This is code that has just sat idle on my 
 computer and so it might as well get out there and be of use to people learning how to program for iOS. 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE. 
 */


#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

// TODO: should be in UIScreen+Scale
+(CGFloat)screenScale {
	UIScreen *screen = [UIScreen mainScreen];
	
	if([screen respondsToSelector:@selector(scale)]) {
		return (screen.scale);
	} else {
		return 1;
	}
}

-(UIImage*)takeSnapshot {
	UIImage* image = nil;
	
	@try {
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		
		CGFloat viewWidth, 
				viewHeight;
		
		switch([[UIDevice currentDevice] orientation]) {
			default:
			case UIDeviceOrientationPortrait:
			case UIDeviceOrientationPortraitUpsideDown:
				viewWidth = self.frame.size.width;
				viewHeight = self.frame.size.height;
				break;
				
			case UIDeviceOrientationLandscapeLeft:
			case UIDeviceOrientationLandscapeRight:
				viewWidth = self.frame.size.height;
				viewHeight = self.frame.size.width;
				break;
		}		
		
		CGFloat scale = [UIView screenScale];
		CGContextRef context = CGBitmapContextCreate(NULL, 
													 viewWidth * scale, 
													 viewHeight * scale, 
													 8, 
													 4 * (viewWidth * scale), 
													 colorSpace, 
													 kCGImageAlphaPremultipliedFirst);
		
		CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, viewHeight);
		
		CGContextConcatCTM(context, flipVertical);
		
		[self.layer renderInContext:context];
		
		CGImageRef imageRef = CGBitmapContextCreateImage(context);
		
		image = [UIImage imageWithCGImage:imageRef];
		
		CGImageRelease(imageRef);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
	} 
	@catch (NSException * e) {
		image = nil;
	}
	
	return image;
}

@end

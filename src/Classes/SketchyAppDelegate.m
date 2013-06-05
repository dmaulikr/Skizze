//
//  SketchyAppDelegate.m
//  Sketchy
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


#import "SketchyAppDelegate.h"
#import "SketchyViewController.h"

@implementation SketchyAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -

+(NSString*)documentsDirectory {
	NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(	NSDocumentDirectory,
																NSUserDomainMask,
																YES);
	
	return [arrayPaths objectAtIndex:0];
}

+(NSString*)stringByReplacingUserInterfaceIdiomPlaceholder:(NSString*)str {
	UIDevice *device = [UIDevice currentDevice];
	
	if([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		switch (device.userInterfaceIdiom) {
			default:
			case UIUserInterfaceIdiomPhone:
				return [str stringByReplacingOccurrencesOfString:@"{idiom}" withString:@"phone" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
				break;
				
			case UIUserInterfaceIdiomPad:
				return [str stringByReplacingOccurrencesOfString:@"{idiom}" withString:@"pad" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
				break;
		}
	} else {
		return [str stringByReplacingOccurrencesOfString:@"{idiom}" withString:@"phone" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
	}
}

+(BOOL)isPhoneIdiom {
	UIDevice *device = [UIDevice currentDevice];
	
	if([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		return (device.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
	} else {
		return YES;
	}
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
	
	[viewController loadCurrentState];
	
    [window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// TODO: ideallt we should be releasing resources here
	[viewController loadCurrentState];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[viewController saveCurrentState];
	[viewController releaseCurrentState];
}

-(void)applicationWillTerminate:(UIApplication *)application {
	//[viewController saveCurrentState];
	//[viewController releaseCurrentState];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

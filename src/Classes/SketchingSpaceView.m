//
//  SketchingSpaceView.m
//  Sketchy
//
//	A quick check using sizeof shows each of these is 12 bytes, which is not bad. But each twist of the dials makes
//	one of these, so we could end up with alot. We probably need a method that normalises them down to just the minimum 
//	movements that describe the shape. So x+1,x+1,x+1,y+1 becomes x+3,y+1.

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


#import "SketchingSpaceView.h"
#import "StylusMove.h"

@implementation SketchingSpaceView

@synthesize showCurrentPointOnNextDisplay, stylusColor, stylusPoints;

#pragma mark -

-(BOOL)addStylusPositionChangeXMovement:(NSInteger)xMovement yMovement:(NSInteger)yMovement {
	CGPoint newPoint = CGPointMake(currentPoint.x + xMovement, currentPoint.y + yMovement);
	
	if(newPoint.x > 0 && newPoint.x < self.frame.size.width && newPoint.y > 0 && newPoint.y < self.frame.size.height) {
		StylusMove* stylusPoint = [[StylusMove alloc] initWithXMovement:xMovement yMovement:yMovement];

		@synchronized(stylusPoints) {
			[stylusPoints addObject:stylusPoint];
		}
		
		[stylusPoint release];
		
		[self setNeedsDisplay];
		
		return YES;
	} else {
		NSLog(@"Off screen point, ignoring");
	}
	
	return NO;
}

-(BOOL)undo {
	if([stylusPoints count] > 0) {
		@synchronized(stylusPoints) {
			[stylusPoints removeLastObject];
		}
		
		[self setNeedsDisplay];	
		
		return YES;
	}
	
	return NO;
}

-(void)clear {
	NSLog(@"clear");
	
	if([stylusPoints count] > 0) {
		@synchronized(stylusPoints) {
			[stylusPoints removeAllObjects];
		}
		[self setNeedsDisplay];	
	}	
}

#pragma mark -

-(void)didMoveToSuperview {
	currentPoint = self.center;
}

#pragma mark -

-(void)initialization {
	// Initialization code
	stylusPoints = [[NSMutableArray alloc] init];
	self.stylusColor = [UIColor blackColor];
		
	//currentPoint = CGPointMake(roundf(self.frame.size.width / 2.0),roundf(self.frame.size.height / 2.0));
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self initialization];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		[self initialization];
	}
	
	return self;
}

#pragma mark -

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	if([stylusPoints count] > 0) {
		// Drawing code
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		if (context) {			
			CGContextSaveGState(context);
			
			CGContextSetLineWidth(context, 0.5);
			CGContextSetStrokeColorWithColor(context, stylusColor.CGColor);					

			CGPoint point = self.center;

			CGContextMoveToPoint(context, point.x, point.y);
			
			// make sure we do not add any more points/clear it whilst we are trying to draw it
			@synchronized(stylusPoints) {
				for(StylusMove* stylusPoint in stylusPoints) {
					//NSLog(@"%@", stylusPoint);
					
					point.x += stylusPoint.xMovement;
					point.y += stylusPoint.yMovement;

					CGContextAddLineToPoint(context, point.x, point.y);
				}
			}
			
			currentPoint = point;
			
			CGContextStrokePath(context);
			
			if(showCurrentPointOnNextDisplay) {
				showCurrentPointOnNextDisplay = NO;
				
				CGContextSetFillColorWithColor(context, stylusColor.CGColor);			
				CGContextSetAlpha(context, 0.6);
				CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
				CGContextAddArc(context, currentPoint.x, currentPoint.y, 10, 360, 0, 1);
				CGContextFillPath(context);
			}
			
			CGContextRestoreGState(context);
		}		
	}
}

- (void)dealloc {
	[stylusPoints release];
	[stylusColor release];
	
    [super dealloc];
}


@end

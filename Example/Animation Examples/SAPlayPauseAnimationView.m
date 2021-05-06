//
//  SAPlayPauseAnimationView.m
//  AnimationExamples
//
//  Created by Emilio Peláez on 8/12/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SAPlayPauseAnimationView.h"
#import "CGMath.h"

@implementation SAPlayPauseAnimationView

-(void)initializeView{
	self.behavior = SAAnimationBehaviorPingPong;
	self.duration = 0.5;
	
	self.playing = YES;
	
	self.backgroundColor = [UIColor clearColor];
	
	self.behaviorDelay = .25;
}

-(void)drawRect:(CGRect)rect{
	CGFloat yDifference = CGRectGetHeight(rect)/2 * self.inverseProgress;
	
	UIBezierPath *path = [UIBezierPath new];
	[path moveToPoint:rect.origin];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinX(rect) + yDifference)];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - yDifference)];
	[path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
	[path closePath];
	
	[path fill];
	
	if(self.progress > .1){
		UIBezierPath *clearPath = [UIBezierPath bezierPathWithRect:CGRectMakeWithCenterAndSize(CGRectGetCenter(rect), CGSizeMake(self.progress * .2 * CGRectGetWidth(rect), CGRectGetHeight(rect)))];
		[clearPath fillWithBlendMode:kCGBlendModeClear alpha:1];
	}
}

@end

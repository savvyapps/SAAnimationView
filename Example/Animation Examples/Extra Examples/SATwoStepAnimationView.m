//
//  SATwoStepAnimationView.m
//  AnimationExamples
//
//  Created by Emilio Peláez on 5/27/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SATwoStepAnimationView.h"

CGFloat lerp(CGFloat a, CGFloat b, CGFloat t){
	return a + (t * (b - a));
}

@implementation SATwoStepAnimationView

-(void)initializeView{
	self.behavior = SAAnimationBehaviorPingPong;
	self.duration = 2;
	
	self.playing = YES;
}

-(void)drawRect:(CGRect)rect{
	CGFloat localP;
	
	CGFloat thirdY = CGRectGetHeight(rect) / 3;
	CGFloat thirdMin = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 3;
	CGFloat fourthMin = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 4;
	
	[[UIColor blueColor] setFill];
	
	if(self.progress < .5){
		localP = [self normalizeProgressWithSliceOffset:0 andSliceDuration:.5];
		UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect)/2, lerp(thirdY * 2, thirdY, localP))
																												radius:fourthMin
																										startAngle:0
																											endAngle:2 * M_PI
																										 clockwise:YES];
		
		[path fill];
	}else{
		localP = [self normalizeProgressWithSliceOffset:.5 andSliceDuration:.5];
		UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect)/2, thirdY)
																												radius:lerp(fourthMin, thirdMin, localP)
																										startAngle:0
																											endAngle:2 * M_PI
																										 clockwise:YES];
		
		[path fill];
	}
}

@end

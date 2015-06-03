//
//  SACircleFillAnimationView.m
//  AnimationExamples
//
//  Created by Emilio Peláez on 5/20/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SACircleFillAnimationView.h"

@implementation SACircleFillAnimationView

-(void)initializeView{
	self.behavior = SAAnimationBehaviorPingPong;
	self.duration = 1;
	
	self.playing = YES;
}

-(void)drawRect:(CGRect)rect {
	[[UIColor blueColor] setStroke];
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
																														radius:CGRectGetWidth(rect)/2 - 4
																												startAngle:0
																													endAngle:2*M_PI*self.progress
																												 clockwise:YES];
	circlePath.lineWidth = 4;
	[circlePath stroke];
}

@end

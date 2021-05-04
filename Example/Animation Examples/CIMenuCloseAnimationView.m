//
//  CIMenuCloseAnimationView.m
//  AnimationTest
//
//  Created by Emilio Peláez on 3/2/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "CIMenuCloseAnimationView.h"

typedef CGFloat (^EasingFunction)(CGFloat);

EasingFunction EaseInBack = ^CGFloat (CGFloat p) {
	return p * p * p - p * sin(p * M_PI);
};

EasingFunction EaseOutCircular = ^CGFloat (CGFloat p) {
	return sqrt((2 - p) * p);
};

@implementation CIMenuCloseAnimationView

+(CGSize)preferredSize{
	return CGSizeMake(30, 30);
}

-(void)initializeView{
	self.behavior = SAAnimationBehaviorPingPong;
	self.duration = 1;
	
	self.playing = YES;
	
	self.behaviorDelay = .5;
	
	self.backgroundColor = [UIColor clearColor];
	
//	self.transform = CGAffineTransformMakeScale(2, 2);
}

-(void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	UIColor *color = [UIColor colorWithWhite:.25 alpha:1];
	[color setFill];
	[color setStroke];
	CGContextSetLineWidth(c, 4);
	
	if(self.progress < .5){
		CGFloat localT = [self normalizeProgressWithSliceOffset:0 andSliceDuration:.5];
		localT = EaseInBack(localT);
		
		CGFloat barOffsetX = 6;
		CGFloat barHeight = 4;
		CGFloat barWidth = rect.size.width - 2 * barOffsetX;
		
		UIColor *fillColor = [UIColor colorWithRed:localT green:0 blue:0 alpha:1];
		[fillColor setFill];
		
		CGRect middleBarRect = CGRectMake(barOffsetX, (rect.size.height - barHeight)/2, barWidth, barHeight);
		[[UIBezierPath bezierPathWithRoundedRect:middleBarRect cornerRadius:2] fill];
		
		CGFloat maxDistance = barHeight + 3;
		CGFloat currentDistance = (1 - localT) * maxDistance;
		
		CGRect topBarRect = CGRectMake(middleBarRect.origin.x, middleBarRect.origin.y - currentDistance,
																	 CGRectGetWidth(middleBarRect), CGRectGetHeight(middleBarRect));
		[[UIBezierPath bezierPathWithRoundedRect:topBarRect cornerRadius:2] fill];
		CGRect bottomBarRect = CGRectMake(middleBarRect.origin.x, middleBarRect.origin.y + currentDistance,
																			CGRectGetWidth(middleBarRect), CGRectGetHeight(middleBarRect));
		[[UIBezierPath bezierPathWithRoundedRect:bottomBarRect cornerRadius:2] fill];
		
		CGContextAddEllipseInRect(c, CGRectMake(1, middleBarRect.origin.y, barHeight, barHeight));
		CGContextAddEllipseInRect(c, CGRectMake(1, topBarRect.origin.y, barHeight, barHeight));
		CGContextAddEllipseInRect(c, CGRectMake(1, bottomBarRect.origin.y, barHeight, barHeight));
		
		CGContextFillPath(c);
	}else if(self.progress <= 1){
		CGFloat localT = [self normalizeProgressWithSliceOffset:.5 andSliceDuration:.5];
		localT = EaseOutCircular(localT);
		
		CGFloat barHeight = 4;
		CGFloat barOffsetX = 6;
		CGFloat barWidth = rect.size.width - 2 * barOffsetX;
		
		[[UIColor darkGrayColor] setFill];
		
		CGRect backgroundRect = CGRectInset(CGRectInset(rect, 1, 1),
																				(1 - localT) * rect.size.width / 2,
																				(1 - localT) * rect.size.height / 2);
		UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithOvalInRect:backgroundRect];
		[backgroundPath fill];
		
		[[UIColor redColor] setFill];
		[[UIColor redColor] setStroke];
		
		CGRect middleBarRect = CGRectMake(barOffsetX, (rect.size.height - barHeight)/2, barWidth, barHeight);
		CGPoint rectCenter = CGPointMake(CGRectGetMidX(middleBarRect), CGRectGetMidY(middleBarRect));
		
		UIBezierPath *barPath = [UIBezierPath bezierPathWithRoundedRect:middleBarRect cornerRadius:2];
		
		CGAffineTransform transform = CGAffineTransformMakeTranslation(rectCenter.x, rectCenter.y);
		transform = CGAffineTransformRotate(transform, M_PI_4 * localT);
		transform = CGAffineTransformTranslate(transform, -rectCenter.x, -rectCenter.y);
		
		[barPath applyTransform:transform];
		[barPath fill];
		
		barPath = [UIBezierPath bezierPathWithRoundedRect:middleBarRect cornerRadius:2];
		
		transform = CGAffineTransformMakeTranslation(rectCenter.x, rectCenter.y);
		transform = CGAffineTransformRotate(transform, -M_PI_4 * localT);
		transform = CGAffineTransformTranslate(transform, -rectCenter.x, -rectCenter.y);
		
		[barPath applyTransform:transform];
		[barPath fill];
		
		if(localT == 0) return;
		rectCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rectCenter.x, rectCenter.y)
																															radius:CGRectGetWidth(rect) / 2 - 3
																													startAngle:0 endAngle:(1 - MIN(localT, .999)) * 2 * M_PI clockwise:NO];
		circlePath.lineWidth = 4;
		circlePath.lineCapStyle = kCGLineCapRound;
		transform = CGAffineTransformMakeTranslation(rectCenter.x, rectCenter.y);
		transform = CGAffineTransformScale(transform, -1, 1);
		transform = CGAffineTransformTranslate(transform, -rectCenter.x, -rectCenter.y);
		[circlePath applyTransform:transform];
		[circlePath stroke];
	}
}

@end

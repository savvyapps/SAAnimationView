//
//  SATransformAnimationView.m
//  AnimationExamples
//
//  Created by Emilio Peláez on 4/29/16.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SATransformAnimationView.h"
#import "CGMath.h"

@interface SATransformAnimationView () {
	CGSize lastSize;
}

@property(nonatomic, strong) NSArray <UIView *> *circleViews;

@end

@implementation SATransformAnimationView

static int numberOfCircles = 5;

-(void)initializeView{
	NSMutableArray *temp = [NSMutableArray arrayWithCapacity:numberOfCircles];
	for(int i = 0; i < numberOfCircles; i++){
		UIView *circle = [[UIView alloc] initWithFrame:CGRectZero];
		circle.backgroundColor = [UIColor blueColor];
		[self addSubview:circle];
		circle.clipsToBounds = YES;
		[temp addObject:circle];
	}
	self.circleViews = [temp copy];
	
	self.behavior = SAAnimationBehaviorLoop;
	self.duration = 1.5;
	[self play];
	
	lastSize = CGSizeZero;
}

-(void)setNeedsLayout{
	[super setNeedsLayout];
}

-(void)layoutIfNeeded{
	[super layoutIfNeeded];
}

-(void)layoutSubviews{
	[super layoutSubviews];
	
	if(CGSizeEqualToSize(lastSize, self.bounds.size))
		return;
	lastSize = self.bounds.size;
	
	CGPoint center = CGRectGetCenter(self.bounds);
	CGFloat circleSide = MIN(self.bounds.size.width, self.bounds.size.height) / 4;
	CGSize circleSize = CGSizeMake(circleSide, circleSide);
	CGRect circleFrame = CGRectMakeWithCenterAndSize(center, circleSize);
	
	[_circleViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.frame = circleFrame;
		obj.layer.cornerRadius = circleSide / 2;
	}];
	
	[self update:0];
}

-(void)update:(CGFloat)delta{
	CGFloat circleSide = MIN(self.bounds.size.width, self.bounds.size.height) / 4;
	CGFloat angleDifference = M_PI * 2 / numberOfCircles;
	CGFloat translation = (MIN(self.bounds.size.width, self.bounds.size.height) - circleSide) / 2;
	[_circleViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CGFloat angle = (idx * angleDifference) + (self.progress * M_PI * 2);
		CGAffineTransform transform = CGAffineTransformMakeTranslation(cos(angle) * translation, sin(angle) * translation);
		obj.transform = transform;
	}];
}

@end

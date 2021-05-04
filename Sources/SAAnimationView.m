//
//  SAAnimationView.m
//  SAAnimationView
//
//  Created by Emilio Peláez on 2/26/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SAAnimationView.h"

@interface SAAnimationView (){
	NSTimeInterval currentDelay;
}

@property(nonatomic, strong) CADisplayLink *displayLink;

-(void)private_InitializeView;

-(void)runLoop:(CADisplayLink *)displayLink;

-(void)private_didFinish;
-(void)private_didLoop;
-(void)private_didPingPong;

@end

@implementation SAAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		[self private_InitializeView];
	}
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if(self){
		[self private_InitializeView];
	}
	return self;
}

-(void)private_InitializeView{
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runLoop:)];
	[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	
	if(self.duration == 0) self.duration = 1;
	if(self.speed == 0) self.speed = 1;
	
	self.playing = NO;
	
	[self initializeView];
	
	currentDelay = self.startDelay;
}

-(void)initializeView{}

-(void)runLoop:(CADisplayLink *)displayLink{
	CGFloat delta = displayLink.duration;
	
	if(currentDelay > 0){
		currentDelay -= delta;
		if(currentDelay > 0) return;
		delta = -currentDelay;
	}
	
	if(self.speed == 0) return;
	
	delta = delta * self.speed / self.duration;
	
	self.progress += delta;
	[self update:delta];
}

-(void)update:(CGFloat)delta{
	[self setNeedsDisplay];
}

-(void)setPlaying:(BOOL)playing{
	self.displayLink.paused = !playing;
}

-(BOOL)isPlaying{
	return !self.displayLink.paused;
}

-(void)setProgress:(CGFloat)progress{
	if(self.speed == 0) return;
	
	switch (self.behavior) {
		case SAAnimationBehaviorSingle:
			if((progress > 1 && self.speed > 0) || (progress < 0 && self.speed < 0)){
				self.playing = NO;
				[self private_didFinish];
			}
			_progress = MAX(0, MIN(1, progress));
			break;
		case SAAnimationBehaviorLoop:
			if(progress > 1 && self.speed > 0){
				if(self.behaviorDelay > 0){
					currentDelay = self.behaviorDelay;
					_progress = 0;
				}else{
					_progress = progress - 1;
				}
				[self private_didLoop];
			}else if(progress < 0 && self.speed < 0){
				if(self.behaviorDelay > 0){
					currentDelay = self.behaviorDelay;
					_progress = 1;
				}else{
					_progress = progress + 1;
				}
				[self private_didLoop];
			}else{
				_progress = MAX(0, MIN(1, progress));
			}
			break;
		case SAAnimationBehaviorPingPong:
			if(progress > 1 && self.speed > 0){
				if(self.behaviorDelay > 0){
					currentDelay = self.behaviorDelay;
					_progress = 1;
				}else{
					_progress = 2 - progress;
				}
				self.speed = -self.speed;
				[self private_didPingPong];
			}else if(progress < 0 && self.speed < 0){
				if(self.behaviorDelay > 0){
					currentDelay = self.behaviorDelay;
					_progress = 0;
				}else{
					_progress = -progress;
				}
				self.speed = -self.speed;
				[self private_didPingPong];
			}else{
				_progress = MAX(0, MIN(1, progress));
			}
			break;
  default:
			break;
	}
}

-(void)setDuration:(NSTimeInterval)duration{
	_duration = MAX(1.0/60, duration);
}

-(void)setStartDelay:(NSTimeInterval)startDelay{
	_startDelay = MAX(0, startDelay);
}

-(void)setBehaviorDelay:(NSTimeInterval)behaviorDelay{
	_behaviorDelay = MAX(0, behaviorDelay);
}

-(CGFloat)inverseProgress{
	return 1 - _progress;
}

-(CGFloat)normalizeProgressWithSliceOffset:(CGFloat)sliceOffset andSliceDuration:(CGFloat)sliceDuration{
	return normalizeSlice(self.progress, sliceOffset, sliceDuration);
}

-(void)play{
	self.playing = YES;
}

-(void)pause{
	self.playing = NO;
}

-(void)stop{
	self.playing = NO;
	self.progress = self.speed >= 0 ? 0 : 1;
}

-(void)playForward{
	self.speed = fabs(self.speed);
	self.playing = YES;
}

-(void)playFromBeginning{
	currentDelay = self.startDelay;
	self.speed = fabs(self.speed);
	self.progress = 0;
	self.playing = YES;
}

-(void)reverse{
	self.speed = -self.speed;
	self.playing = YES;
}

-(void)playBackwards{
	self.speed = -fabs(self.speed);
	self.playing = YES;
}

-(void)playFromEnd{
	self.progress = 1;
	self.speed = -fabs(self.speed);
	self.playing = YES;
}

-(void)private_didFinish{
	if([self.delegate respondsToSelector:@selector(animationViewDidFinish:)])
		[self.delegate animationViewDidFinish:self];
	if(self.completionBlock)
		self.completionBlock(self);
}

-(void)private_didLoop{
	if([self.delegate respondsToSelector:@selector(animationViewDidLoop:)])
		[self.delegate animationViewDidLoop:self];
	if(self.loopBlock)
		self.loopBlock(self);
}

-(void)private_didPingPong{
	if([self.delegate respondsToSelector:@selector(animationViewDidPingPong:)])
		[self.delegate animationViewDidPingPong:self];
	if(self.pingPongBlock)
		self.pingPongBlock(self);
}

@end

CGFloat normalizeSlice(CGFloat progress, CGFloat offset, CGFloat duration){
	return (progress - offset) / duration;
}

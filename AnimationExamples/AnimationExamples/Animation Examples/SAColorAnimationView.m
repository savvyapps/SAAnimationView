//
//  SAColorAnimationView.m
//
//  Created by Emilio Peláez on 3/2/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import "SAColorAnimationView.h"

@implementation SAColorAnimationView

-(void)initializeView{
	self.behavior = SAAnimationBehaviorPingPong;
	self.duration = 1;
	
	self.playing = YES;
}

-(void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	UIColor *color = [UIColor colorWithWhite:self.progress alpha:1];
	[color setFill];
	
	CGContextFillRect(c, rect);
}

@end

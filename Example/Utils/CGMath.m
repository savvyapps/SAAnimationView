//
//  CGMath.m
//
//  Created by Emilio Peláez on 7/30/11.
//  Copyright © 2011 Emilio Peláez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGMath.h"

CGFloat lerpInRange(NSRange r, CGFloat t){
	return lerp(r.location, NSMaxRange(r), t);
}

CGFloat inverseLerpInRange(NSRange r, CGFloat v){
	return inverseLerp(r.location, NSMaxRange(r), v);
}

CGFloat clampToRange(NSRange r, CGFloat v){
	return clamp(r.location, NSMaxRange(r), v);
}

CGFloat remap(CGFloat r00, CGFloat r01, CGFloat r10, CGFloat r11, CGFloat v){
	CGFloat t = inverseLerp(r00, r01, v);
	return lerp(r10, r11, t);
}

CGFloat remapFromRangeToRange(CGFloat v, NSRange r0, NSRange r1){
	CGFloat t = inverseLerpInRange(r0, v);
	return lerpInRange(r1, t);
}

#pragma mark - CGPoint

CGPoint CGPointAddBatch(CGPoint *points, NSInteger count){
	CGFloat x = 0;
	CGFloat y = 0;
	for(NSInteger i = 0; i < count; i++){
		x += points[i].x;
		y += points[i].y;
	}
	return CGPointMake(x, y);
}

CGPoint CGPointGetNormalized(CGPoint point){
	CGFloat magnitude = CGPointGetMagnitude(point);
	CGFloat x = point.x/magnitude;
	CGFloat y = point.y/magnitude;
	return CGPointMake(x, y);
}

CGPoint CGPointLerp(CGPoint v0, CGPoint v1, CGFloat t){
	CGFloat x = lerp(v0.x, v1.x, t);
	CGFloat y = lerp(v0.y, v1.y, t);
	
	return CGPointMake(x, y);
}

#pragma mark - CGSize

CGSize CGSizeMakeWithAspectRatioThatFitsSize(CGFloat ratio, CGSize size){
	CGFloat sizeRatio = CGSizeGetAspectRatio(size);
	if(ratio > sizeRatio){
		return CGSizeMake(size.width, size.width / ratio);
	}else{
		return CGSizeMake(size.height * ratio, size.height);
	}
}

CGSize CGSizeLerp(CGSize v0, CGSize v1, CGFloat t){
	CGFloat width = lerp(v0.width, v1.width, t);
	CGFloat height = lerp(v0.height, v1.height, t);
	
	return CGSizeMake(width, height);
}

#pragma mark - CGRect

CGRect CGRectMakeWithRectAndAspectRatio(CGRect rect, CGFloat ratio){
	CGPoint center = CGRectGetCenter(rect);
	CGSize size = CGSizeMakeWithAspectRatioThatFitsSize(ratio, rect.size);
	
	return CGRectMakeWithCenterAndSize(center, size);
}

CGRect CGRectMakeWithRectAndAspectRatioFromRect(CGRect rect, CGRect rectForRatio){
	CGFloat ratio = CGSizeGetAspectRatio(rectForRatio.size);
	return CGRectMakeWithRectAndAspectRatio(rect, ratio);
}

CGRect CGRectLerp(CGRect v0, CGRect v1, CGFloat t){
	CGPoint origin = CGPointLerp(v0.origin, v1.origin, t);
	CGSize size = CGSizeLerp(v0.size, v1.size, t);
	
	return CGRectMakeWithOriginAndSize(origin, size);
}

CGRect CGRectEdgeInset(CGRect rect, UIEdgeInsets insets) {
	return CGRectMake(CGRectGetMinX(rect)		+ insets.left,
										CGRectGetMinY(rect)		+ insets.top,
										CGRectGetWidth(rect)	- insets.left	- insets.right,
										CGRectGetHeight(rect)	- insets.top	- insets.bottom);
}

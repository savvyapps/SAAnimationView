//
//  SAAnimationView.h
//  SAAnimationView
//
//  Created by Emilio Peláez on 2/26/15.
//  Copyright (c) 2015 Savvy Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

/// @brief:	The behavior the animation will execute when reaching the end of the animation
typedef NS_ENUM(NSInteger, SAAnimationBehavior){
	SAAnimationBehaviorSingle,	///	Stop the animation
	SAAnimationBehaviorLoop,		///	Reset the progress to 0
	SAAnimationBehaviorPingPong	///	Set the animation in reverse
};

@class SAAnimationView;

typedef void (^SAAnimationViewBlock)(SAAnimationView *);

@protocol SAAnimationViewDelegate;

/*!
 SAAnimationView is a class that helps create very dynamic animations. It uses @c CADisplayLink
 to create a runloop and update itself every frame. The animation is performed by utilizing 
 the progress property to manually set the state of the animation, this can be done by setting
 the frame/transform of a subview, using the @c drawRect: method to draw custom content, or by
 setting any other property that would modify the way the view is rendered
 */
@interface SAAnimationView : UIView

@property(nonatomic, weak) id <SAAnimationViewDelegate> delegate;

/**	The current status of the internal @c displayLink */
@property(nonatomic, getter=isPlaying) BOOL playing;

/**
 The current progress of the animation, it's always in the range of @c[0, 1]
 Use this to determine the progress of you animation when drawing or updating any animation values 
 */
@property(nonatomic) CGFloat progress;
/** 1 - progress */
@property(nonatomic, readonly) CGFloat inverseProgress;

/**	The behavior the animation will execute when reaching the end of the animation */
@property(nonatomic) SAAnimationBehavior behavior;

/**
 Duation has to be greater than 1/60 (1 frame @ 60fps). The actual duration of the animation
 will be @code duration/abs(speed) @endcode
 */
@property(nonatomic) NSTimeInterval duration;
/**
 Speed can be a negative number. A value -1 will cause the animation to play in reverse.
 A value of 0 will pause the animation but not the @c displayLink, which means the animation
 will keep refreshing.
 */
@property(nonatomic) CGFloat speed;

//	These delays are in seconds and are not influenced by the speed
/**	The delay in seconds to wait before starting the animation */
@property(nonatomic) NSTimeInterval startDelay;
/** The delay in seconds to wait before executing the behavior at the end of the animation. Won't have any effect if behavior = Single */
@property(nonatomic) NSTimeInterval behaviorDelay;

//	These blocks will get called when the animation reaches the end, which block gets called
//	will depend on the animation behavior
/**	The block to be executed when the animation ends and behavior = Single */
@property(nonatomic, copy) SAAnimationViewBlock completionBlock;
/**	The block to be executed when the animation ends and behavior = Loop */
@property(nonatomic, copy) SAAnimationViewBlock loopBlock;
/**	The block to be executed when the animation ends and behavior = PingPong */
@property(nonatomic, copy) SAAnimationViewBlock pingPongBlock;

/**
 While your drawing code will be usually in drawRect:, you can perform some logic on 'update:' as well.
 The default implementation only calls setNeedsDisplay, if you override and don't call super you can control
 when to call setNeedsDisplay. It's recommended to only call it when there are changes to be drawn.
 @param delta The change in the progress since the last time it was called.
 */
-(void)update:(CGFloat)delta;

/**	Sets @c playing to @c true */
-(void)play;
/**	Sets @c playing to @c false */
-(void)pause;
/** Sets @c playing to @c false and resets the state of the animation @c progress will be set to 0 if @c speed is greater or equal than 0 and 1 otherwise */
-(void)stop;
/**	Sets the @c speed to the negative of its current value and @c playing to true */
-(void)reverse;
/**	Sets @c playing to @c true and the speed to its absolute value */
-(void)playForward;
/**	Same as @c playForward but also sets @c progress to 0 */
-(void)playFromBeginning;
/**	Sets @c playing @c true and the @c speed to the negative of it's absolute value */
-(void)playBackwards;
/**	Same as playBackwards but sets the progress to 1 */
-(void)playFromEnd;

@end

@interface SAAnimationView (SubclassHelpers)
/**	Override this method to set the initial values for your view */
-(void)initializeView;

/**
 No need to override this, just call it as it is
 @see @c normalizeSlice
*/
-(CGFloat)normalizeProgressWithSliceOffset:(CGFloat)sliceOffset andSliceDuration:(CGFloat)sliceDuration;

@end

/**
 This method is a helper to divide an animation into different "slices". Given a sliceOffset and
 a sliceDuration, this method will return a value of where the progress is within that slice, note
 that the return value might be outside that slice.
 
 For example, if you want to divide your animation into three slices or sub-animations, each slice
 would have a duration of 0.33; the first slice would have an offset of 0, the second would have 0.33, and
 the third one would have 0.66.
 
 If you want to normalize the total progress in the second slice, you would do
 @c normalize(progress,0.33,0.33) when progress is between 0.33 and 0.66, this will normalize the
 progress and give you a number between 0 and 1, which is a lot easier to use.
 If you use this with a progress lower than 0.33 you'll get a number lower than 0, if you use it with a
 progress greater than 0.66 you'll get a number greater than 1

 Example code:
 @code
 if(self.progress < .33){
   CGFloat normalP = normalizeSlice(self.progress, 0.00, .33);
   // Draw first step with normalP in [0,1]
 }else if(self.progress < .66){
   CGFloat normalP = normalizeSlice(self.progress, 0.33, .33);
   //	Draw second step with normalP in [0,1]
 }else{
   CGFloat normalP = normalizeSlice(self.progress, 0.66, .33);
   //	Draw third step with normalP in [0,1]
 }
 @endcode
 
 @param progress The current progress to normalize
 @param sliceOffset Where the slice will start. Has to be in the @c[0,1] range
 @param sliceDuration
 */
CGFloat normalizeSlice(CGFloat progress, CGFloat sliceOffset, CGFloat sliceDuration);

@protocol SAAnimationViewDelegate <NSObject>

@optional

/**	Get's called when behavior == SAAnimationBehaviorSingle */
-(void)animationViewDidFinish:(SAAnimationView *)view;
/**	Get's called when behavior == SAAnimationBehaviorLoop */
-(void)animationViewDidLoop:(SAAnimationView *)view;
/**	Get's called when behavior == SAAnimationBehaviorPingPong */
-(void)animationViewDidPingPong:(SAAnimationView *)view;

@end
# SAAnimationView

[![Pod Version](https://img.shields.io/cocoapods/v/SAAnimationView.svg?style=flat)](http://cocoapods.org/pods/SAAnimationView)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

`SAAnimationView` is a framework that allows you to create an animation programatically. It uses a `CADisplayLink` to update every frame whenever the animation is not paused. Savvy Apps was initially inspired to create this framework by our work on an animation in [a podcasting app for The Cato Institute](http://savvyapps.com/work/cato-institute). This framework doesn't rely on images, making it easy to change and lessening the burden on the application size. Once the basic code is in place, adding and modifying the animation curve and timing is simple.

## Features

* Pause, resume and reverse the animation
* Total control of the animation
* The duration of the animation can be adjusted without causing the animation to stutter
* Doesn't use images, reducing the application size
* Iterating on the animation is fast
* No need to re-export animation when changes are made (or ever)

### Considerations for use

* Using multiple `SAAnimationViews` in your application at the same time might negatively affect the performance of you app
* `SAAnimationView` is not an out-of-the-box solution, it requires you to implement the actual animation

## Examples of use

![Cato Audio Animation](https://dl.dropboxusercontent.com/s/ka7avtyyxija30d/cato_saanimationview.gif?dl=0 "Cato Audio Animation")

## Installation

SAAnimationView is available through [CocoaPods](http://cocoapods.org (http://cocoapods.org/)). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SAAnimationView'
```

## How to use

### Subclass SAAnimationView
To start using `SAAnimationView`, create a subclass of it and implement your animation logic. Below you will find two examples of simple animations.
```objc
@interface AnimationView : SAAnimationView
```

This example is a simple animation of an empty circle that is drawn gradually as the animation is executed.
```objc
- (void)drawRect:(CGRect)rect {
  UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
                                                            radius:CGRectGetWidth(rect) / 2 - 3
                                                        startAngle:0 endAngle:(self.progress * 2 * M_PI) clockwise:NO];
  [circlePath stroke];
}
```

If you don't want to draw your content using CoreGraphics, you can also use views to create an animation.
`SAAnimationView` has a method called `update:` that gets called every frame when the animation is not paused.

```objc
- (void)update:(CGFloat)delta {
  CGFloat scale = MAX(0.01, self.progress);
  self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
}
```

### Instantiate
You can instantiate your animation view with code like you would any other view, or through Interface Builder by adding a `UIView` element to your scene and setting the custom class to yours.

### Initialize
The best way to initialize the properties of your view is to override `initializeView` and use it to set the properties, like `behavior`, `duration`, etc. If you want your application to start playing right away you can also do it here.

## Authors / Contributions

SAAnimationView was authored by Emilio Peláez at [Savvy Apps](http://savvyapps.com). We [encourage feedback](http://savvyapps.com/contact) or pull requests. 

## License

SAAnimationView is available under the MIT license. See the LICENSE file for more info.

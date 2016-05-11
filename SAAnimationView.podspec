#
#  Be sure to run `pod spec lint SAAnimationView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "SAAnimationView"
  s.version      = "1.0.1"
  s.summary      = "The SAAnimationView framework provides a simple interface to programmatically create an animation."

  s.description  = <<-DESC
                   The SAAnimationView framework provides a simple interface to programmatically create an animation. It doesn't rely on images, giving it a few advantages over other animation frameworks. Because the framework draws the content with code instead of using images, it makes it simple to iterate on, doesn't require additional exports, and decreases the animation's burden on the size of the app.
                   Read more about SAAnimationView at http://savvyapps.com/blog/saanimationview-framework-programmatically-create-ios-animations
                   DESC

  s.homepage     = "https://github.com/savvyapps/SAAnimationView"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Emilio Peláez" => "emilio.pelaez@savvyapps.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/savvyapps/SAAnimationView.git", :tag => s.version.to_s }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "SAAnimationView", "SAAnimationView/**/*.{h,m}"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.framework  = "UIKit"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true

end

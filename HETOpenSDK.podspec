#
#  Be sure to run `pod spec lint HETOpenSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |s|

  s.name         = "HETOpenSDK"
  s.version      = "0.0.1"
  s.summary      = "H&T开放平台SDK"
  s.homepage     = "https://github.com/C-Life/clife_open_ios_sdk"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "mr.cao" => "340395573@qq.com" }
  s.source       = { :git => "https://github.com/C-Life/clife_open_ios_sdk.git", :tag => "v#{s.version}" }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.vendored_frameworks = 'Pod/Library/*.framework'

end

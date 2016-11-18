#
#  Be sure to run `pod spec lint DownJacketSearchBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "DownJacketSearchBar"
s.version      = "0.0.6"
s.summary      = 'A SearchBar For iOS'
s.license      = 'MIT'
s.platform     = :ios, '7.0'
s.ios.deployment_target = '7.0'
s.framework    = 'UIKit'
s.author       = { "snail-z" => "40460770@qq.com" }
s.source_files = 'DownJacketSearchBar/**/*.{h,m}'
s.homepage     = 'https://github.com/snail-z/DownJacketSearchBar'
s.source       = { :git => 'https://github.com/snail-z/DownJacketSearchBar.git', :tag => s.version }
s.requires_arc = true

end

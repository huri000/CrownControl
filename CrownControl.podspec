#
# Be sure to run `pod lib lint CrownControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'CrownControl'
  s.version = '0.1.1'
  s.summary = 'A Digital Crown interface inspired by the Apple Watch Digital Crown.'
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.requires_arc = true

s.description = <<-DESC
Inspired by the Apple Watch Digital Crown, CrownControl is an interface which can control scrollable content in your iOS apps.
DESC

  s.homepage = 'https://github.com/huri000/CrownControl'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Daniel Huri' => 'huri000@gmail.com' }
  s.source = { :git => 'https://github.com/huri000/CrownControl.git', :tag => s.version.to_s }

  s.source_files = 'Source/**/*'

  s.frameworks = 'UIKit'
  s.dependency 'QuickLayout', '2.1.1'
end

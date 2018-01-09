#
# Be sure to run `pod lib lint FlyAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlyAlert'
  s.version          = '3.0.1'
  s.summary          = 'A short description of FlyAlert.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
costume alert used to show alert in application 
                       DESC

  s.homepage         = 'https://github.com/yassine112/FlyAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yassine el halaoui' => 'yassine.el.halaoui1@gmail.com' }
  s.source           = { :git => 'https://github.com/yassine112/FlyAlert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FlyAlert/Classes/*.swift'
  
   s.resource_bundles = {
     'FlyAlert' => ['FlyAlert/Classes/*.xib', 'FlyAlert/Classes/*.ttf']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

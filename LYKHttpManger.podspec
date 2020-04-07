#
# Be sure to run `pod lib lint LYKHttpManger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYKHttpManger'
  s.version          = '1.0.2'
  s.summary          = '基于AFN二次封装的网络工具类'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lvyikai/LYKHttpManger'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kkk901029@163.com' => 'kkk901029@163.com' }
  s.source           = { :git => 'https://github.com/lvyikai/LYKHttpManger.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LYKHttpManger/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LYKHttpManger' => ['LYKHttpManger/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.frameworks = 'Foundation'
    s.dependency 'AFNetworking'
    s.dependency 'YYKit'

end

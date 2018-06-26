#
# Be sure to run `pod lib lint TPFDebugTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TPFDebugTool'
  s.version          = '0.1.8'
  s.summary          = 'TPFDebugTool is a debugging tool to monitor the network, view the log, collect crash log'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'TPFDebugTool is a debugging tool to monitor the network, view the log, collect crash log'

  s.homepage         = 'https://github.com/pzhtpf/TPFDebugTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pzhtpf' => 'pftian@yaduo.com' }
  s.source           = { :git => 'https://github.com/pzhtpf/TPFDebugTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TPFDebugTool/Classes/**/*'

  s.resource_bundles = {
     'TPFDebugTool' => ['TPFDebugTool/Assets/*.{storyboard,xib}']
  }
  s.prefix_header_file = "TPFDebugTool/Classes/TPFDebugTool.pch"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Aspects', '~> 1.4.1'
end

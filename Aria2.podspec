#
# Be sure to run `pod lib lint Aria2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Aria2'
  s.version          = '0.1.0'
  s.summary          = 'A Framework written in Swift to use the Aria2 JSON-RPC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Framework written in Swift to use the Aria2 JSON-RPC.
                       DESC

  s.homepage         = 'https://github.com/mfreiwald/Aria2'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Freiwald' => 'michael.freiwald@xinfo.de' }
  s.source           = { :git => 'https://github.com/mfreiwald/Aria2.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Aria2/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Aria2' => ['Aria2/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  #s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire', '~> 4.2'
  s.dependency 'Gloss', '~> 1.1'
  s.dependency 'Starscream', '~> 2.0'
end

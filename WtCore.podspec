#
# Be sure to run `pod lib lint WtCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WtCore'
  s.version          = '0.5.6'
  s.summary          = 'WtCore library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WtCore library.
blablabla private~
                       DESC

  s.homepage         = 'https://github.com/JaonFanwt/WtCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JaonFanwt' => 'fanwt883188@gmail.com' }
  s.source           = { :git => 'https://github.com/JaonFanwt/WtCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.subspec "Core" do |ss|
    ss.ios.source_files = "WtCore/Classes/**/*.{h,m}"
    ss.ios.public_header_files = "WtCore/Classes/**/*.h"
  end

  s.subspec "Observer" do |ss|
    ss.ios.source_files = "Extensions/WtObserver/**/*.{h,m}"
    ss.ios.public_header_files = "Extensions/WtObserver/**/*.h"
    ss.dependency 'WtCore/Core'
  end

  s.subspec "UI" do |ss|
    ss.ios.source_files = "Components/UI/**/*.{h,m}"
    ss.ios.public_header_files = "Components/UI/**/*.h"
    ss.dependency 'WtCore/Core'
    ss.dependency 'Masonry'
    ss.dependency 'FDFullscreenPopGesture'
  end

  s.subspec "DebugTools" do |ss|
    ss.ios.source_files = "Components/DebugTools/**/*.{h,m}"
    ss.ios.public_header_files = "Components/DebugTools/**/*.h"
    ss.dependency 'FLEX'
    ss.dependency 'KMCGeigerCounter'
    ss.dependency 'Masonry'
    ss.dependency 'WtCore/UI'
  end

  s.subspec "ThunderWeb" do |ss|
    ss.ios.source_files = "Extensions/WtThunderWeb/**/*.{h,m}"
    ss.ios.public_header_files = "Extensions/WtThunderWeb/**/*.h"
    ss.dependency 'WtCore/UI'
    ss.dependency 'WtCore/Observer'
  end

  s.subspec "Safety" do |ss|
    ss.ios.source_files = "Extensions/WtSafety/**/*.{h,m}"
    ss.ios.public_header_files = "Extensions/WtSafety/**/*.h"
    ss.dependency 'WtCore/Core'
  end
end

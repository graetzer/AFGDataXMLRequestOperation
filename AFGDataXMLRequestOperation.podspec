#
# Be sure to run `pod spec lint AFGDataXMLRequestOperation.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "AFGDataXMLRequestOperation"
  s.version      = "0.0.1"
  s.license      = 'MIT'
  s.summary      = "An extension for AFNetworking that provides an interface to parse XML using GDataXMLNode."
  s.author       = { "Simon Grätzer" => "simon@graetzer.org" }
  s.homepage     = 'https://github.com/sharpland/AFGDataXMLRequestOperation'
  s.source       = { :git => "https://github.com/sharpland/AFGDataXMLRequestOperation.git", :commit => "1643968d92caf677e225b50aed9690dfbfa2e7d4" }
  s.source_files = '*.{h,m}'
  s.dependency 'AFNetworking', '1.0RC1'
  s.dependency 'GDataXMLNode'
end


Pod::Spec.new do |s|

  s.name         = "ZxSwiftly"
  s.version      = "1.0.2"
  s.summary      = "Extension of Objective-C library."
  s.description  = <<-DESC
	This is a extension of Objective-C, which can develop swiftly.
                   DESC

  s.homepage     = "https://github.com/briceZhao/ZxSwiftly"
  s.license      = "MIT"
  s.author             = { "briceZhao" => "zx_brice@126.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/briceZhao/ZxSwiftly.git", :tag => "#{s.version}" }
  s.source_files  = 'ZxSwiftly/*.{h,m}'
  s.requires_arc = true 
  s.framework  = "UIKit"

  # s.public_header_files = "Classes/**/*.h"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

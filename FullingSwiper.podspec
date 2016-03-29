Pod::Spec.new do |s|
  s.name         = "FullingSwiper"
  s.version      = "1.0.1"
  s.summary      = "FullingSwiper is the library, entire surface wipe for `UIViewController` which you did, and `pushViewController` which can return."
  s.homepage     = "https://github.com/ikemai/FullingSwiper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "ikemai" => "ikeda_mai@cyberagent.co.jp" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ikemai/FullingSwiper.git", :tag => s.version.to_s }
  s.source_files  = "FullingSwiper/**/*.{h,swift}"
  s.requires_arc = true
  s.frameworks = "UIKit"
end


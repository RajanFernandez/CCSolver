Pod::Spec.new do |s|
  s.name         = "CCSolver"
  s.version      = "0.0.2"
  s.summary      = "A group of classes to model and solve Code Cracker style puzzle games."
  s.homepage     = "https://github.com/RajanFernandez/CCSolver"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Rajan Fernandez" => "rajan.fernandez@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/RajanFernandez/CCSolver.git", :tag => "#{s.version}" }
  s.source_files  = "CCSolver/**/*.{h,m}"
  s.resources = "CCSolver/**/*.{txt}"
  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end

Pod::Spec.new do |s|
  s.name         = "TBAquarium"
  s.version      = "0.0.3"
  s.summary      = "OR Mapper with FMDB for iOS"
  s.homepage     = "https://github.com/matsuda/TBAquarium"
  s.license      = 'MIT'
  s.author       = { "matsuda" => "kosukematsuda@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/matsuda/TBAquarium.git", :tag => s.version }
  s.source_files = 'Classes'
  s.requires_arc = true
  s.dependency 'FMDB', '~> 2.2'
end

Pod::Spec.new do |s|
  s.name = 'Stubber'
  s.version = '1.0.0'
  
  s.summary = 'Stubber - A library for stabbing HTTP requests in Swift.'
  s.homepage = 'https://github.com/mr-noone/stubber'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Aleksey Zgurskiy' => 'mr.noone@icloud.com' }
  
  s.platform = :ios, '8.0'
  
  s.source = { :git => 'https://github.com/mr-noone/stubber.git', :tag => "#{s.version}" }
  s.source_files = 'Stubber/Stubber/**/*.{swift,h,m}'
  s.swift_version = '4.1'
end

Pod::Spec.new do |s|
  s.name = 'HTTPStubber'
  s.version = '1.0.1'
  
  s.summary = 'HTTPStubber - A library for stabbing HTTP requests in Swift.'
  s.homepage = 'https://github.com/mr-noone/http-stubber'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Aleksey Zgurskiy' => 'mr.noone@icloud.com' }
  
  s.platform = :ios, '8.0'
  
  s.source = { :git => 'https://github.com/mr-noone/http-stubber.git', :tag => "#{s.version}" }
  s.source_files = 'Stubber/Stubber/**/*.{swift,h,m}'
  s.swift_version = '5.0'
end

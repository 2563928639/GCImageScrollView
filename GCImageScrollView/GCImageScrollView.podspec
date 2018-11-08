Pod::Spec.new do |s|
  s.name         = 'GCImageScrollView'
  s.version      = '0.0.1'
  s.summary      = 'An easy images scroll'
  s.description  = <<-DESC
                    Images scroll ...
                   DESC
  s.homepage     = 'https://github.com/2563928639/GCImageScrollView.git'
  s.license      = 'MIT'
  s.author       = { 'sunflower' => '2563928639@qq.com' }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/2563928639/GCImageScrollView.git', :tag=> '0.0.1'}
  s.source_files = 'GCImageScrollView/GCImageScrollView/*.{h,m}'
  s.frameworks   = 'UIKit','Foundation'
end

Pod::Spec.new do |s|

  s.name             = 'FlexBoxLayout'
  s.version          = '1.0.0'
  s.summary          = 'iOS Flexbox layout'

  s.description      = <<-DESC
                        iOS Flexbox layout.
                       DESC

  s.homepage         = 'https://github.com/carlSQ/FlexBoxLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'carl' => '835150773@qq.com' }
  s.source           = { :git => 'https://github.com/carlSQ/FlexBoxLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'FlexBoxLayout/Classes/**/*'

end

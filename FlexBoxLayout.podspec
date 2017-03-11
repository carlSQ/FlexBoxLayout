
Pod::Spec.new do |s|

  s.name             = 'FlexBoxLayout'
  s.version          = '0.8.0'
  s.summary          = 'iOS Flexbox layout'

  s.description      = <<-DESC
                        iOS Flexbox layout.
                       DESC

  s.homepage         = 'https://github.com/LPD-iOS/FlexBoxLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiang.shen' => 'qiang..shen@ele.me' }
  s.source           = { :git => 'https://github.com/LPD-iOS/FlexBoxLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'FlexBoxLayout/Classes/**/*'

end

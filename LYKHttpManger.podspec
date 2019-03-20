Pod::Spec.new do |spec|
  spec.name             = 'LYKHttpManger'
  spec.version          = '0.1.1'
  spec.summary          = '基于AFN二次封装的网络工具类'
  spec.description      = <<-DESC
        TODO: Add long description of the pod here.
                       DESC
  spec.homepage         = 'https://github.com/lvyikai/LYKHttpManger'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'kkk901029@163.com' => 'kkk901029@163.com' }
  spec.source           = { :git => 'https://github.com/lvyikai/LYKHttpManger.git', :tag => s.version.to_s }
  spec.ios.deployment_target = '9.0'
  spec.source_files = 'LYKHttpManger/Classes/**/*'
  spec.frameworks = 'Foundation'
  spec.dependency 'AFNetworking', '~> 3.2.1'
  spec.dependency 'YYKit'
end

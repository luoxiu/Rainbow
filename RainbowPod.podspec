Pod::Spec.new do |s|
  s.name                = 'RainbowPod'
  s.version             = '0.1.1'
  s.summary             = 'Color conversion and manipulation library for Swift, with no rely on UIKit/AppKit.'
  s.homepage            = 'https://github.com/luoxiu/Rainbow'

  s.license             = { type: 'MIT', file: 'LICENSE' }

  s.author              = { 'luoxiu' => 'luoxiustm@gmail.com' }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.module_name = 'Rainbow'
  
  s.swift_version = '5.0'
  
  s.source              = { git: s.homepage + '.git', tag: s.version }
  s.source_files        = 'Sources/Rainbow/**/*.swift'
end

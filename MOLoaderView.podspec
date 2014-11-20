Pod::Spec.new do |s|
s.name             = "MOLoaderView"
s.version          = "0.1.0"
s.summary          = "A very simple loader view with progress indicator and blur effect."
s.description      = <<-DESC
You can customize the loader either showing percentage and % symbol

DESC
s.homepage         = "https://github.com/orientemario/MOLoaderView"
s.screenshots     = "https://cloud.githubusercontent.com/assets/7912774/5070655/94856ca2-6e69-11e4-9a1d-ca2694a74312.gif", "https://cloud.githubusercontent.com/assets/7912774/5070667/a8dc388e-6e69-11e4-8829-edeb0fd06f42.gif"
s.license          = 'MIT'
s.author           = { "Mario Oriente" => "oriente.mario@gmail.com" }
s.source           = { :git => "https://github.com/orientemario/MOLoaderView.git", :tag => s.version.to_s }

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files  = 'Pod/Classes/MOLoaderView.{h,m}'
s.resource_bundles = {
'MOLoaderView' => ['Pod/Assets/*.png']
}

s.public_header_files = 'Classes/Pods/*.{h,m}'
s.frameworks = 'UIKit', 'Foundation'
s.dependency 'pop', '~> 1.0'
end

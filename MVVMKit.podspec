Pod::Spec.new do |spec|
  spec.name         = "MVVMKit"
  spec.version      = "0.0.1"
  spec.summary      = "MVVM Architecture Framework"
  spec.description  = <<-DESC
MVVM Architecture Framework
                   DESC

  spec.homepage     = "https://github.com/IsaAliev/"

  # spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "IsaAliev" => "isaaliev12@gmail.com" }

  spec.platform     = :ios, "11.2"

  spec.source       = { :path => "/Users/isaaliev/myLibs/MVVMKit" }

  spec.source_files  = "MVVMKit/**/*.{swift}"

  spec.swift_version = "5.0" 

  spec.dependency "SnapKit"

	spec.subspec 'RxSwift' do |sp|
		sp.dependency "RxSwift"
  	sp.source_files = 'MVVMKit/*.{swift}', 'MVVMKit/Rx/*.{swift}'
	end

	spec.subspec 'Bond' do |sp|
		sp.dependency "Bond"
  	sp.source_files = 'MVVMKit/*.{swift}', 'MVVMKit/Bond/*.{swift}'
	end

end

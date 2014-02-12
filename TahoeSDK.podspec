Pod::Spec.new do |s|
    s.name                = "TahoeSDK"
    s.version             = "0.0.1"
    s.summary             = "Tahoe SDK to add base gamification services for iOS application."
    s.license             = { :type => 'Custom', :text => 'Copyright (c) 2013 Kwarter. All rights reserved.' }
    s.homepage            = "https://github.com/kwarter/tahoe-ios-demo"
    s.authors             = { "Ludovic Landry" => "landry.ludovic+github@gmail.com" }
    s.source              = { :git => "git@github.com:kwarter/tahoe-ios-demo.git" }
    s.platform            = :ios, '6.0'
    s.source_files        = 'TahoeSDK/**/*.{h,m}'
    s.public_header_files = 'TahoeSDK/**/*.h'
    s.resources           = 'TahoeSDK/Model/TahoeModel.xcdatamodeld'
    s.prefix_header_contents = '#ifdef __OBJC__', '#import <SystemConfiguration/SystemConfiguration.h>', '#import <MobileCoreServices/MobileCoreServices.h>', '#import <TahoeSDK/TahoeSDK.h>', '#endif'
    s.requires_arc        = true
    s.dependency          'AFNetworking', '~> 1.3'
    s.dependency          'SSToolkit', '~> 1.0'
end

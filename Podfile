#inhibit_all_warnings!

target 'MacCatalyst' do
  
  platform :ios, '9.0'
  project 'MacCatalyst.xcodeproj'
  workspace 'MacCatalyst.xcworkspace'
  
end

target 'AppKitGlue' do
  
  platform :osx, '10.15'
  project 'MacCatalyst.xcodeproj'
  workspace 'MacCatalyst.xcworkspace'

  source 'https://github.com/CocoaPods/Specs.git'
  
  pod 'MASShortcut'
  
end

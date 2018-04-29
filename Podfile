# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Shevet Hamifratz Admin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shevet Hamifratz Admin
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'GradientLoadingBar', '~> 1.0'
pod 'CropViewController'
pod 'JTAppleCalendar', '~> 7.0'
pod 'Firebase/Storage'
pod 'IQKeyboardManagerSwift'



end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end

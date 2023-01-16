
platform :ios, '13.0'

target 'gymStart' do
  use_frameworks!

  # Pods for gymStart
  
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  
  pod 'DropDown'
  pod 'IQKeyboardManagerSwift'
  pod 'PKHUD', '~> 5.0'
  pod "MBCircularProgressBar"
  
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
     
#
#     # to make @IBDesignable work with IB
#     config.build_settings.delete('CODE_SIGNING_ALLOWED')
#     config.build_settings.delete('CODE_SIGNING_REQUIRED')
#     config.build_settings['CONFIGURATION_BUILD_DIR'] ='$PODS_CONFIGURATION_BUILD_DIR'
    end
   end
  end
  

  

end

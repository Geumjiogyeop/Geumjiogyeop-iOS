# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Geumjiogyeop' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Geumjiogyeop
  
  #네트워크 라이브러리
  pod 'Alamofire' , '5.1'
  
  #JSON
  pod 'SwiftyJSON'
  
  # Workaround for Cocoapods issue #7606
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

  target 'GeumjiogyeopTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GeumjiogyeopUITests' do
    # Pods for testing
    
  end

end

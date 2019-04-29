# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'RxSwiftMVVM' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Reactive Extensions
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Action'
  pod 'RxWebKit'
  pod 'APIKit'

  target 'RxSwiftMVVMTests' do
    inherit! :search_paths
    
    pod 'RxTest'
 
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
        target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
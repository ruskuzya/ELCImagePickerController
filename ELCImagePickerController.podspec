Pod::Spec.new do |s|
    s.name = 'ELCImagePickerController'
    s.version = '0.4.0'
    s.summary = 'A Multiple Selection Image Picker.'
    s.homepage = 'https://github.com/elc/ELCImagePickerController'
    s.license = {
      :type => 'MIT',
      :file => 'README.md'
    }
    s.author = {'ELC Technologies' => 'http://elctech.com'}
    s.source = {:git => 'https://github.com/elc/ELCImagePickerController.git',
    			:tag => '0.2.0'
    		   }
    s.platform = :ios, '11.0'
    s.resources = 'Classes/**/*.{xib,png}'
    s.source_files = 'Classes/ELCImagePicker/*.{h,m}'
    s.framework = 'Foundation', 'UIKit', 'Photos', 'CoreLocation'
    s.requires_arc = true
end

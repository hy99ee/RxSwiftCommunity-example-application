# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '15.0' # Uncomment this line to define a global platform for your project
use_frameworks! # Comment this line if you're not using Swift and don't want to use dynamic frameworks
inhibit_all_warnings! # Ignore all warnings from all pods

def ui_pods
    pod 'SnapKit', '5.0.1'
#    pod 'Hero', '1.6.1'
end

def rx_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxFlow'
    pod 'RxGesture'
    pod 'RxDataSources'
end

def network_pods 
    pod 'RxAlamofire', '5.7.1'
    pod 'Moya/RxSwift', '14.0.0'
end

def datababe_pods
    pod 'RealmSwift', '10.20.1'
    pod 'RxRealm', '4.0.3'
end

def utility_pods
    pod 'SwiftLint', '0.45.1'
end

# presets
def default_pods
    ui_pods
    rx_pods
    network_pods
    datababe_pods
end

def temp_pods
    ui_pods
    rx_pods
end

# init()
target 'TemplateApp' do
    temp_pods
    utility_pods
end

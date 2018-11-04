//
//  MainViewModel.swift
//  places-address-form
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 William French. All rights reserved.
//

import UIKit
import GooglePlaces

enum TemperatureType : String {
    case TemperatureTypeCelsius = "sTemperatureTypeCelsius"
    case TemperatureTypeFahrenheit = "sTemperatureTypeFahrenheit"
}

class MainViewModel {
    let kSavedTemperatureType = "TemperatureType"
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (()->())?
    
//    var location:LocationModel = LocationModel()
    
    var location: LocationModel = LocationModel() {
        didSet {
            self.updateLocation?()
        }
    }
    var updateLocation: (()->())?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }
    init() {
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    
    public func toggleTypeOfTemp(typeOfTemp : TemperatureType) {
        self.isLoading = true
        if (typeOfTemp == .TemperatureTypeFahrenheit) {
            self.setTypeOfTemp(typeOfTemp: .TemperatureTypeCelsius)
        }else if (typeOfTemp == .TemperatureTypeCelsius) {
            self.setTypeOfTemp(typeOfTemp: .TemperatureTypeFahrenheit)
        }
        self.isLoading = false
    }
    
    public func setTypeOfTemp(typeOfTemp : TemperatureType)  {
        UserDefaults.standard.set(typeOfTemp.rawValue, forKey: kSavedTemperatureType)  //Integer
    }
    
    public func getTypeOfTemp() -> TemperatureType {
        guard let typeValue:String = UserDefaults.standard.string(forKey: kSavedTemperatureType) else {
            return .TemperatureTypeCelsius
        }
        
        if (typeValue == TemperatureType.TemperatureTypeCelsius.rawValue ) {
            return .TemperatureTypeCelsius
        }
        
        return .TemperatureTypeFahrenheit
        
    }
    
    public func getTitleTypeOfTemp(typeOfTemp : TemperatureType) -> NSMutableAttributedString {
//        "°C / °F"
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0) ]
        let title = NSMutableAttributedString(string: "°C / °F", attributes: myAttribute )

        
        let mySlashRange = NSRange(location: 3, length: 1)
        title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: mySlashRange)
        
        if (typeOfTemp == .TemperatureTypeFahrenheit) {
            let myCRange = NSRange(location: 0, length: 2)
            title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: myCRange)
            
            let myFRange = NSRange(location: 5, length: 2)
            title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: myFRange)
        }else if (typeOfTemp == .TemperatureTypeCelsius) {
            let myCRange = NSRange(location: 0, length: 2)
            title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: myCRange)
            
            let myFRange = NSRange(location: 5, length: 2)
            title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: myFRange)
        }
        
        return title
    }
    
    
    @objc public func applicationDidBecomeActive() {
        // handle event
    }
    
    
    
    func convertToSelectedTempType(kevinTemp: String) -> String {
        var theTemp = kevinTemp
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        if let currentTemp = Double(kevinTemp) {
            if self.getTypeOfTemp() == .TemperatureTypeCelsius {
                //                theTemp = String(currentTemp - 273.15)
                theTemp = formatter.string(from: NSNumber.init(value: currentTemp - 273.15))!
            }else if self.getTypeOfTemp() == .TemperatureTypeFahrenheit {
                //                theTemp =  String((9.0/5.0)*(currentTemp - 273) + 32)
                theTemp = formatter.string(from: NSNumber.init(value: (9.0/5.0)*(currentTemp - 273) + 32))!
            }
        }
        return theTemp
    }
}

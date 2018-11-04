//
//  CurrentTempViewModel.swift
//  places-address-form
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 William French. All rights reserved.
//

import UIKit
import Alamofire
class CurrentTempViewModel: MainViewModel {
    
    var currentTempModel: CurrentTempModel = CurrentTempModel() {
        didSet {
            self.updateCurrentTemp?()
        }
    }
    var updateCurrentTemp: (()->())?
    
    func requetCurrentTempAtLocation(aLocation : LocationModel) {
        self.isLoading = true
        var jsonWeather = CurrentTempModel()
        if (aLocation.longitude.count == 0 || aLocation.latitude.count == 0 ){
            // No data
            self.currentTempModel = jsonWeather
            self.isLoading = false
        }else {
            let url:String = "https://api.openweathermap.org/data/2.5/weather?lat=\(aLocation.latitude)&lon=\(aLocation.longitude)&appid=\(weatherAPIKey)"
//            http://api.openweathermap.org/data/2.5/weather?lat=37.33233141&lon=-122.0312186&appid=b35ffe2e206bd29aacf1691404cfe934
            
            
            Alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                         let mainJson = JSON["main"] as! NSDictionary
                        
                        jsonWeather.temperature =  (mainJson["temp"] as! NSNumber).stringValue
                        jsonWeather.humidity =   (mainJson["humidity"] as! NSNumber).stringValue

                        self.currentTempModel = jsonWeather
                    }
                case .failure(let error):
                    print(error)
                    self.currentTempModel = jsonWeather
                }
                self.isLoading = false
            }
        }
    }

    override func applicationDidBecomeActive() {
        self.requetCurrentTempAtLocation(aLocation: self.location)
    }
    
    func getInputLocationTitle() -> String {
        return (self.location.inPutName.count > 0) ? self.location.inPutName:"Tap to search for an address..."
    }
    
    func getLocationDetail() -> String {

        return self.addFormatLocationDetail(str: location.street_number, isLast: false) +
        self.addFormatLocationDetail(str: location.route, isLast: false) +
        self.addFormatLocationDetail(str: location.locality, isLast: false) +
        self.addFormatLocationDetail(str: location.administrative_area_level_1, isLast: false) +
        self.addFormatLocationDetail(str: location.postal_code, isLast: false) +
        self.addFormatLocationDetail(str: location.country, isLast: true)
        
    }
    func addFormatLocationDetail(str:String ,isLast:Bool) -> String {
        if str.count == 0 {
                return ""
        }
        return isLast ? "\(str)":"\(str), "
    }
    
    func getTemperatureStr() -> String {
        let sum = self.convertToSelectedTempType(kevinTemp: self.currentTempModel.temperature)
        if sum.count == 0 {
            return ""
        }
        return sum+"°"
    }
    func getHumidityStr() -> String {
//        return self.currentTempModel.humidity
        let sum = self.currentTempModel.humidity
        if sum.count == 0 {
            return ""
        }
        return sum+"%"
    }
    

}

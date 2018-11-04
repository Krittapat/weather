//
//  ForecastAllDayViewModel.swift
//  MyWeather
//
//  Created by Work on 4/11/2561 BE.
//  Copyright © 2561 LearningProject. All rights reserved.
//

import UIKit
import Alamofire

class ForecastAllDayViewModel: MainViewModel {
    
    var tableLists:[ForecastModel]? = []{
        didSet {
            self.updateTableLists?()
        }
    }
    var updateTableLists: (()->())?
    
//    var forecastModel: ForecastModel = ForecastModel() {
//        didSet {
//            self.updateForecast?()
//        }
//    }
//    var updateForecast: (()->())?
    
    
    func requetForcasrTempAtLocation(aLocation : LocationModel) {
        self.isLoading = true

        var theLists: [ForecastModel] = []
        if (aLocation.longitude.count == 0 || aLocation.latitude.count == 0 ){
            // No data
//            self.currentTempModel = jsonWeather
            self.isLoading = false
        }else {
            let url:String = "https://api.openweathermap.org/data/2.5/forecast?lat=\(aLocation.latitude)&lon=\(aLocation.longitude)&appid=\(weatherAPIKey)"
//            https://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22
            
            Alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                        let lists = JSON["list"] as! NSArray
                        
                        
                        for afield in lists {
                            var jsonWeather = ForecastModel()
                            if let userInfo = afield as? [String: Any] {
                                if let main = userInfo["main"] as? [String: NSNumber] {
                                    if let temp = main["temp"] {
                                        jsonWeather.temperature = temp.stringValue
                                    }
                                    if let humidity = main["humidity"]  {
                                        jsonWeather.humidity = humidity.stringValue
                                    }
                                }
                                
                                if let timeStamp = userInfo["dt"] as? NSNumber {
                                    jsonWeather.timeStamp = timeStamp.stringValue
                                    
                                    
                                    let today = Date()
                                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
                                    if (timeStamp.doubleValue > (tomorrow?.timeIntervalSince1970)!) {
                                        continue
                                    }
                                
                                }
                                


                                
                            }
                            theLists.append(jsonWeather)
                        }
                        
                        self.tableLists = theLists
//                        self.currentTempModel = jsonWeather
                        self.isLoading = false
                    }
                case .failure(let error):
                    print(error)
//                    self.currentTempModel = jsonWeather
                    self.isLoading = false
                }
                self.isLoading = false
            }
        }
    }

    
    override func applicationDidBecomeActive() {
        self.requetForcasrTempAtLocation(aLocation: self.location)
    }
    
    func getDateFomatter() -> DateFormatter {
//        let date = Date(timeIntervalSince1970: Double(timeStr)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
//        let strDate = dateFormatter.string(from: date)
        return dateFormatter
    }
    
    func getDate(indexPath: IndexPath) -> String {
        guard let forcast = self.tableLists?[indexPath.row] else {
            return ""
        }
        
        let dateFormatter = self.getDateFomatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: Double(forcast.timeStamp)!)
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    func getTime(indexPath: IndexPath) -> String {
        guard let forcast = self.tableLists?[indexPath.row] else {
            return ""
        }
        let dateFormatter = self.getDateFomatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = Date(timeIntervalSince1970: Double(forcast.timeStamp)!)
        let strDate = dateFormatter.string(from: date)
        
        return strDate
        
    }
    func getTemp(indexPath: IndexPath) -> String {
        guard let forcast = self.tableLists?[indexPath.row] else {
            return ""
        }
        return self.convertToSelectedTempType(kevinTemp: forcast.temperature)+"°"
        
    }
    func getHumidity(indexPath: IndexPath) -> String {
        guard let forcast = self.tableLists?[indexPath.row] else {
            return ""
        }
        return forcast.humidity+"%"
    }
}

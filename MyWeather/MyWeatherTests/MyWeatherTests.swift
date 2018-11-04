//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 LearningProject. All rights reserved.
//

import XCTest
@testable import MyWeather

class MyWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveTemp() {
        let mainViewModel:MainViewModel = MainViewModel.init()
        var tempType = mainViewModel.getTypeOfTemp()
        XCTAssertTrue(tempType == TemperatureType.TemperatureTypeCelsius)
        
        mainViewModel.setTypeOfTemp(typeOfTemp: .TemperatureTypeCelsius)
        tempType = mainViewModel.getTypeOfTemp()
        XCTAssertTrue(tempType == TemperatureType.TemperatureTypeCelsius)
        
        mainViewModel.setTypeOfTemp(typeOfTemp: .TemperatureTypeFahrenheit)
        tempType = mainViewModel.getTypeOfTemp()
        XCTAssertTrue(tempType == TemperatureType.TemperatureTypeFahrenheit)
    }

}

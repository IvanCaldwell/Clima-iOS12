//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
// Module allows us to use the GPS functionality of the Apple device
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
// Conforms to the rules of the CLLOcationManagerDelegate
// Xcode didn't yell at me for not conforming to the CLLocationManagerDelegate...
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = apiKey
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        // Location manager helps us get our location.
        locationManager.delegate = self
        // We can choose between Kilometers to a few meters...
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // This method will trigger the pop up
        locationManager.requestWhenInUseAuthorization()
        // Get the GPS location in the background. Async
        locationManager.startUpdatingLocation()
        
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the weather data.")
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            } else {
                // If the response.result.isSuccess == fail, then I know that we have an error
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection Error"
            }
        }
    }
    
    
    
  
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        let tempResult = json["main"]["temp"].double
        //let locationResult = json["name"]
        weatherDataModel.temperature = Int(tempResult! - 273.17)
        // converts our json to a string data type...
        // don't know why I can't case it String()
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        cityLabel.text = weatherDataModel.city
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The last value in the array is the most recent and accuarate location
        let location = locations[locations.count - 1]
        // A better way I think to write this line of code.
        // let location = locations.last
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            // It takes a while for the stopUpdatingLocation() to complete
            // if I set the locationManager.delegate to nil, this will stop multiple
            // print statements from happening
            locationManager.delegate = nil
            print("""
                Longitude = \(location.coordinate.longitude)
                Latitude = \(location.coordinate.latitude)\n
                """)
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let params: [String: String] = ["lat" : "\(latitude)",
                                            "lon" : "\(longitude)",
                                            "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    // We couldn't obtain the location due to whatever reason. Cell service, Airplane mode, etc.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}



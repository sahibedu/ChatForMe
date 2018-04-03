//
//  Networking.swift
//  ChatMe
//
//  Created by Sultan on 03/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import Foundation
import CoreLocation
class Networking{
    static var locationValues = [String]()

    init() {
    }
    
    func returnDataParameter(userCoordinateAvaliable : CLLocationCoordinate2D) -> [String:String]{
        let data = [Network.ParameterKeys.APIKEY:Network.ParameterValues.APIKeyValue,
                    Network.ParameterKeys.latitude : "\(userCoordinateAvaliable.latitude)",
                    Network.ParameterKeys.longitude : "\(userCoordinateAvaliable.longitude)"]
        return data
    }
    
    func networkSession(userCoordinate : CLLocationCoordinate2D) -> [String]{
        URLSession.shared.dataTask(with: URLMaker(userCoordinate: userCoordinate)) { (data, response, error) in
            if error == nil{
                var parsedResult = [String:AnyObject]()
                DispatchQueue.global().async {
                    do{
                        try? parsedResult = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                        let weatherArray = parsedResult[Network.ResponseKeys.Weather]
                        let weatherDict = weatherArray![0] as! [String:AnyObject]
                        let weatherDescription = weatherDict[Network.ResponseKeys.WeatherDescription]
                        let city = parsedResult[Network.ResponseKeys.CityName]
                        Networking.locationValues.append(weatherDescription as! String)
                        Networking.locationValues.append(city as! String)
                        print(Networking.locationValues)
                        NotificationCenter.default.post(name: NSNotification.Name.ValueChanged, object: Networking.locationValues)
                    }
                } // Global Queue Ends Here
            } else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
        return Networking.locationValues
    }
    
    func URLMaker(userCoordinate : CLLocationCoordinate2D) -> URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = Network.OpenWeather.APIScheme
        urlComponents.host = Network.OpenWeather.APIHost
        urlComponents.path = Network.OpenWeather.APIPath
        urlComponents.queryItems = [URLQueryItem]()
        for (key,value) in returnDataParameter(userCoordinateAvaliable: userCoordinate){
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url!
    }
        
    func getValues() -> [String]{
        return Networking.locationValues
    }
}

extension Notification.Name{
    static let ValueChanged = Notification.Name("ValueChanged")
}




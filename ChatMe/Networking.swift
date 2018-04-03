//
//  Networking.swift
//  ChatMe
//
//  Created by Sultan on 03/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import Foundation
import CoreLocation
class Networking {
    var userCoordinateAvaliable = CLLocationCoordinate2D()
    
    init(userCoordinate : CLLocationCoordinate2D) {
        userCoordinateAvaliable = userCoordinate
        URLMaker()
    }
    
    func returnDataParameter() -> [String:String]{
        let data = [Network.ParameterKeys.APIKEY:Network.ParameterValues.APIKeyValue,
                    Network.ParameterKeys.latitude : "\(userCoordinateAvaliable.latitude)",
                    Network.ParameterKeys.longitude : "\(userCoordinateAvaliable.longitude)"]
        return data
    }
    
    func URLMaker(){
        var urlComponents = URLComponents()
        urlComponents.scheme = Network.OpenWeather.APIScheme
        urlComponents.host = Network.OpenWeather.APIHost
        urlComponents.path = Network.OpenWeather.APIPath
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key,value) in returnDataParameter(){
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        
        print(urlComponents.url as Any)
    }
}




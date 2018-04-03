//
//  NetworkingConstants.swift
//  ChatMe
//
//  Created by Sultan on 03/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import Foundation

struct Network {
    struct OpenWeather{
        static let APIScheme = "http"
        static let APIHost = "api.openweathermap.org"
        static let APIPath = "/data/2.5/weather"
    }
    struct ParameterKeys {
        static let latitude = "lat"
        static let longitude = "lon"
        static let APIKEY = "APPID"
    }
    struct ParameterValues{
        static let APIKeyValue = "152518cccf982b15e912e283fc7ef1d4"
    }
    struct ResponseKeys {
        static let Weather = "weather"
        static let CityName = "name"
        static let WeatherDescription = "description"
    }
}

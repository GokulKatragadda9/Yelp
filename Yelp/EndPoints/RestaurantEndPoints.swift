//
//  RestaurantEndPoints.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/31/21.
//

import Foundation
import NetworkClient

let APIKEY = "xxxxxxxxxxxyyyyyy"

extension EndPoint {
    static func restaurantSearch(_ queryItems: [URLQueryItem]) -> EndPoint {
        let restaurantQueryItem = URLQueryItem(name: "term", value: "restaurants")
        return EndPoint(host: "api.yelp.com", path: "/v3/businesses/search", queryItems: queryItems + [restaurantQueryItem])
    }
}

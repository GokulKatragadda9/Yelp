//
//  RestaurantsViewModel.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation
import Combine

enum RestaurantsViewState {
    case loading
    case error
    case newDataAvailable
}

typealias RestaurantsViewModel = RestaurantsFetchable & RestaurantsPresentable

protocol RestaurantsFetchable {
    var viewStatePublisher: Published<RestaurantsViewState>.Publisher { get }
    
    func fetchRestaurants()
    func fetchNextPage()
}

protocol RestaurantsPresentable {
    var restaurantsCount: Int { get }
    
    func restaurantName(for indexPath: IndexPath) -> String
    func restaurantAddress(for indexPath: IndexPath) -> String
    func restaurantPrice(for indexPath: IndexPath) -> String
    func restaurantRating(for indexPath: IndexPath) -> String
    func restaurantImageURL(for indexPath: IndexPath) -> String
}

class RestaurantsViewModelImpl: RestaurantsFetchable {
    private var dataController: RestaurantsDataController
    
    @Published var viewState: RestaurantsViewState = .loading
    var viewStatePublisher: Published<RestaurantsViewState>.Publisher {
        $viewState
    }
    
    init(dataController: RestaurantsDataController = RestaurantsDataControllerImpl()) {
        self.dataController = dataController
    }
    
    func fetchRestaurants() {
        viewState = .loading
        let coordinates = Coordinates(latitude: 42.498993, longitude: -83.367714)
        dataController.delegate = self
        dataController.fetchRestaurants(around: coordinates)
    }
    
    func fetchNextPage() {
        let coordinates = Coordinates(latitude: 42.498993, longitude: -83.367714)
        dataController.fetchRestaurants(around: coordinates)
    }
}

extension RestaurantsViewModelImpl: RestaurantsPresentable {
    var restaurantsCount: Int {
        return dataController.restaurants.count
    }
    
    func restaurantName(for indexPath: IndexPath) -> String {
        let restaurant = dataController.restaurants[indexPath.row]
        return restaurant.name
    }
    
    func restaurantAddress(for indexPath: IndexPath) -> String {
        let restaurant = dataController.restaurants[indexPath.row]
        return restaurant.address.street + " " + restaurant.address.city
    }
    
    func restaurantPrice(for indexPath: IndexPath) -> String {
        let restaurant = dataController.restaurants[indexPath.row]
        return restaurant.price?.rawValue ?? ""
    }
    
    func restaurantRating(for indexPath: IndexPath) -> String {
        let restaurant = dataController.restaurants[indexPath.row]
        return "\(restaurant.rating) " + "\u{2B50}"
    }
    
    func restaurantImageURL(for indexPath: IndexPath) -> String {
        let restaurant = dataController.restaurants[indexPath.row]
        return restaurant.imageURL
    }
}

extension RestaurantsViewModelImpl: RestaurantsDataControllerDelegate {
    func fetchError() {
        viewState = .error
    }
    
    func modelUpdated() {
        viewState = .newDataAvailable
    }
}

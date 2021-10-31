//
//  BusinessSearchDataController.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation
import NetworkClient

protocol RestaurantsDataControllerDelegate: AnyObject {
    func modelUpdated()
    func fetchError()
}

protocol RestaurantsDataController {
    var restaurants: [Business] { get }
    var delegate: RestaurantsDataControllerDelegate? { get set }
    func fetchRestaurants(around location: Coordinates)
}

class RestaurantsDataControllerImpl: RestaurantsDataController {
    var restaurants = [Business]()
    let networkClient: NetworkClient
    var totalRestaurantsAvailable: UInt = 0
    
    weak var delegate: RestaurantsDataControllerDelegate?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    convenience init() {
        self.init(networkClient: NetworkClientImpl())
    }
    
    var offset: UInt {
        return UInt(restaurants.count)
    }
    
    func fetchRestaurants(around location: Coordinates) {
        let endPoint = EndPoint.restaurantSearch(searchQueryItems(location, offset: offset))
        var urlRequest: URLRequest
        
        do {
            try urlRequest = endPoint.constructURLRequest(method: .get, body: nil, headers: [:])
            urlRequest.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        } catch let error {
            fatalError("Restaurant Search URL Construction failed: \(error.localizedDescription)")
        }

        networkClient.dataTask(with: urlRequest) { [weak self] (result: Result<BusinessSearchResponse, NetworkClientError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.restaurants.append(contentsOf: response.businesses)
                    self?.totalRestaurantsAvailable = response.total
                    self?.delegate?.modelUpdated()
                case .failure:
                    guard self?.restaurants.count == 0 else { return } //ignore error if we have restaurants
                    self?.delegate?.fetchError()
                }
            }
        }
    }
    
    private func searchQueryItems(_ location: Coordinates, offset: UInt) -> [URLQueryItem] {
        return [URLQueryItem(name: "latitude", value: "\(location.latitude)"),
                URLQueryItem(name: "longitude", value: "\(location.longitude)"),
                URLQueryItem(name: "offset", value: "\(offset)")]
    }
}

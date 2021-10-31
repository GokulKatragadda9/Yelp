//
//  RestaurantsDataSource.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/30/21.
//

import Foundation
import UIKit

class RestaurantsDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    let viewModel: RestaurantsViewModel
    let imageLoader: ImageLoader
    
    init(viewModel: RestaurantsViewModel,
         imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }
    
    convenience init(viewModel: RestaurantsViewModel) {
        self.init(viewModel: viewModel,
                  imageLoader: ImageLoaderImpl())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.restaurantsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: RestaurantTableViewCell.self)), for: indexPath) as! RestaurantTableViewCell
        configure(tableView, cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == viewModel.restaurantsCount - 1 {
                //last restaurant available in model -> fetch next page
                viewModel.fetchNextPage()
            }
            let imageURL = viewModel.restaurantImageURL(for: indexPath)
            imageLoader.loadImage(from: imageURL) {_ in }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let imageURL = viewModel.restaurantImageURL(for: indexPath)
            imageLoader.cancelLoadImage(url: imageURL)
        }
    }
    
    private func configure(_ tableView: UITableView, _ cell: RestaurantTableViewCell, for indexPath: IndexPath) {
        cell.restaurantTitle.text = viewModel.restaurantName(for: indexPath)
        cell.ratingLabel.text = viewModel.restaurantRating(for: indexPath)
        cell.priceLabel.text = viewModel.restaurantPrice(for: indexPath)
        cell.addressLabel.text = viewModel.restaurantAddress(for: indexPath)
        let imageURL = viewModel.restaurantImageURL(for: indexPath)
        
        imageLoader.loadImage(from: imageURL) { [weak cell] image in
            cell?.restaurantImageView.image = image ?? UIImage(named: "PlaceholderImage")
        }
        cell.prepareToReuse = { [weak imageLoader] in
            imageLoader?.cancelLoadImage(url: imageURL)
        }
    }
}

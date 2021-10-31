//
//  ViewController.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import UIKit

class RestaurantsViewController: ViewController<RestaurantsView> {
    var viewModel: RestaurantsViewModel
    var dataSource: UITableViewDataSource & UITableViewDataSourcePrefetching
    
    init(viewModel: RestaurantsViewModel,
         dataSource: UITableViewDataSource & UITableViewDataSourcePrefetching) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let viewModel = RestaurantsViewModelImpl()
        self.init(viewModel: viewModel,
                  dataSource: RestaurantsDataSource(viewModel: viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        viewModel.handleUpdates = updatesHandler
        viewModel.fetchRestaurants()
    }
    
    func setupTableView() {
        rootView.tableView.dataSource = dataSource
        rootView.tableView.prefetchDataSource = dataSource
        rootView.tableView.register(RestaurantTableViewCell.self,
                                    forCellReuseIdentifier: String(describing: type(of: RestaurantTableViewCell.self)))
    }
    
    func updatesHandler() {
        switch viewModel.viewState {
        case .loading:
            rootView.loadingView.startAnimating()
        case .error:
            rootView.loadingView.stopAnimating()
            rootView.errorView.isHidden = false
        case .newDataAvailable:
            rootView.loadingView.stopAnimating()
            rootView.errorView.isHidden = true
            rootView.tableView.reloadData()
        }
    }
}

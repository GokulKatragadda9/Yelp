//
//  ViewController.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import UIKit
import Combine

class RestaurantsViewController: ViewController<RestaurantsView> {
    var viewModel: RestaurantsViewModel
    var dataSource: UITableViewDataSource & UITableViewDataSourcePrefetching
    
    private var cancellables = Set<AnyCancellable>()
    
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
        subscribeToStateChange()
        viewModel.fetchRestaurants()
    }
    
    func setupTableView() {
        rootView.tableView.dataSource = dataSource
        rootView.tableView.prefetchDataSource = dataSource
        rootView.tableView.register(RestaurantTableViewCell.self,
                                    forCellReuseIdentifier: String(describing: type(of: RestaurantTableViewCell.self)))
    }
    
    func subscribeToStateChange() {
        viewModel.viewStatePublisher
            .receive(on: RunLoop.main, options: .none)
            .sink {[weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.rootView.loadingView.startAnimating()
                case .error:
                    self.rootView.loadingView.stopAnimating()
                    self.rootView.errorView.isHidden = false
                case .newDataAvailable:
                    self.rootView.loadingView.stopAnimating()
                    self.rootView.errorView.isHidden = true
                    self.rootView.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
}

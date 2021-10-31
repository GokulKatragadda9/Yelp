//
//  RestaurantsView.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation
import UIKit


class RestaurantsView: UIView {
    lazy var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let tableViewConstraints = [tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                   tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                   tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                                   tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)]
        let errorViewConstraints = [errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                    errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                    errorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                                    errorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)]
        let loadingViewConstraints = [loadingView.centerXAnchor.constraint(equalTo:centerXAnchor),
                                      loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)]
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        addSubview(errorView)
        addSubview(loadingView)
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate(tableViewConstraints + errorViewConstraints + loadingViewConstraints)
    }
    
    lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        errorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorTextLabel)
        NSLayoutConstraint.activate([errorTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     errorTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                                     errorTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
        view.isHidden = true
        return view
    }()
    
    lazy var errorTextLabel: UIView = {
        let label = UILabel()
        label.text = "Unable to load restaurants. Please try again later."
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.hidesWhenStopped = true
        return view
    }()
}

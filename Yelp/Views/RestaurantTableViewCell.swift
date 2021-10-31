//
//  RestaurantTableViewCell.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/28/21.
//

import Foundation
import UIKit


class RestaurantTableViewCell: UITableViewCell {
    var prepareToReuse: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        prepareToReuse?()
        restaurantImageView.image = UIImage(named: "PlaceholderImage")
    }
    
    func setupView() {
        addSubview(topStackView)
        selectionStyle = .none
        NSLayoutConstraint.activate([topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                                     topStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                                     topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                                     topStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                                     topStackView.heightAnchor.constraint(equalToConstant: 200),
                                     restaurantImageView.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantImageView, firstStackView, secondStackView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var firstStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantTitle, ratingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    lazy var secondStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var restaurantTitle: UILabel = {
        let title = UILabel()
        title.numberOfLines = 1
        title.font = .preferredFont(forTextStyle: .headline)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var ratingLabel: UILabel = {
        let rating = UILabel()
        rating.numberOfLines = 1
        rating.font = .preferredFont(forTextStyle: .subheadline)
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.textAlignment = .right
        return rating
    }()
    
    lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.numberOfLines = 1
        priceLabel.font = .preferredFont(forTextStyle: .subheadline)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .right
        return priceLabel
    }()
    
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 1
        addressLabel.textColor = .secondaryLabel
        addressLabel.font = .preferredFont(forTextStyle: .caption1)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()
    
    lazy var transactionsLabel: UILabel = {
        let transactionsLabel = UILabel()
        transactionsLabel.numberOfLines = 1
        transactionsLabel.font = .preferredFont(forTextStyle: .body)
        transactionsLabel.translatesAutoresizingMaskIntoConstraints = false
        return transactionsLabel
    }()
}

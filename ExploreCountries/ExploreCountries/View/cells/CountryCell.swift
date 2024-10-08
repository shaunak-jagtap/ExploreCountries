//
//  CountryCell.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

class CountryCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "CountryCell"
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholder") // Placeholder image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            // Flag ImageView
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 60),
            flagImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            // Details Label
            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with country: Country) {
        nameLabel.text = country.name
        
        var details = "Capital: \(country.capital.isEmpty ? "Information not available" : country.capital)\nCurrency: \(country.currency.isEmpty ? "Information not available" : country.currency)"
        if let population = country.population {
            let formattedPopulation = NumberFormatter.localizedString(from: NSNumber(value: population), number: .decimal)
            details += "\nPopulation: \(formattedPopulation)"
        } else {
            details += "\nPopulation: Information not available"
        }
        detailsLabel.text = details
        
        // Load flag image with caching
        if let urlString = country.media.flag, let url = URL(string: urlString) {
            ImageCache.shared.loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.flagImageView.image = (image != nil) ? image : UIImage(systemName: "globe")
                }
            }
        } else if let emblemUrlString = country.media.emblem, let emblemUrl = URL(string: emblemUrlString) {
            ImageCache.shared.loadImage(from: emblemUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.flagImageView.image = (image != nil) ? image : UIImage(systemName: "globe")
                }
            }
        } else {
            flagImageView.image = UIImage(systemName: "globe") // Placeholder image
        }
        
        // Accessibility
        flagImageView.isAccessibilityElement = true
        flagImageView.accessibilityLabel = "\(country.name) Flag"
        nameLabel.isAccessibilityElement = true
        detailsLabel.isAccessibilityElement = true
    }
    
    // MARK: - Reuse Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagImageView.image = UIImage(named: "placeholder")
        nameLabel.text = nil
        detailsLabel.text = nil
    }
}

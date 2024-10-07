//
//  CountryCell.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

class CountryCell: UITableViewCell {
    private let flagImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 60),
            flagImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with country: Country) {
        nameLabel.text = country.name
        
        var details = "Capital: \(country.capital)   \nCurrency: \(country.currency)\n"
        if let population = country.population {
            details += "Population: \(population)"
        } else {
            details += "Population: Information not available"
        }
        detailsLabel.text = details
        
        // Load flag image
        if let url = URL(string: country.media.flag) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.flagImageView.image = image
                    }
                }
            }.resume()
        } else if let emblemUrl = URL(string: country.media.emblem ?? "") {
            URLSession.shared.dataTask(with: emblemUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.flagImageView.image = image
                    }
                }
            }.resume()
        }
    }
}

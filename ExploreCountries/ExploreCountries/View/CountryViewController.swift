//
//  CountryViewController.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

class CountryViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = CountryViewModel()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = UIConstants.searchBarPlaceholder
        searchBar.backgroundColor = .systemGray6
        searchBar.autocapitalizationType = .none
        return searchBar
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(PopulationFilter.all.rawValue, for: .normal)
        button.titleLabel?.font = UIConstants.filterButtonFont
        return button
    }()
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.resultCountLabelFont
        label.textColor = UIConstants.resultCountLabelTextColor
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.leadingTrailingMargin, bottom: 0, right: UIConstants.leadingTrailingMargin)
        tableView.tableFooterView = UIView() // Remove empty cells
        return tableView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIConstants.errorLabelTextColor
        label.numberOfLines = 0
        label.font = UIConstants.errorLabelFont
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchCountries()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = UIConstants.navigationTitle
        
        searchBar.delegate = self
        searchBar.accessibilityLabel = AccessibilityLabels.searchBar
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.accessibilityLabel = AccessibilityLabels.filterButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        [searchBar, filterButton, resultCountLabel, tableView, activityIndicator, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: UIConstants.searchBarHeight),
            
            // Filter Button
            filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leadingTrailingMargin),
            filterButton.widthAnchor.constraint(equalToConstant: UIConstants.filterButtonWidth),
            filterButton.heightAnchor.constraint(equalToConstant: UIConstants.filterButtonHeight),
            
            // Result Count Label
            resultCountLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: UIConstants.elementSpacing),
            resultCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingTrailingMargin),
            resultCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leadingTrailingMargin),
            resultCountLabel.heightAnchor.constraint(equalToConstant: UIConstants.resultCountLabelHeight),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: resultCountLabel.bottomAnchor, constant: UIConstants.elementSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Error Label
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingTrailingMargin),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.leadingTrailingMargin)
        ])
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onCountriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(errorMessage)
            }
        }
        
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.updateLoadingStatus(isLoading)
            }
        }
    }
    
    // MARK: - UI Update Methods
    private func updateUI() {
        tableView.reloadData()
        resultCountLabel.text = "\(viewModel.countries.count) results found"
        errorLabel.isHidden = true
        tableView.isHidden = viewModel.countries.isEmpty
        refreshControl.endRefreshing()
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        tableView.isHidden = true
        refreshControl.endRefreshing()
        
        // Add Retry Button
        let retryButton = UIButton(type: .system)
        retryButton.setTitle(UIConstants.retryButtonTitle, for: .normal)
        retryButton.addTarget(self, action: #selector(retryFetch), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateLoadingStatus(_ isLoading: Bool) {
        if isLoading && !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        tableView.isHidden = isLoading
        errorLabel.isHidden = isLoading
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        let alertController = UIAlertController(title: UIConstants.filterByPopulationTitle, message: nil, preferredStyle: .actionSheet)
        
        PopulationFilter.allCases.forEach { filter in
            alertController.addAction(UIAlertAction(title: filter.rawValue, style: .default) { [weak self] _ in
                self?.viewModel.currentFilter = filter
                self?.filterButton.setTitle(filter.rawValue, for: .normal)
            })
        }
        
        alertController.addAction(UIAlertAction(title: UIConstants.cancelActionTitle, style: .cancel))
        
        // For iPad support
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = filterButton
            popoverController.sourceRect = filterButton.bounds
        }
        
        present(alertController, animated: true)
    }
    
    @objc private func refreshData() {
        viewModel.fetchCountries()
    }
    
    @objc private func retryFetch() {
        // Remove existing retry button if any
        view.subviews.filter { $0 is UIButton && $0 != filterButton }.forEach { $0.removeFromSuperview() }
        viewModel.fetchCountries()
    }
}

// MARK: - PopulationFilter Enum
enum PopulationFilter: String, CaseIterable {
    case all = "All"
    case lessThan1M = "< 1M"
    case lessThan5M = "< 5M"
    case lessThan10M = "< 10M"
}

// MARK: - UISearchBarDelegate
extension CountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        viewModel.applyFilterAndSearch()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CountryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        let country = viewModel.countries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    // Optional: Use UITableView.automaticDimension for dynamic cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CellConstants.cellHeight
    }
}

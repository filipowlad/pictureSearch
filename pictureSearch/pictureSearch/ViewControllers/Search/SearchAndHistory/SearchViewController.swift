//
//  SearchViewController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/4/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let cellIdentifier = "searchHistoryCell"
    
    private let apiController = ApiController.shared
    
    private var searchController: UISearchController?
    private var searchTableView: UITableView?
    
    private var searchResultsViewController = SearchResultsViewController()
    
    private var dataSource = [RealmImage]() {
        didSet {
            if oldValue != dataSource {
                searchTableView?.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        setupNavigationController()
        setupTableView()
        
        updateTable()
    }
}

//MARK: - Search delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchPhrase = searchBar.text {
            apiController.getImages(by: searchPhrase) { [weak self] response in
                guard let response = response, !response.isEmpty else {
                    self?.showErrorGettingPicturesAlert(for: searchPhrase)
                    return
                }
                
                self?.searchResultsViewController.dataSource = response
                
                guard let imageCollection = response.first else { return }
                
                self?.saveSearchResult(forPhrase: searchPhrase, and: imageCollection)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateTable()
    }
}

//MARK: - Table dataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let source = dataSource[indexPath.row]
        
        cell.setup(with: source)
        
        return cell
    }
}

//MARK: - Table delegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

typealias SearchViewControllerKeyboard = SearchViewController
extension SearchViewControllerKeyboard {
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            searchTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        searchTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

typealias SearchViewControllerTable = SearchViewController
extension SearchViewControllerTable {
    
    private func setupTableView() {
        searchTableView = UITableView(frame: view.bounds)
        searchTableView?.tableFooterView = UIView()
        
        searchTableView?.dataSource = self
        searchTableView?.delegate = self
        
        searchTableView?.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        guard let searchTableView = searchTableView else { return }
        
        view.addSubview(searchTableView)
        
        searchTableView.setConstraints(to: view)
    }
}

typealias SearchViewControllerNavigation = SearchViewController
extension SearchViewControllerNavigation {
    
    private func setupNavigationController() {
        createSearchController()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func createSearchController() {
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.delegate = self
        searchController?.searchBar.update()
    }
}

typealias SearchViewControllerUtilities = SearchViewController
extension SearchViewControllerUtilities {
    
    private func updateTable() {
        dataSource = RealmController.shared.getImages()
    }
    
    private func saveSearchResult(forPhrase searchPhrase: String, and collection: ImagesCollection) {
        ApiController.shared.getImage(for: collection.jpeg.image.urlString, with: { response in
            let fileName = UUID().uuidString
            
            FileManagerController.shared.save(data: response, for: fileName)
            RealmController.shared.saveImage(with: searchPhrase, name: fileName)
        })
    }
    
    private func showErrorGettingPicturesAlert(for searchPhrase: String) {
        let title = "Pictures were not found!"
        let message = "No pictures were found with the request – \(searchPhrase)."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchController?.isActive = false
            }
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

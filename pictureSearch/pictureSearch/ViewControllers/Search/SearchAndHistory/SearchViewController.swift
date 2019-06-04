//
//  SearchViewController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/4/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private let cellIdentifier = "searchHistoryCell"
    
    private let apiController = ApiController.shared
    
    private var searchController: UISearchController?
    private var searchTableView: UITableView?
    
    private var searchResultsViewController = SearchResultsViewController()
    
    private var dataSource: [String] = ["First", "Second", "Third", "First", "Second", "Third", "First", "Second", "Third", "First", "Second", "Third"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        setupNavigationController()
        setupTableView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchPhrase = searchBar.text {
            apiController.getImages(by: searchPhrase) { response in
                self.searchResultsViewController.dataSource = response
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let source = dataSource[indexPath.row]
        
        cell.textLabel?.text = source
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        
        searchTableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
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

//
//  SearchResultsViewController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let cellIdentifier = "searchResultCell"
    
    private var resultsTableView: UITableView?
    
    var dataSource = [ImagesCollection]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.resultsTableView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dataSource = []
    }
}

typealias SearchResultsViewControllerTable = SearchResultsViewController
extension SearchResultsViewControllerTable {
    
    private func setupTableView() {
        resultsTableView = UITableView(frame: view.bounds)
        resultsTableView?.tableFooterView = UIView()
        
        resultsTableView?.dataSource = self
        resultsTableView?.delegate = self
        
        resultsTableView?.register(SearchResultTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        guard let resultsTableView = resultsTableView else { return }
        
        view.addSubview(resultsTableView)
        
        resultsTableView.setConstraints(to: view)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let source = dataSource[indexPath.row]
        
        cell.setupImage(for: source)
        
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width / UIScreen.main.nativeScale
    }
}

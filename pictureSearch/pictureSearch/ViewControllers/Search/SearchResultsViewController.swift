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
    
    private func setupTableView() {
        resultsTableView = UITableView(frame: view.bounds)
        resultsTableView?.tableFooterView = UIView()
        
        resultsTableView?.dataSource = self
        resultsTableView?.delegate = self
        
        resultsTableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        guard let resultsTableView = resultsTableView else { return }
        
        view.addSubview(resultsTableView)
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        
        attributes.forEach { attribute in
            NSLayoutConstraint(item: resultsTableView, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0).isActive = true
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let source = dataSource[indexPath.row]
        
        cell.imageView?.downloaded(from: source.jpeg.image.urlString)
        
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//
//  SearchHistoryTableViewCell.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    private var requestImageView: UIImageView?
    private var requestLabel: UILabel?
    private var dateLabel: UILabel?
    
    private var isInitial = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isInitial {
            isInitial = false
            
            createImageView()
            createRequestLabel()
            createDateLabel()
            
            setConstraints()
        }
    }

    func setup(with realmImage: RealmImage) {
        DispatchQueue.main.async { [weak self] in
            let timeString = "\(realmImage.saveDate.getStringDate()) – \(realmImage.saveDate.getStringTime())"
            
            self?.dateLabel?.text = timeString
            self?.requestLabel?.text = realmImage.requestPhrase
            self?.requestImageView?.image = FileManagerController.shared.load(by: realmImage.requestImageName)
        }
    }
}

typealias SearchHistoryTableViewCellUI = SearchHistoryTableViewCell
extension SearchHistoryTableViewCellUI {
    
    private func createImageView() {
        requestImageView = UIImageView(frame: bounds)
        requestImageView?.contentMode = .scaleToFill
        
        guard let imageView = requestImageView else { return }
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createRequestLabel() {
        requestLabel = UILabel(frame: bounds)
        requestLabel?.textColor = .black
        requestLabel?.numberOfLines = 0
        
        guard let requestLabel = requestLabel else { return }
        
        addSubview(requestLabel)
        
        requestLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createDateLabel() {
        dateLabel = UILabel(frame: bounds)
        dateLabel?.textColor = .black
        dateLabel?.numberOfLines = 0
        
        guard let dateLabel = dateLabel else { return }
        
        addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        guard let imageView = requestImageView, let requestLabel = requestLabel, let dateLabel = dateLabel else {
            return
        }
        
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: requestLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: requestLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: requestLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 15).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: requestLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .trailing, relatedBy: .equal, toItem: requestLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
}

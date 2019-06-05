//
//  SearchResultTableViewCell.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    private var resultImageView: UIImageView?
    private var isInitial = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resultImageView?.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isInitial {
            isInitial = false
            resultImageView = UIImageView(frame: bounds)
            resultImageView?.contentMode = .scaleToFill
            
            guard let resultImageView = resultImageView else { return }
            
            addSubview(resultImageView)
            
            resultImageView.setConstraints(to: contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage(for imagesCollection: ImagesCollection) {
        let urlString = imagesCollection.jpeg.image.urlString
        
        ApiController.shared.getImage(for: urlString) { [weak self] data in
            DispatchQueue.main.async {
                self?.resultImageView?.image = UIImage(data: data)
            }
        }
    }
}

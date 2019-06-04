//
//  Utilities.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

extension UISearchBar {
    func update() {
        searchBarStyle = .minimal
        
        tintColor = .white
        barTintColor = .white
        
        isTranslucent = false
        placeholder = "Search"
    }
}

extension UIView {
    func setConstraints(to view: UIView) {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        
        attributes.forEach { attribute in
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0).isActive = true
        }
    }
}

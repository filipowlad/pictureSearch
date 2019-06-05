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

extension Date {
    func getStringDate() -> String {
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        
        return "\(day)/\(month)/\(year)"
    }
    
    func getStringTime() -> String {
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let hourString = hour < 10 ? "0" + String(hour) : String(hour)
        let minutesString = minutes < 10 ? "0" + String(minutes) : String(minutes)
        
        return "\(hourString):\(minutesString)"
    }
}

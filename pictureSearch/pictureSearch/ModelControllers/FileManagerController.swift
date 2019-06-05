//
//  FileManagerController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

class FileManagerController {
    
    static let shared = FileManagerController()
    
    private init() {}
    
    func save(data: Data, for fileName: String) {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
        } catch {
            print("Error oqured")
        }
    }
    
    func load(by fileName: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let url = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(fileName).path
            return UIImage(contentsOfFile: url)
        }
        
        return nil
    }
}

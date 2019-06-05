//
//  RealmController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/5/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImage: Object {
    @objc dynamic var requestPhrase = ""
    @objc dynamic var requestImageName = ""
    @objc dynamic var saveDate = Date()
}

class RealmController {
    
    static let shared = RealmController()
    
    private init() {}
    
    func saveImage(with phrase: String, name: String) {
        guard let realm = try? Realm() else { return }
        
        do {
            try realm.write {
                let realmImage = RealmImage()
                
                realmImage.requestPhrase = phrase
                realmImage.requestImageName = name
                realmImage.saveDate = Date()
                
                realm.add(realmImage)
            }
        } catch {
            print("Error")
        }
    }
    
    func getImages() -> [RealmImage] {
        guard let realm = try? Realm() else { return [] }
        
        let images = realm.objects(RealmImage.self)
        let imagesResult = images.sorted(by: {$0.saveDate > $1.saveDate})
        
        return imagesResult
    }
}

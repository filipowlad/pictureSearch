//
//  AppDelegate.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/4/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareInitialVC()
        
        return true
    }
    
    private func prepareInitialVC() {
        let searchVC = SearchViewController()
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.navigationBar.barStyle = .blackTranslucent
        
        window?.rootViewController = navigation
    }
}


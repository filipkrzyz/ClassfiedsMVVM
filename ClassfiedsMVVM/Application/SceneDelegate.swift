//
//  SceneDelegate.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 25/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        var navigationController: UINavigationController
        var viewController: UIViewController
        let layout = UICollectionViewFlowLayout()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Non-first-time user.")
            viewController = WelcomeVC()
            navigationController = UINavigationController(rootViewController: viewController)
        } else {
            print("First-time user.")
            viewController = CategoriesVC(collectionViewLayout: layout)
            navigationController = UINavigationController(rootViewController: viewController)
        }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}


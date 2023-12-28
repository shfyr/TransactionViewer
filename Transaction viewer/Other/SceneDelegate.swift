//
//  SceneDelegate.swift
//  Transaction viewer
//
//  Created by Liza on 27.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene  else { return }

        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()
        let viewController = ProductsTableViewController(presenter: ProductsPresenter())

        navController.viewControllers = [viewController]
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

    }

    iuhiuhuihiuh
}


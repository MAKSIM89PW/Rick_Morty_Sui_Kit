//
//  SceneDelegate.swift
//  Rick&Morty
//
//  Created by Максим Нурутдинов on 22.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = ( scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CharactersView()
        self.window = window
        self.window?.makeKeyAndVisible()
        if let mainViewController = window.rootViewController as? CharactersViewProtocol {
            let mainController = CharactersController(view: mainViewController)
            mainViewController.setController(mainController)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


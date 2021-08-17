//
//  MainCoordinator.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    var identifier: UUID
    var childCoordinators: [UUID : Coordinator]
    
    lazy var rootViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        
        return tabBarController
    }()
    
    // MARK: - Inits

    init(_ sceneWindow: UIWindow) {
        identifier = UUID()
        window = sceneWindow
        childCoordinators = [:]
    }

    // MARK: - Methods
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        initMainCoordinator()
    }
    
    func childDidDisappeared(_ child: Coordinator?) {}
    
    private func initMainCoordinator() {
        let childCoordinator = MainScreenCoordinator(rootViewController: rootViewController)
        
        childCoordinator.start()
        childCoordinators[childCoordinator.identifier] = childCoordinator
    }
    
}

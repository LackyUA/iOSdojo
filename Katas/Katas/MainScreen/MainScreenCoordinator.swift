//
//  MainScreenCoordinator.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

protocol MainCoordinator: class {
    func showKata(atIndex index: Int)
}

final class MainScreenCoordinator: NSObject, Coordinator {
    
    // MARK: - Properties
    
    var identifier: UUID
    var rootViewController: UITabBarController
    var childCoordinators: [UUID : Coordinator]
    
    let rootNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        
        navigationController.tabBarItem = .init(title: "Dojo", image: UIImage(named: "dojo"), tag: 0)
        
        return navigationController
    }()
    
    // MARK: - Initializers
    
    init(rootViewController: UITabBarController) {
        self.identifier = UUID()
        self.childCoordinators = [:]
        self.rootViewController = rootViewController
    }
    
    // MARK: - Methods
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            viewController.coordinator = self
            rootNavigationController.setViewControllers([viewController], animated: false)
            rootViewController.addChild(rootNavigationController)
        }
    }
    
    func childDidDisappeared(_ child: Coordinator?) {
        childCoordinators.removeValue(forKey: (child?.identifier)!)
    }
    
}

extension MainScreenCoordinator: MainCoordinator {
    
    func showKata(atIndex index: Int) {
        guard let kata = KataType(rawValue: index) else { return }
        
        switch kata {
        case .kata1:
            break
            
        case .kata2:
            break
            
        case .kata3:
            break
            
        case .kata4:
            let viewController = Kata4()
            viewController.navBarTitle = kata.title
            rootNavigationController.pushViewController(viewController, animated: true)
        }
    }
    
}

//
//  Coordinator.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    // MARK: - Properties
    
    /// A dictionary that lists all the coordinators under a key that is equal to their ID.
    var childCoordinators: [UUID: Coordinator] { get set }
    
    /// Coordinator unique identifier.
    var identifier: UUID { get }
    
    // MARK: - Methods
    
    /// Method for initialize coordinator`s view.
    func start()
    
    /// Method for deinit child coordinator.
    ///
    /// - Parameter child: Child coordinator which should be deinited.
    func childDidDisappeared(_ child: Coordinator?)
    
}

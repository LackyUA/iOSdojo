//
//  Kata2.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

final class Kata2: UIViewController {
    
    // MARK: - Properties
    
    var navBarTitle: String?
    weak var coordinator: MainCoordinator?
    
    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        view.backgroundColor = .white
        navigationItem.title = navBarTitle
    }

}

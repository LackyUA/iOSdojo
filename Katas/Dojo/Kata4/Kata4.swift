//
//  Kata4.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

final class Kata4: UIViewController {
    
    var navBarTitle: String?

    override func loadView() {
        super.loadView()
        
        navigationItem.title = navBarTitle
    }

}

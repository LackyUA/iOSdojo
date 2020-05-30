//
//  KataType.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import Foundation

enum KataType: Int, CaseIterable {
    
    // MARK: - Cases
    
    case kata1
    case kata2
    case kata3
    case kata4
    
    // MARK: - Computed properties
    
    var title: String {
        switch self {
        case .kata1: return "1st Kata"
        case .kata2: return "2nd Kata"
        case .kata3: return "3rd Kata"
        case .kata4: return "4th Kata"
        }
    }
    
}

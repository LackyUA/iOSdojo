//
//  KataCell.swift
//  Katas
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

final class KataCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var numberView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(with index: Int) {
        numberLabel.text = String(describing: index + 1)
        numberView.layer.masksToBounds = true
    }
    
}

final class CorneredView: UIView {
    
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
        }
    }
    
}

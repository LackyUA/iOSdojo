//
//  AlertHelper.swift
//  Dojo
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

import UIKit

final class AlertHelper {
    
    class func showAlert(vc: UIViewController?, title: String?, message: String?, completionHandler:(() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }

        alert.addAction(okAction)

        DispatchQueue.main.async {
            vc?.present(alert, animated: true)
        }
    }
    
}

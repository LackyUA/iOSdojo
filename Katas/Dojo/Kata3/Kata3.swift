//
//  Kata3.swift
//  Dojo
//
//  Created by Dmytro Dobrovolskyy on 30.05.2020.
//  Copyright © 2020 iOS Dojo. All rights reserved.
//

// Kata:
// Make async image loader form url "http://i.imgur.com/w5rkSIj.jpg".


import UIKit

final class Kata3: UIViewController {
    
    // MARK: - Properties
    
    var navBarTitle: String?
    weak var coordinator: MainCoordinator?
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: 250, height: 350))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.center = view.center
        
        view.addSubview(imageView)
        
        return imageView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }()
    
    // MARK: - Life cycle

    override func loadView() {
        super.loadView()

        navigationItem.title = navBarTitle
        activityIndicator.stopAnimating()
        
        loadImage { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let image):
                self?.imageView.image = image
                
            case .failure(let error):
                AlertHelper.showAlert(vc: self, title: "Uploading image error.", message: error.localizedDescription) { [weak self] in
                    self?.coordinator?.popLastViewController()
                }
            }
        }
    }
    
    // MARK: - Networking
    
    private func loadImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "http://i.imgur.com/w5rkSIj.jpg") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
        }.resume()
    }
    
}

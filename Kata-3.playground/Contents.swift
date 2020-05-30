
// Kata:
// Make async image loader form url "https://shorturl.at/bik24".

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func loadImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let url = URL(string: "http://i.imgur.com/w5rkSIj.jpg") else { return }
    
    URLSession.shared.dataTask(with: url) { (data, _, error) in
        if let error = error {
            completion(.failure(error))
        }
        
        if let data = data, let image = UIImage(data: data) {
            completion(.success(image))
        }
    }.resume()
}

var image = UIImage()

loadImage { result in
    switch result {
    case .success(let downloadedImage):
        image = downloadedImage
        
    case .failure(let error):
        print(error.localizedDescription)
    }
}

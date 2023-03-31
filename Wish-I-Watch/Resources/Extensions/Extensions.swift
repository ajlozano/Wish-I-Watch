//
//  Extensions.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 27/3/23.
//

import UIKit

extension UIImageView {
    func imageFromServerUrl(imageUrl: String?, placeHolderImage: UIImage) {
        if (self.image == nil) {
            self.image = placeHolderImage
        }
        
        if let imgString = imageUrl {
            URLSession.shared.dataTask(with: URL(string: imgString)!) { (data, response, error) in
                if error != nil {
                    return
                }
                
                DispatchQueue.main.async {
                    guard let imageData = data else { return }
                    let image = UIImage(data: imageData)
                    self.image = image
                }
            }.resume()
        } else {
            self.image = placeHolderImage
        }
    }
}

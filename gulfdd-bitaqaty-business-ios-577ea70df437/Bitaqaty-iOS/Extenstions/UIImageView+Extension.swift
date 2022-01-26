//
//  UIImageView+Extension.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/15/21.
//

import Foundation
class ImageStore: NSObject {
    static let imageCache = NSCache<NSString, UIImage>()
}

extension UIImageView {
    func url(_ url: String?, imageD: UIImage) {
        DispatchQueue.global().async { [weak self] in
            guard let stringURL = url, let url = URL(string: stringURL) else {
                return
            }
            func setImage(image:UIImage?) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            let urlToString = url.absoluteString as NSString
            if let cachedImage = ImageStore.imageCache.object(forKey: urlToString) {
                setImage(image: cachedImage)
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageStore.imageCache.setObject(image, forKey: urlToString)
                    setImage(image: image)
                }
            }else {
                setImage(image: imageD)
            }
        }
    }
}

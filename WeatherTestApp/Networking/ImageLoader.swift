//
//  ImageLoader.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 05.06.2025.
//

import UIKit.UIImage

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            onMain { completion(cachedImage) }
            return
        }

        guard let url = URL(string: urlString.addSchemeIfNeeded()) else {
            onMain { completion(nil) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self = self,
                let data = data,
                let image = UIImage(data: data)
            else {
                onMain { completion(nil) }
                return
            }

            self.cache.setObject(image, forKey: urlString as NSString)
            onMain { completion(image) }
        }.resume()
    }

    private init() {}
}

private extension String {
    private enum Scheme {
        static let http = "http:"
        static let https = "https:"
    }
    
    func addSchemeIfNeeded() -> Self {
        if !(hasPrefix(Scheme.http) && hasPrefix(Scheme.https)) {
            return Scheme.https + self
        }
        return self
    }
}

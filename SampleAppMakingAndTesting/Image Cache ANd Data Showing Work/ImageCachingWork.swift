
import Foundation

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        // Set placeholder image
        self.image = placeholder
        
        // Check if image is already cached
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Download the image from the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors and ensure we have image data
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            // Cache the image
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
            
            // Update the UIImageView on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

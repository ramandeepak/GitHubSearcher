//
//  ImageCacheRepository.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit

class ImageCacheRepository {
    
    public static let shared: ImageCacheRepository = ImageCacheRepository()
    
    private var cachedAvatars: [String: Data] = [:]
    
    public func getImageForURL(url: String, completionHandler: @escaping (Data?)->Void) {
        if let imageData = self.cachedAvatars[url] {
            completionHandler(imageData)
        }
        else {
             self.downloadImage(url: url) { data in
                completionHandler(data)
            }
        }
    }
    
    private func downloadImage(url: String, completionHandler: @escaping (Data?)->Void) {
        guard let imageURL = URL(string: url) else {
            completionHandler(nil)
            return
        }
        print("Image is being downloaded...")
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
            guard let imageData = data else {
                completionHandler(nil)
                return
            }
            DispatchQueue.main.async {
                self?.cachedAvatars[url] = imageData
                completionHandler(imageData)
            }
        }.resume()
    }
    
}

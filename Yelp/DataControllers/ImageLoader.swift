//
//  ImageLoader.swift
//  Yelp
//
//  Created by Gokul Sai Katragadda on 10/29/21.
//

import Foundation
import UIKit
import NetworkClient

enum ImageLoadError: Error {
    case invalidURL
    case loadFailed
}

protocol ImageLoader: AnyObject {
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void)
    func cancelLoadImage(url: String)
}

class ImageLoaderImpl: ImageLoader {
    let networkClient: NetworkClient
    let imageCacher: ImageCacher
    
    var inProgressRequests = [URL: URLSessionDataTask]()
    
    init(networkClient: NetworkClient,
         imageCacher: ImageCacher) {
        self.networkClient = networkClient
        self.imageCacher = imageCacher
    }
    
    convenience init() {
        self.init(networkClient: NetworkClientImpl(),
                  imageCacher: ImageCacherImpl())
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            return completion(nil)
        }
        
        let key = self.getKey(from: url)
        if let data = imageCacher.getImageData(for: key), let image = UIImage(data: data) {
            completion(image)
            return
        }
        
        guard inProgressRequests[url] == nil else { return }
        
        let workItem = networkClient.dataTask(with: url) { [weak self] (result: Result<Data, NetworkClientError>) in
            guard let self = self else { return }
            self.inProgressRequests[url] = nil
            DispatchQueue.main.async {
                if case .success(let data) = result, let image = UIImage(data: data) {
                    print("downloaded")
                    self.imageCacher.cacheImageData(data, key)
                    return completion(image)
                }
                return completion(nil)
            }
        }
        inProgressRequests[url] = workItem
    }
    
    func cancelLoadImage(url: String) {
        guard let url = URL(string: url) else { return }
        let workItem = inProgressRequests[url]
        workItem?.cancel()
        inProgressRequests[url] = nil
    }
    
    private func getKey(from url: URL) -> String {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.path.split(separator: "/").joined(separator: "") ?? "food"
    }
}

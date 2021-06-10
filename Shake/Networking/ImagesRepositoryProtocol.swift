//
//  ImagesRepositoryProtocol.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol ImagesRepositoryProtocol {
    func observeImage(for urls: [URL], delegate: ImagesRepositoryDelegate) -> NSObjectProtocol
    func image(for url: URL) -> UIImage?
    func downloadImageIfNeeded(url: URL)
}

protocol ImagesRepositoryDelegate: AnyObject {
    func didDownloadImage(for url: URL, _: ImagesRepositoryProtocol)
}

final class ImagesRepository: ImagesRepositoryProtocol {
    private let cache: URLCache
    private let urlSession: URLSession
    private let notificationCenter: NotificationCenter
    private let notificationName = Notification.Name("ImagesRepositoryNewImage")
    private let notificationURLKey = UUID().uuidString

    init(
        cache: URLCache = .shared,
        urlSession: URLSession = .shared,
        notificationCenter: NotificationCenter = .init()
    ) {
        self.cache = cache
        self.urlSession = urlSession
        self.notificationCenter = notificationCenter
    }

    func observeImage(for urls: [URL], delegate: ImagesRepositoryDelegate) -> NSObjectProtocol {
        return notificationCenter.addObserver(
            forName: notificationName,
            object: self,
            queue: .main
        ) { [weak delegate, weak self] notification in
            guard
                let self = self,
                let url = notification.userInfo?[self.notificationURLKey] as? URL,
                urls.contains(url)
            else { return }
            delegate?.didDownloadImage(for: url, self)
        }
    }

    func image(for url: URL) -> UIImage? {
        let response = cache.cachedResponse(for: URLRequest(url: url))
        guard let data = response?.data else { return nil }
        if let image = UIImage(data: data) {
            return image
        } else {
            cache.removeCachedResponse(for: URLRequest(url: url))
            return nil
        }
    }

    func downloadImageIfNeeded(url: URL) {
        guard cache.cachedResponse(for: URLRequest(url: url)) == nil else { return }
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let response = response,
                let data = data,
                UIImage(data: data) != nil
            else { return }
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
            let notification = Notification(
                name: self.notificationName,
                object: self,
                userInfo: [self.notificationURLKey: url]
            )
            self.notificationCenter.post(notification)
        }.resume()
    }
}

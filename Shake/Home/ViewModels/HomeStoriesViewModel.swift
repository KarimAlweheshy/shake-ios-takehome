//
//  HomeStoriesViewModelProtocol.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol HomeStoriesViewModelProtocol {
    func numberOfStories() -> Int
    func title(at: Int) -> String
    func image(at: Int) -> UIImage?
    func imageContentMode(at: Int) -> UIImageView.ContentMode
    func hasUnwatchedStories(at: Int) -> Bool
}

struct HomeLoadedStoriesViewModel: HomeStoriesViewModelProtocol {
    let users: [User]
    let imagesRepository: ImagesRepositoryProtocol
    let watchedStoriesRepository: WatchedStoriesRepositoryProtocol

    func numberOfStories() -> Int {
        users.count
    }

    func title(at row: Int) -> String {
        guard row > 0 else { return "My story" }
        return users[row].username
    }

    func image(at row: Int) -> UIImage? {
        guard row > 0 else { return UIImage(named: "plus") }
        let urlString = users[row].pictureURL
        let placeholder = UIImage(named: "person-placeholder")
        return URL(string: urlString).flatMap(imagesRepository.image(for:)) ?? placeholder
    }

    func imageContentMode(at row: Int) -> UIView.ContentMode {
        guard row > 0 else { return .center }
        return .scaleAspectFill
    }

    func hasUnwatchedStories(at row: Int) -> Bool {
        guard row > 0 else { return false }
        return users[row].stories.contains { story -> Bool in
            let didWatchVideoIfExists = story.videoURL
                .flatMap(URL.init(string:))
                .flatMap(watchedStoriesRepository.wasURLWatched) ?? true
            let didWatchPhotoIfExists = story.videoURL
                .flatMap(URL.init(string:))
                .flatMap(watchedStoriesRepository.wasURLWatched) ?? true
            return !didWatchVideoIfExists || !didWatchPhotoIfExists
        }
    }
}

struct HomeLoadingStoriesViewModel: HomeStoriesViewModelProtocol {
    func numberOfStories() -> Int {
        6
    }

    func title(at row: Int) -> String {
        guard row > 0 else { return "My story" }
        return ""
    }

    func image(at row: Int) -> UIImage? {
        guard row > 0 else { return UIImage(named: "plus") }
        return UIImage(named: "")
    }

    func imageContentMode(at: Int) -> UIImageView.ContentMode {
        .center
    }

    func hasUnwatchedStories(at row: Int) -> Bool {
        false
    }
}

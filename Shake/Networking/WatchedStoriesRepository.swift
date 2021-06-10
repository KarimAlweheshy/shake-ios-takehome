//
//  WatchedStoriesRepository.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import Foundation

protocol WatchedStoriesRepositoryProtocol {
    func markAsWatched(_: URL)
    func wasURLWatched(_: URL) -> Bool
}

final class WatchedStoriesRepository: WatchedStoriesRepositoryProtocol {
    private let persistenceKey = "WatchedStoriesRepositoryPersistenceKey"

    private let userDefaults: UserDefaults
    private var watchedStories = Set<URL>()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let watchedStories = userDefaults.object(forKey: persistenceKey) as? Set<URL>
        self.watchedStories = watchedStories ?? Set<URL>()
    }

    func markAsWatched(_ url: URL) {
        watchedStories.insert(url)
    }

    func wasURLWatched(_ url: URL) -> Bool {
        watchedStories.contains(url)
    }

    private func persist() {
        userDefaults.set(watchedStories, forKey: persistenceKey)
    }
}

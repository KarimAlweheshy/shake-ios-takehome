//
//  HomeFactory.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

final class HomeFactory {

    private let userService: UserServiceProtocol
    private let imagesRepository: ImagesRepositoryProtocol
    private let watchedStoriesRepository: WatchedStoriesRepositoryProtocol
    private let storiesPlayerFactory: StoriesPlayerFactory

    init(
        userService: UserServiceProtocol,
        imagesRepository: ImagesRepositoryProtocol,
        watchedStoriesRepository: WatchedStoriesRepositoryProtocol,
        storiesPlayerFactory: StoriesPlayerFactory
    ) {
        self.userService = userService
        self.imagesRepository = imagesRepository
        self.watchedStoriesRepository = watchedStoriesRepository
        self.storiesPlayerFactory = storiesPlayerFactory
    }

    func make() -> UIViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! HomeViewController
        let router = HomeRouter(storiesFactory: storiesPlayerFactory)
        let presenter = HomePresenter(
            router: router,
            userService: userService,
            imagesRepository: imagesRepository,
            watchedStoriesRepository: watchedStoriesRepository
        )
        router.view = viewController
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}

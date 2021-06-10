//
//  HomePresenter.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func didTapStory(at row: Int)
}

final class HomePresenter {
    weak var view: HomeView?

    private let router: HomeRouterProtocol
    private let userService: UserServiceProtocol
    private let imagesRepository: ImagesRepositoryProtocol
    private let watchedStoriesRepository: WatchedStoriesRepositoryProtocol

    private var users = [User]()
    private var viewModel: HomeViewModel
    private var observable: NSObjectProtocol?

    init(
        router: HomeRouterProtocol,
        userService: UserServiceProtocol,
        imagesRepository: ImagesRepositoryProtocol,
        watchedStoriesRepository: WatchedStoriesRepositoryProtocol
    ) {
        self.router = router
        self.userService = userService
        self.imagesRepository = imagesRepository
        self.watchedStoriesRepository = watchedStoriesRepository
        self.viewModel = HomeViewModel(
            storiesViewModel: HomeLoadingStoriesViewModel(),
            feedViewModel: HomeLoadingFeedViewModel()
        )
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        userService.getUsers { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let users):
                    self.users = users.users
                    self.updateViewModel(users: users.users)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }

    func didTapStory(at row: Int) {
        router.showStories(user: users[row])
    }
}

// MARK: - ImagesRepositoryDelegate

extension HomePresenter: ImagesRepositoryDelegate {
    func didDownloadImage(for url: URL, _: ImagesRepositoryProtocol) {
        view?.update(viewModel: viewModel)
    }
}

// MARK: - Private Methods

extension HomePresenter {
    private func updateViewModel(users: [User]) {
        let urls = users
            .map(\.pictureURL)
            .compactMap(URL.init(string:))
        observable = imagesRepository.observeImage(for: urls, delegate: self)
        urls.forEach(imagesRepository.downloadImageIfNeeded(url:))
        let storiesViewModel = HomeLoadedStoriesViewModel(
            users: users,
            imagesRepository: imagesRepository,
            watchedStoriesRepository: watchedStoriesRepository
        )
        viewModel = HomeViewModel(
            storiesViewModel: storiesViewModel,
            feedViewModel: HomeLoadingFeedViewModel()
        )
        view?.update(viewModel: viewModel)
    }
}

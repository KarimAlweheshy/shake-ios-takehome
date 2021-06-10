//
//  StoriesPlayerPresenter.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol StoriesPlayerPresenterProtocol {
    func viewDidLoad()
    func didTapClose()
    func didTapNext()
    func didTapPrevious()
}

final class StoriesPlayerPresenter {
    weak var view: StoriesPlayerView?

    private let user: User
    private let imageRepository: ImagesRepositoryProtocol

    private var imageDownloadObservable: NSObjectProtocol?
    private var currentStoryIndex = 0 {
        didSet {
            guard oldValue + currentStoryIndex == 0 || oldValue != currentStoryIndex else { return }
            updateView()
        }
    }

    init(
        user: User,
        imageRepository: ImagesRepositoryProtocol
    ) {
        self.user = user
        self.imageRepository = imageRepository
    }
}

// MARK: - StoriesPlayerPresenterProtocol

extension StoriesPlayerPresenter: StoriesPlayerPresenterProtocol {
    func viewDidLoad() {
        downloadAllImages()
        updateView()
    }

    func didTapClose() {
        view?.dismiss()
    }

    func didTapNext() {
        guard currentStoryIndex + 1 != user.stories.count else {
            view?.dismiss()
            return
        }
        currentStoryIndex = min(user.stories.count - 1, currentStoryIndex + 1)
    }

    func didTapPrevious() {
        currentStoryIndex = max(0, currentStoryIndex - 1)
    }
}

// MARK: - ImagesRepositoryDelegate

extension StoriesPlayerPresenter: ImagesRepositoryDelegate {
    func didDownloadImage(for url: URL, _: ImagesRepositoryProtocol) {
        updateView()
    }
}

// MARK: - Private Methods

extension StoriesPlayerPresenter {
    private func downloadAllImages() {
        let currentUserImageURL = URL(string: user.pictureURL)
        let urls = user.stories.compactMap { currentStory in
            currentStory.imageURL.flatMap(URL.init(string:))
        }
        let allImagesURLs = ([currentUserImageURL] + urls).compactMap { $0 }
        imageDownloadObservable = imageRepository.observeImage(for: allImagesURLs, delegate: self)
        allImagesURLs.forEach(imageRepository.downloadImageIfNeeded(url:))
    }

    private func updateView() {
        let currentUserImageURL = URL(string: user.pictureURL)
        let placeholder = UIImage(named: "person-placeholder")!
        let currentStory = user.stories[0]
        let currentImage = currentUserImageURL.flatMap(imageRepository.image(for:))
        let currentStoryImage = currentStory.imageURL.flatMap(URL.init(string:))
        let currentViewModel = StoriesPlayerViewModel(
            currentImage: currentStoryImage.flatMap(imageRepository.image(for:)) ?? placeholder,
            currentPosition: 0,
            currentVideoURL: currentStory.videoURL.flatMap(URL.init(string:)),
            totalPositions: user.stories.count,
            userImage: currentImage ?? placeholder,
            userName: user.username
        )
        view?.set(viewModel: currentViewModel)
    }
}

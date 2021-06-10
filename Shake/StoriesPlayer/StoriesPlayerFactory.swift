//
//  StoriesPlayerFactory.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

final class StoriesPlayerFactory {
    private let imageRepository: ImagesRepositoryProtocol

    init(imageRepository: ImagesRepositoryProtocol) {
        self.imageRepository = imageRepository
    }

    func make(user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "StoriesPlayer", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! StoriesPlayerViewController
        let presenter = StoriesPlayerPresenter(
            user: user,
            imageRepository: imageRepository
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}

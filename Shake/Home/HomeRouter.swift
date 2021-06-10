//
//  HomeRouter.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol {
    func showStories(user: User)
}

final class HomeRouter {
    var view: UIViewController?
    private let storiesFactory: StoriesPlayerFactory

    init(storiesFactory: StoriesPlayerFactory) {
        self.storiesFactory = storiesFactory
    }
}

// MARK; - HomeRouterProtocol

extension HomeRouter: HomeRouterProtocol {
    func showStories(user: User) {
        let viewController = storiesFactory.make(user: user)
        view?.present(viewController, animated: true, completion: nil)
    }
}

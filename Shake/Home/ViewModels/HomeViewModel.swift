//
//  HomeViewModel.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import Foundation

final class HomeViewModel {
    let storiesViewModel: HomeStoriesViewModelProtocol
    let feedViewModel: HomeFeedViewModelProtocol

    init(
        storiesViewModel: HomeStoriesViewModelProtocol,
        feedViewModel: HomeFeedViewModelProtocol
    ) {
        self.storiesViewModel = storiesViewModel
        self.feedViewModel = feedViewModel
    }
}


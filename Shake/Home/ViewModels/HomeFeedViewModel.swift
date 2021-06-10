//
//  HomeFeedViewModel.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol HomeFeedViewModelProtocol {
    var shouldShowLoading: Bool { get }

    func numberOfCells() -> Int
}

final class HomeLoadingFeedViewModel: HomeFeedViewModelProtocol {
    let shouldShowLoading = true

    func numberOfCells() -> Int {
        4
    }
}

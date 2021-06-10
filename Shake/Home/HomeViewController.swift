//
//  HomeViewController.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol HomeView: AnyObject {
    func update(viewModel: HomeViewModel)
}

final class HomeViewController: UIViewController {
    var presenter: HomePresenterProtocol!
    private var viewModel: HomeViewModel!

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "shake"))
        presenter.viewDidLoad()
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
    func update(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel == nil ? 0 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.feedViewModel.numberOfCells()
        default: fatalError("Should never arrive here")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "HomeStoriesCollectionCell",
                for: indexPath
            ) as! HomeStoriesCollectionCell
            cell.update(viewModel: viewModel.storiesViewModel)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "HomeFeedItemCell",
                for: indexPath
            ) as! HomeFeedItemCell
            cell.loadingViews.forEach {
                viewModel.feedViewModel.shouldShowLoading
                    ? $0.showLoadingSkeleton()
                    : $0.removeLoadingSkeleton()
            }
            return cell
        default: fatalError("Should never arrive here")
        }
    }
}

extension HomeViewController: HomeStoriesCollectionCellDelegate {
    func didTapCell(at row: Int) {
        presenter.didTapStory(at: row)
    }
}

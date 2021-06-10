//
//  HomeStoriesCollectionCell.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol HomeStoriesCollectionCellDelegate: AnyObject {
    func didTapCell(at row: Int)
}

final class HomeStoriesCollectionCell: UITableViewCell {
    weak var delegate: HomeStoriesCollectionCellDelegate?

    @IBOutlet var collectionView: UICollectionView!

    private var viewModel: HomeStoriesViewModelProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    func update(viewModel: HomeStoriesViewModelProtocol) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeStoriesCollectionCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.numberOfStories() ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HomeStoryCell",
            for: indexPath
        ) as! HomeStoryCell
        cell.storyImageView.image = viewModel.image(at: indexPath.row)
        cell.storyImageView.contentMode = viewModel.imageContentMode(at: indexPath.row)
        cell.storyIndicatorImageView.image = viewModel.hasUnwatchedStories(at: indexPath.row)
            ? UIImage(named: "NewStoryIndicator")
            : UIImage(named: "NoNewStoryIndicator")
        cell.titleLabel.text = viewModel.title(at: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeStoriesCollectionCell: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        delegate?.didTapCell(at: indexPath.row)
    }
}

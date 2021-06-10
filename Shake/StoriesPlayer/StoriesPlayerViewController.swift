//
//  StoriesPlayerViewController.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

protocol StoriesPlayerView: AnyObject {
    func set(viewModel: StoriesPlayerViewModel)
    func dismiss()
}

final class StoriesPlayerViewController: UIViewController {
    var presenter: StoriesPlayerPresenterProtocol!

    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var counterStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: - Actions

extension StoriesPlayerViewController {
    @IBAction private func didTapClose() {
        presenter.didTapClose()
    }

    @IBAction private func didTapNext() {
        presenter.didTapNext()
    }

    @IBAction private func didTapPrevious() {
        presenter.didTapPrevious()
    }
}

// MARK: - StoriesPlayerView

extension StoriesPlayerViewController: StoriesPlayerView {
    func set(viewModel: StoriesPlayerViewModel) {
        userNameLabel.text = viewModel.userName
        userImageView.image = viewModel.userImage
        counterStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        (0..<viewModel.totalPositions).forEach { _ in
            let view = StoryTimeView()
            counterStackView.addArrangedSubview(view)
        }
        counterStackView.arrangedSubviews.enumerated().forEach { index, view in
            let view = view as! StoryTimeView
            if index == viewModel.currentPosition {
                view.setFull()
            } else {
                view.setShouldFill { [weak self] in
                    self?.presenter.didTapNext()
                }
            }
        }
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

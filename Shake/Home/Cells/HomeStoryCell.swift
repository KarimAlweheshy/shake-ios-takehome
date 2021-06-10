//
//  HomeStoryCell.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

final class HomeStoryCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var storyIndicatorImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        storyImageView.backgroundColor = ColorsProvider().grey04
        storyImageView.clipsToBounds = true
        storyIndicatorImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        storyImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        storyImageView.layer.cornerRadius = storyImageView.frame.height / 2
        storyIndicatorImageView.layer.cornerRadius = storyIndicatorImageView.frame.height / 2
    }
}

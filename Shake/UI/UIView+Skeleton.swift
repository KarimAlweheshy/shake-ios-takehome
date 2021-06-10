//
//  UIView+Skeleton.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

private let skeletonTag = UUID().uuidString

extension UIView {
    func showLoadingSkeleton() {
        if let imageView = self as? UIImageView {
            if imageView.image != nil {
                imageView.tintColor = ColorsProvider().grey04
                return
            }
        }

        let skeletonView = UIView(frame: frame)
        skeletonView.backgroundColor = ColorsProvider().grey04
        skeletonView.tag = skeletonTag.hash
        skeletonView.clipsToBounds = clipsToBounds

        addSubview(skeletonView)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false

        if self is UILabel || self is UITextField {
            skeletonView.layer.cornerRadius = 8
            skeletonView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            skeletonView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        } else {
            skeletonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            skeletonView.layer.cornerRadius = layer.cornerRadius
        }
        skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        skeletonView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func removeLoadingSkeleton() {
        let skeletonView = subviews.first { $0.tag == skeletonTag.hash }
        skeletonView?.removeFromSuperview()
    }
}

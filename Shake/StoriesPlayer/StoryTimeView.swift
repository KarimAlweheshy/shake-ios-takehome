//
//  StoryTimeView.swift
//  Shake
//
//  Created by Karim Alweheshy on 6/10/21.
//  Copyright © 2021 Takeoff Labs, Inc. All rights reserved.
//

import UIKit

final class StoryTimeView: UIView {

    func setFull() {
        backgroundColor = .white
    }

    func setShouldFill(callback: @escaping () -> Void) {
        backgroundColor = ColorsProvider().grey04
        layoutIfNeeded()
        let overlay = UIView()
        overlay.backgroundColor = .white
        addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.topAnchor.constraint(equalTo: topAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        overlay.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        let trailingConstraint = overlay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: frame.width)
        layoutIfNeeded()
        trailingConstraint.constant = 0
        UIView.animate(withDuration: 4) {
            self.layoutIfNeeded()
        } completion: { isFinished in
            guard isFinished else { return }
//            callback()
        }
    }
}

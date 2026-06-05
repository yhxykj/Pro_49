//
//  LiveNoticeLabel.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class LiveNoticeLabel: UILabel {
    private let textInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override func textRect(
        forBounds bounds: CGRect,
        limitedToNumberOfLines numberOfLines: Int
    ) -> CGRect {
        let insetBounds = bounds.inset(by: textInsets)
        let rect = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        return rect.inset(
            by: UIEdgeInsets(
                top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right
            )
        )
    }
}

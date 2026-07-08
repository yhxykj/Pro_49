//
//  MyProfileTitleFont.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

extension UIFont {
    static func myProfilePageTitleFont(ofSize size: CGFloat) -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: size, weight: .bold)
        guard let descriptor = baseFont.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return baseFont
        }
        return UIFont(descriptor: descriptor, size: size)
    }
}

//
//  UIView+.swift
//  SSAC-Advanced-Project
//
//  Created by heerucan on 2022/10/21.
//

import UIKit

extension UIView {
    func addSubviews(_ components: [UIView]) {
        components.forEach { self.addSubview($0) }
    }
}

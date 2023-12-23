//
//  UIView-ext.swift
//  Flash Chat iOS13
//
//  Created by macbook on 18.12.2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}

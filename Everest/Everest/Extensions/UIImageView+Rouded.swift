//
//  UIImageView.swift
//  Everest
//
//  Created by Kaushik on 10/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
